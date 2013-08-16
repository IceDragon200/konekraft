#
# Sadie/lib/sadie/reaktor/network.rb
#   by IceDragon
#   dc 01/06/2013
#   dm 15/08/2013
# A collection of Reaktors, helps manage individual Reaktor ids, and
# makes moving them around a bit easier.
#   Reaktor Networks can be placed under other Networks if necessary.
#   Just be careful not to end up looping them
module Sadie
  module Reaktor
    class Network

      ### constants
      VERSION = "0.1.0".freeze

      ### instance_attributes
      attr_accessor :id
      attr_reader :ticks
      attr_reader :trigger

      attr_accessor :vlog

      ##
      # initialize
      def initialize
        @id = 0
        @reaktors = []
        @reaktor_mains = []
        @triggers = 0
        @ticks = 0
        @post_ticks = 0
      end

      ##
      # clear
      def clear
        @reaktors.clear
      end

      ##
      # terminate
      def terminate
        for rktr in @reaktors
          rktr.terminate
        end
      end

      ##
      # add(Reaktor<Class>* klass)
      def add(klass)
        add_from_class(klass, false)
      end

      ##
      # add_main(Reaktor<Class>* klass)
      def add_main(klass)
        add_from_class(klass, true)
      end

      ##
      # add_from_class(Reaktor<Class>* klass)
      def add_from_class(klass, is_a_main)
        rktr = klass.new
        add_instance(rktr, is_a_main)
      end

      ##
      # add_instance(Reaktor* rktr, bool is_a_main)
      def add_instance(rktr, is_a_main=false)
        rktr.id = @reaktors.size
        rktr.vlog = @vlog
        @reaktors.push(rktr)
        @reaktor_mains.push(rktr) if is_a_main
        yield rktr if block_given?
        return rktr
      end

      ##
      # trigger
      def trigger
        for rktr in @reaktor_mains
          rktr.trigger
        end
        @triggers += 1
      end

      ##
      # tick
      def tick
        for rktr in @reaktors
          rktr.tick
        end
        @ticks += 1
      end

      ##
      # post_tick
      def post_tick
        for rktr in @reaktors
          rktr.post_tick
        end
        @post_ticks += 1
      end

    end
  end
end