#
# Sadie/lib/sadie/reaktor/port.rb
#   by IceDragon
#   dc 09/04/2013
#   dm 15/08/2013
module Sadie
  module Reaktor
    class Port

      ### constants
      VERSION = "1.1.0"

      ### instance_attributes
      attr_accessor :name
      attr_reader :client_port
      attr_reader :client
      attr_reader :client_port_id
      attr_reader :parent
      attr_reader :id
      attr_reader :type

      ##
      # initialize(Reaktor parent, PortSpec spec)
      def initialize(parent, spec)
        @parent         = parent
        @port_spec      = spec
        @client_port    = nil
        @client         = nil
        @client_port_id = nil
        @id   = @port_spec.id
        @name = @port_spec.name.dup
        @type = @port_spec.type
      end

      ##
      # connect_as_parent(Port port)
      def connect_as_parent(port)
        @client_port = port
      end

      ##
      # connect_as_child(Port port)
      def connect_as_child(port)
        port.connect_as_parent(self)
      end

      ##
      # connect_as_bidir(Port port)
      def connect_as_bidir(port)
        connect_as_parent(port)
        connect_as_child(port)
      end

      ##
      # react(Energy energy)
      def react(energy)
        @parent.react(@id, energy)
      end

      ##
      # client_send(Energy energy)
      def client_send(energy)
        @client_port.react(energy) if @client_port
      end

      ##
      # feedback? -> Boolean
      def feedback?
        return false unless valid?
        @parent == @client_port.parent
      end

      ##
      # valid? -> Boolean
      def valid?
        @parent && @client_port
      end

      ##
      # valid_type?(Symbol requested_type) -> Boolean
      def valid_type?(requested_type)
        case requested_type
        when :in  then @type == :bi || @type == :in
        when :out then @type == :bi || @type == :out
        when :bi  then @type == :bi
        else           false
        end
      end

      ##
      # input? -> Boolean
      def input?
        valid_type?(:in)
      end

      ##
      # output? -> Boolean
      def output?
        valid_type?(:out)
      end

      ##
      # to_s -> String
      def to_s
        "PORT(#{id}|#{name}|#{type})"
      end

      alias :< :connect_as_child
      alias :> :connect_as_parent
      alias :| :connect_as_bidir

    end
  end
end
