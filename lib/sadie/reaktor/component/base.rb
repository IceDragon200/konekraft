#
# Sadie/lib/sadie/reaktor/component/base.rb
#   by IceDragon
#   dc 11/03/2013
#   dm 15/08/2013
module Sadie
  module Reaktor
    class Base

      ### constants
      VERSION = "2.2.0".freeze

      include Reaktor
      include Sadie::Callback

      ### instance_attributes
      attr_accessor :id       # Integer
      attr_accessor :name     # String
      attr_reader :energy     # Sadie::Energy
      attr_reader :port       # Hash<PORT_ID, Reaktor*>
      attr_reader :stats      # Hash<Symbol, Object*>
      attr_reader :ticks      # int
      attr_reader :post_ticks # int
      # verbose log output
      attr_accessor :vlog # IO

      ##
      # initialize
      def initialize
        init_ticks
        init_id
        init_name
        init_stats
        init_callbacks
        init_energy
        init_ports
        init
      end

      ##
      # init_ticks
      def init_ticks
        @ticks = 0
        @post_ticks = 0
      end

      ##
      # init_id
      def init_id
        @id = 0
      end

      ##
      # init_name
      def init_name
        @name = self.class.registered_name.dup
      end

      ##
      # init_stats
      def init_stats
        @stats = {
          react_count: 0,
          react_null_count: 0,
          react_abs_count: 0,
          emit_count: 0,
          emit_null_count: 0,
          emit_abs_count: 0,
        }
      end

      ##
      # init_energy
      def init_energy
        @energy = Sadie::Reaktor::Energy.new
      end

      ##
      # init_ports
      def init_ports
        @port = {}
        port_specs = self.class.port_spec
        port_specs.each_pair do |_, portspec|
          @port[portspec.id] = Port.new(self, portspec)
        end
      end

      ##
      # init
      def init
        # initialize the internals of the reaktor here
        try_vlog { |io| io.puts "#{signature_s} [INIT]" }
      end

      ##
      # terminate
      def terminate
        # used to dispose the reaktor
        try_vlog { |io| io.puts "#{signature_s} [TERMINATE]" }
      end

      ##
      # signature_s -> String
      def signature_s
        "#{id}|#{name}"
      end

      ##
      # export_h -> Hash
      def export_h
        { energy: @energy.to_s }
      end

      ##
      # export_s -> String
      def export_s
        export_h.to_s
      end

      ##
      # ports -> Array<Port>
      def ports
        @port.values
      end

      ##
      # get_port(PORT_ID id) -> Port
      def get_port(id)
        if port_valid?(id)
          @port[id]
        else
          raise RuntimeError, "port (#{id}) does not exist for #{self}"
        end
      end

      ##
      # inputs -> Array<Port>
      def inputs
        ports.select(&:input?)
      end

      ##
      # outputs -> Array<Port>
      def outputs
        ports.select(&:output?)
      end

      ##
      # port_valid?(PORT_ID port_id)
      def port_valid?(port_id)
        @port.has_key?(port_id)
      end

      ##
      # port_type_valid?(PORT_ID port_id, Symbol type)
      def port_type_valid?(port_id, type)
        port_valid?(port_id) && @port[port_id].valid_type?(type)
      end

      ##
      # port_connected?(PORT_ID port_id)
      def port_connected?(port_id)
        !@port[port_id].nil?
      end

      ##
      # reset
      def reset
        # restore component to some original state
        try_vlog { |io| io.puts "#{signature_s} [RESET]" }
      end

      ##
      # emit_energy -> Energy
      def emit_energy
        # do something with the energy before using it for emission, for example
        # making a clone, when using an EmitterReaktor
        @energy
      end

      ##
      # emit_energy_null -> Energy
      def emit_energy_null
        Sadie::Reaktor::Energy.new
      end

      ##
      # trigger
      def trigger
        # have this Reaktor act on its own, only used by stand-alone reaktors
        try_vlog { |io| io.puts "#{signature_s} [TRIGGER]" }
      end

      ##
      # tick
      def tick
        # update the reaktor internals, regardless of connection state
        try_vlog { |io| io.puts "#{signature_s} [TICK]" }
        @ticks += 1
      end

      ##
      # post_tick
      def post_tick
        # update the reaktor internals, regardless of connection state
        try_vlog { |io| io.puts "#{signature_s} [TICK-POST]" }
        @post_ticks += 1
      end

      ##
      # react_port(Port port, Energy energy)
      def react_port(port, energy)
        #
        try_vlog { |io| io.puts "#{signature_s} [Rp=] (#{energy.to_s} >> #{port.to_s})" }
      end

      ##
      # react(PORT_ID port_id, Energy energy)
      def react(port_id, energy)
        # react from another reaktor
        # handle the port_id and act on the given energy value
        port = @port[port_id]
        if port_type_valid?(port_id, :in)
          try_vlog { |io| io.puts "#{signature_s} [R+] (#{energy.to_s} >> #{port_id}|#{port.to_s}) / #{export_s}" }
          react_port(port, energy)
          try_callback(:on_react, self, port, energy)
          @stats[:react_count] += 1
        else
          try_vlog { |io| io.puts "#{signature_s} [R-] (#{energy.to_s} >> #{port_id}|#{port.to_s}) / #{export_s}" }
          @stats[:react_null_count] += 1
        end
        try_vlog { |io| io.puts "#{signature_s} [R=] (#{energy.to_s} >> #{port_id}|#{port.to_s}) / #{export_s}" }
        try_callback(:on_react_abs, self, port, energy)
        @stats[:react_abs_count] += 1
      end

      ##
      # emit_port(Port port, Energy energy)
      def emit_port(port, energy)
        try_vlog { |io| io.puts "#{signature_s} [Ep=] (#{energy.to_s} >> #{port.to_s})" }
        port.client_send(energy)
      end

      ##
      # emit(PORT_ID port_id, Energy energy)
      def emit(port_id, energy=emit_energy)
        # default emission action
        port = @port[port_id]
        if port_type_valid?(port_id, :out)
          try_vlog { |io| io.puts "#{signature_s} [E+]( #{energy.to_s} >> #{port_id}|#{port.to_s})" }
          emit_port(port, energy)
          try_callback(:on_emit, self, port, energy)
          @stats[:emit_count] += 1
        else
          try_vlog { |io| io.puts "#{signature_s} [E-] (#{energy.to_s} >> #{port_id}|#{port.to_s})" }
          @stats[:emit_null_count] += 1
        end
        try_vlog { |io| io.puts "#{signature_s} [E=] (#{energy.to_s} >> #{port_id}|#{port.to_s})" }
        try_callback(:on_emit_abs, self, port, energy)
        @stats[:emit_abs_count] += 1
      end

      ##
      # port_spec(Symbol name) -> PortSpec
      def port_spec(name)
        self.class.port_spec[name]
      end

      ##
      # vlog -> IO
      def vlog
        @vlog || self.class.vlog || Sadie::Reaktor::Base.vlog
      end

      ##
      # vlog=(IO new_log_io)
      def vlog=(new_log_io)
        @vlog = new_log_io
      end

      ##
      # try_vlog -> IO
      def try_vlog
        if io = vlog
          yield io
        end
      end

      ##
      # ::vlog -> IO
      def self.vlog
        @vlog
      end

      ##
      # ::vlog=(IO new_log_io)
      def self.vlog=(new_log_io)
        @vlog = new_log_io
      end

      ### Reaktor Registration
      ##
      # ::registered_name -> String
      def self.registered_name
        @registered_name
      end

      ##
      # ::register(String name)
      def self.register(name)
        @registered_name = name
        Sadie::Reaktor.register(self, @registered_name)
      end

      ### Reaktor Settings
      ##
      # ::port_spec -> Hash<Symbol name, PortSpec port_spec>
      def self.port_spec
        @port_spec ||= {}
      end

      ##
      # ::register_port(Integer/Symbol id, Symbol name)
      def self.register_port(type, id, name)
        port_spec[id] = PortSpec.new(id, name, type)
      end


      private :initialize
      private :init_id
      private :init_name
      private :init_stats
      private :init_callbacks
      private :init_energy
      private :init_ports
      private :init

      private :emit_energy
      private :emit_energy_null
      private :emit_port
      private :react_port

      alias :/ :get_port

      #class << self
      #  private :new
      #end

    end
  end
end
