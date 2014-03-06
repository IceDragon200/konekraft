#
# Sadie/lib/sadie/reaktor/network.rb
#   by IceDragon
#   dc 01/06/2013
#   dm 15/08/2013
# A collection of Reaktors, helps manage individual Reaktor ids, and
# makes moving them around a bit easier.
#   Reaktor Networks can be placed under other Networks if necessary.
#   Just be careful not to end up looping them
require 'sadie/root_path'
module Sadie
  module Reaktor2
    class Network

      ### constants
      VERSION = "0.1.0".freeze

      ### instance_attributes
      attr_accessor :id
      attr_accessor :name
      attr_reader :reaktors
      attr_reader :reaktor_mains
      attr_reader :ticks
      attr_reader :post_ticks
      attr_reader :triggers

      attr_accessor :vlog

      ##
      # initialize
      def initialize
        @id = 0
        @name = File.readlines(File.join(Sadie::ROOT_PATH, "reaktor", "data", "words.txt")).sample.chomp <<
                "-" <<
                File.readlines(File.join(Sadie::ROOT_PATH, "reaktor", "data", "names.txt")).sample.chomp
        @reaktors = []
        @reaktor_mains = []
        @triggers = 0
        @ticks = 0
        @post_ticks = 0
      end

      def find(options)
        if rid = options[:id]
          @reaktors.find { |r| r.id == rid }
        elsif nm = options[:name]
          @reaktors.find { |r| r.name == nm }
        else
          raise ArgumentError, "expected :id or :name key"
        end
      end

      ##
      # reset
      def reset
        @reaktors.each(&:reset)
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

      ##
      # step
      def step
        tick
        trigger
        post_tick
      end

      def to_rktm_h
        {
          "id" => @id,
          "name" => @name,
          "reaktors" => @reaktors.map(&:to_rktm_h),
          "reaktor_mains" => @reaktor_mains.map(&:id),
          "ticks" => @ticks,
          "post_ticks" => @post_ticks,
          "triggers" => @triggers
        }
      end

      def import_rktm_h(hsh)
        @id            = hsh["id"]
        @name          = hsh["name"]
        @reaktors      = hsh["reaktors"].map { |h| Sadie::Reaktor.load_rktm_h(h) }
        @reaktor_mains = hsh["reaktor_mains"].map { |id| id=id.to_i;@reaktors.find { |r| r.id == id } }
        @ticks         = hsh["ticks"]
        @post_ticks    = hsh["post_ticks"]
        @triggers      = hsh["triggers"]
      end

      def id_s
        "#{@id}:#{@name}"
      end

    end
  end
end