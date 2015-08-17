#
# Konekraft/lib/konekraft/konekt2/component/base.rb
#
require 'konekraft/internal/callbacks'
require 'konekraft/konekt2/mixin/konektable'

module Konekraft
  module Konekt2
    class Base

      ### constants
      VERSION = "2.2.0".freeze

      include Konekraft::Callbacks
      include Konekraft::Konekt2::Mixin::Konektable

      ### instance_attributes
      attr_accessor :id       # Integer
      attr_accessor :name     # String
      attr_reader :energy     # Konekraft::Energy
      attr_reader :port       # Hash<PORT_ID, Konekt*>
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
        @energy = Konekraft::Konekt2::Energy.new
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

      def to_rktm_h
        {
          "TYPE"       => self.class.registered_name,
          "id"         => @id,
          "name"       => @name,
          "energy"     => @energy.to_rktm_h,
          "port"       => Hash[@port.map { |k,v| [k,v.to_rktm_h] }],
          "stats"      => @stats,
          "ticks"      => @ticks,
          "post_ticks" => @post_ticks,
        }
      end

      def import_rktm_h(hsh)
        @id         = hsh["id"]
        @name       = hsh["name"]
        @energy     = Konekraft::Konekt2::Energy.load_rktm_h(hsh["energy"])
        @port       = Hash[hsh["port"].map { |k,v| [k, Port.load_rktm_h(v)] }]
        @stats      = hsh["stats"]
        @ticks      = hsh["ticks"]
        @post_ticks = hsh["post_ticks"]
      end

      def bool_parse(str)
        case str
        when "on", "true", "yes", "1"  then true
        when "off", "false", "no", "0" then false
        else                                false
        end
      end

      def property_get(key)
        case key.to_s
        when "energy"     then @energy.to_i
        when "post_ticks" then @post_ticks
        when "ticks"      then @ticks
        else                   raise KeyError, "could not find property #{key}"
        end
      end

      def property_set(key, value)
        case key.to_s
        when "energy"     then @energy.set(value.to_i)
        when "post_ticks" then @post_ticks = value.to_i
        when "ticks"      then @ticks = value.to_i
        else                   raise KeyError, "could not find property #{key}"
        end
      end

      ##
      # export_h -> Hash
      def export_h
        { ticks: @ticks, post_ticks: @post_ticks, energy: @energy.to_s }
      end

      def id_s
        "#{@id}:#{@name}"
      end

      ##
      # export_s -> String
      def export_s
        export_h.to_s
      end

      ##
      # indent_s
      def indent_s
        " " * Konekraft::Konekt2::Base.indent.to_i * 2
      end

      ##
      # signature_s -> String
      def signature_s
        "#{id}|#{name}"
      end

      ##
      # poll_s(String s, Energy energy, PORT_ID port_id, Port port)
      def debug_s(s, energy, port_id, port)
        indent_s + "[#{s}] #{signature_s}(#{energy.to_s} >> [#{port_id}|#{port.to_s}])"
      end

      ##
      # react_s(String s, Energy energy, PORT_ID port_id, Port port)
      def react_s(s, energy, port_id, port)
        debug_s(s, energy, port_id, port) + " / " + export_s
      end

      ##
      # emit_s(String s, Energy energy, PORT_ID port_id, Port port)
      def emit_s(s, energy, port_id, port)
        debug_s(s, energy, port_id, port)
      end

      ##
      # init
      def init
        # initialize the internals of the konekt here
        try_vlog { |io| io.puts indent_s + "[INT] #{signature_s}" }
      end

      ##
      # terminate
      def terminate
        # used to dispose the konekt
        try_vlog { |io| io.puts indent_s + "[TRM] #{signature_s}" }
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
        try_vlog { |io| io.puts indent_s + "[RST] #{signature_s}" }
      end

      ##
      # emit_energy -> Energy
      def emit_energy
        # do something with the energy before using it for emission, for example
        # making a clone, when using an EmitterKonekt
        @energy
      end

      ##
      # emit_energy_null -> Energy
      def emit_energy_null
        Konekraft::Konekt2::Energy.new
      end

      ##
      # trigger
      def trigger
        # have this Konekt act on its own, only used by stand-alone konekts
        try_vlog { |io| io.puts indent_s + "[trigger] #{signature_s}" }
      end

      ##
      # tick
      def tick
        # update the konekt internals, regardless of connection state
        try_vlog { |io| io.puts indent_s + "[tick] #{signature_s}" }
        @ticks += 1
      end

      ##
      # post_tick
      def post_tick
        # update the konekt internals, regardless of connection state
        try_vlog { |io| io.puts indent_s + "[post_tick] #{signature_s}" }
        @post_ticks += 1
      end

      ##
      # react_port(Port port, Energy energy)
      def react_port(port, energy)
        #
        try_vlog { |io| io.puts react_s("Rp=", energy, port.id, port) }
      end

      ##
      # react(PORT_ID port_id, Energy energy)
      def react(port_id, energy)
        # react from another konekt
        # handle the port_id and act on the given energy value
        port = @port[port_id]
        if port_type_valid?(port_id, :in)
          Konekraft::Konekt2::Base.indent do
            try_vlog { |io| io.puts react_s("R +", energy, port_id, port) }
            react_port(port, energy)
          end
          try_callback(:on_react, self, port, energy)
          @stats[:react_count] += 1
        else
          try_vlog { |io| io.puts react_s("R -", energy, port_id, port) }
          @stats[:react_null_count] += 1
        end
        try_vlog { |io| io.puts react_s("R =", energy, port_id, port) }
        try_callback(:on_react_abs, self, port, energy)
        @stats[:react_abs_count] += 1
      end

      ##
      # emit_port(Port port, Energy energy)
      def emit_port(port, energy)
        try_vlog { |io| io.puts emit_s("Ep=", energy, port.id, port) }
        port.client_react(energy)
      end

      ##
      # emit(PORT_ID port_id, Energy energy)
      def emit(port_id, energy=emit_energy)
        # default emission action
        port = @port[port_id]
        if port_type_valid?(port_id, :out)
          Konekraft::Konekt2::Base.indent do
            try_vlog { |io| io.puts emit_s("E +", energy, port_id, port) }
            emit_port(port, energy)
          end
          try_callback(:on_emit, self, port, energy)
          @stats[:emit_count] += 1
        else
          try_vlog { |io| io.puts emit_s("E -", energy, port_id, port) }
          @stats[:emit_null_count] += 1
        end
        try_vlog { |io| io.puts emit_s("E =", energy, port_id, port) }
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
        @vlog || self.class.vlog || Konekraft::Konekt2::Base.vlog
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

      ### Konekt Registration
      ##
      # ::registered_name -> String
      def self.registered_name
        @registered_name
      end

      ##
      # ::register(String name)
      def self.register(name)
        @registered_name = name
        Konekraft::Konekt2.register(self, @registered_name)
      end

      ### Konekt Settings
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

      class << self
        attr_writer :indent
        def indent
          if block_given?
            @indent += 1
            yield @indent
            @indent -= 1
          end
          @indent
        end
      #  private :new
      end

      @indent = 0

    end
  end
end
