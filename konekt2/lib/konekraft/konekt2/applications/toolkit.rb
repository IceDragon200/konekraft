require 'konekraft/version'
require 'konekraft/konekt2'
require 'konekraft/konekt2/version'
require 'konekraft/cli/common'
require 'yaml'

module Konekraft
  module Konekt2
    module Applications
      class Toolkit
        include Konekraft::Cli

        def initialize
          initialize_cli
          @networks = []
          @prompt_heading = "konekt2"
        end

        def keyword_new
          "new".magenta
        end

        def find_network(network_id)
          network = @networks[network_id]
          if network
            yield network if block_given?
          else
            log_error "network[#{network_id}] not found"
          end
          network
        end

        def find_component(network, opts)
          component = network.find(opts)
          if component
            yield component if block_given?
          else
            log_error "[#{network.id_s}] ".light_blue << "component[#{opts}] not found"
          end
          component
        end

        def find_component_class(component_type)
          begin
            component_klass = Konekraft::Konekt2.find(component_type)
            yield component_klass
            return component_klass
          rescue KeyError
            log_error "component type[#{component_type}] not found"
            return nil
          end
        end

        def process_command(cmd, line)
          command, *params = cmd
          case command
          when 'env'
            @env_table.each do |k, v|
              puts "#{k}=#{v}"
            end
          when 'unset'
            @env_table.delete(params.first)
          when 'set'
            key, value = params
            @env_table[key] = value
          when 'echo'
            puts line.gsub(/\Aecho\s+/, '')
          when 'run'
            t = 0
            d = "..ili".split("")
            idle_anim = d.size.times.map { |i| d.rotate(-i).join }
            begin
              loop do
                @networks.each(&:step)
                sleep (1.0 / 60)
                t += 1
                print "\rRunning [#{idle_anim[t % idle_anim.size]}] #{t}"
              end
            rescue Interrupt
            end
            puts "\rRan for #{t} ticks                "
          when 'step'
            @networks.each(&:step)
          when 'status'
            @networks.each do |network|
              puts "[#{network.id_s}] ".light_blue << "ticks=#{network.ticks}"
              network.components.each do |component|
                puts "  #{component.id_s} ".light_blue << component.export_h.map{|k,v|"#{k}=#{v}"}.join(" ")
              end
            end
          when 'new'
            sub_command = params.first
            sub_params = params[1, params.size]
            case sub_command
            when 'network'
              network = Konekraft::Konekt2::Network.new
              network.vlog = STDERR
              network.id = @networks.size
              @networks << network
              @env_table["last_network_id"] = network.id.to_s
              puts "#{keyword_new} Network #{network.id_s}"
            when 'component'
              network_id     = sub_params[0].to_i
              component_type = sub_params[1]
              is_main        = sub_params[2] == 'main'
              find_network(network_id) do |network|
                find_component_class(component_type) do |component_klass|
                  component = network.add_from_class(component_klass, is_main)
                  @env_table["last_component_id"] = "#{component.id}"
                  puts "[#{network.id_s}] ".light_blue << "#{keyword_new} #{is_main ? "main " : ""}Konekt #{component.id_s}"
                end
              end
            else
              log_error "Unknown sub command '#{sub_command}' for '#{command}'"
            end
          when 'connect'
            sub_command = params.first
            sub_params = params[1, params.size]
            case sub_command
            when 'component'
              network_id               = sub_params[0].to_i

              output_component_id      = sub_params[1].to_i
              output_component_port_id = sub_params[2]

              connection_method        = sub_params[3]

              input_component_id       = sub_params[4].to_i
              input_component_port_id  = sub_params[5]

              find_network(network_id) do |network|
                ocomponent = find_component(network, id: output_component_id)
                return unless ocomponent
                icomponent = find_component(network, id: input_component_id)
                return unless icomponent
                out_port = ocomponent/output_component_port_id.to_sym
                in_port  = icomponent/input_component_port_id.to_sym
                case connection_method
                when '<'
                  out_port < in_port
                when '>'
                  out_port > in_port
                when '|'
                  out_port | in_port
                else
                  return log_error "Unknown connection method #{connection_method}"
                end
                puts "[#{network.id_s}] ".light_blue << "connected #{ocomponent.id_s}/#{out_port.name} to #{icomponent.id_s}/#{in_port.name}"
              end
            else
              log_error "Unknown sub command '#{sub_command}' for '#{command}'"
            end
          when 'property'
            sub_command = params.first
            sub_params = params[1, params.size]
            network_id   = sub_params[0].to_i
            component_id = sub_params[1].to_i
            property_key = sub_params[2]

            find_network(network_id) do |network|
              find_component(network, id: component_id) do |component|
                case sub_command
                when 'get'
                  begin
                    puts @env_table["0"] = component.property_get(property_key)
                  rescue KeyError => ex
                    print "[#{network.id_s}][#{component.id_s}] ".light_blue
                    log_error ex.message
                  end
                when 'set'
                  property_val = sub_params[3]
                  begin
                    component.property_set(property_key, property_val)
                  rescue KeyError => ex
                    print "[#{network.id_s}][#{component.id_s}] ".light_blue
                    log_error ex.message
                  end
                else
                  log_error "Unknown sub command '#{sub_command}' for '#{command}'"
                end
              end
            end
          when 'ls'
            sub_command = params.first
            sub_params = params[1, params.size]

            network_id = sub_params[0].to_i

            case sub_command
            when 'component-ports'
              component_id = sub_params[1].to_i
              find_network(network_id) do |network|
                find_component(network, id: component_id) do |component|
                  puts "=> component.ports #{component.name}"
                  component.ports.each do |port|
                    puts port.to_s
                  end
                end
              end
            when 'components'
              find_network(network_id) do |network|
                puts "=> components (main)"
                network.component_mains.each do |r|
                  puts "[#{network.id_s}] ".light_blue << "#{r.id_s}"
                end
                puts "=> components"
                network.components.each do |r|
                  puts "[#{network.id_s}] ".light_blue << "#{r.id_s}"
                end
              end
            when 'networks'
              puts "=> networks"
              @networks.each do |n|
                puts "#{n.id_s}"
              end
            else
              log_error "Unknown sub command '#{sub_command}' for '#{command}'"
            end
          when 'save'
            sub_command = params.first
            sub_params = params[1, params.size]

            case sub_command
            when 'rktm'
              filename = sub_params.first
              File.open(filename, "w") { |f| f.write(networks.map(&:to_rktm_h).to_yaml) }
            else
              log_error "Unknown sub command '#{sub_command}' for '#{command}'"
            end
          when 'quit'
            throw :quit
          when 'help'
            puts "too lazy to implement it"
          else
            log_error "unknown command: (#{command})"
          end
        end

        def run(argv)
          puts "Konekt Interactive Toolkit"
          puts "Konekraft Version #{Konekraft::VERSION}"
          puts "Konekraft::Konekt2 Version #{Konekraft::Konekt2::VERSION}"
          catch :quit do
            if argv.empty?
              loop do
                prompt
                parse_commands(gets) { |cmd, line| process_command(cmd, line) }
              end
            else
              in_filename = ARGV.first
              parse_commands(File.read(in_filename)) do |cmd, line|
                prompt
                puts "#{line}"
                process_command(cmd, line)
              end
            end
          end
        end
      end
    end
  end
end

