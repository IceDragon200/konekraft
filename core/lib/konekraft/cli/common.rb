require 'colorize'

module Konekraft
  module Cli
    def initialize_cli
      @env_table = { }
      @line_number = 1
      @prompt_heading = "konekraft"
    end

    def increment_line_number
      @line_number += 1
    end

    def parse_commands(str)
      return to_enum :parse_commands, str unless block_given?

      str.to_s.each_line do |line|
        l = subsitute_env(line.strip.gsub(/\#(.*)\z/, ''))
        cmd = []

        i = 0
        str = ''
        mode = nil
        while i < l.size
          c = l[i]
          case mode
          when :string_dquote
            case c
            when '"'
              cmd << str
              str = ''
              mode = nil
            else
              str << c
            end
          when :string_squote
            case c
            when "'"
              cmd << str
              str = ''
              mode = nil
            else
              str << c
            end
          else
            case c
            when '"'
              mode = :string_dquote
            when "'"
              mode = :string_squote
            when /\s/
              cmd << str
              str = ''
            else
              str << c
            end
          end
          i += 1
        end

        cmd << str unless str.empty?

        unless cmd.empty?
          yield cmd, l
          increment_line_number
        end
      end
    end

    def to_commands(str)
      return to_enum :to_commands, str unless block_given?
      str.to_s.chomp.each_line do |line|
        l = line.strip.gsub(/\#(.*)\z/, '')
        unless l.empty?
          yield l
          increment_line_number
        end
      end
    end

    def prompt
      print "#{@prompt_heading}:#{"%03d" % @line_number}~> ".light_green
    end

    def log_error(str)
      puts "!!! ".light_red << str
    end

    def subsitute_env(str)
      str.gsub(/\$([A-Z0-9_]+)/i) { @env_table[$1] }
    end
  end
end
