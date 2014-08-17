#
# Konekraft/lib/konekraft/konekt/network.rb
#
# A collection of Konekts, helps manage individual Konekt ids, and
# makes moving them around a bit easier.
#   Konekt Networks can be placed under other Networks if necessary.
#   Just be careful not to end up looping them
require 'konekraft/root_path'
module Konekraft
  module Konekt2
    class Network

      ### constants
      VERSION = "0.1.0".freeze

      ### instance_attributes
      attr_accessor :id
      attr_accessor :name
      attr_reader :konekts
      attr_reader :konekt_mains
      attr_reader :ticks
      attr_reader :post_ticks
      attr_reader :triggers

      attr_accessor :vlog

      ##
      # initialize
      def initialize
        @id = 0
        @name = File.readlines(File.join(Konekraft::ROOT_PATH, "konekt", "data", "words.txt")).sample.chomp <<
                "-" <<
                File.readlines(File.join(Konekraft::ROOT_PATH, "konekt", "data", "names.txt")).sample.chomp
        @konekts = []
        @konekt_mains = []
        @triggers = 0
        @ticks = 0
        @post_ticks = 0
      end

      def find(options)
        if rid = options[:id]
          @konekts.find { |r| r.id == rid }
        elsif nm = options[:name]
          @konekts.find { |r| r.name == nm }
        else
          raise ArgumentError, "expected :id or :name key"
        end
      end

      ##
      # reset
      def reset
        @konekts.each(&:reset)
      end

      ##
      # clear
      def clear
        @konekts.clear
      end

      ##
      # terminate
      def terminate
        for rktr in @konekts
          rktr.terminate
        end
      end

      ##
      # add(Konekt<Class>* klass)
      def add(klass)
        add_from_class(klass, false)
      end

      ##
      # add_main(Konekt<Class>* klass)
      def add_main(klass)
        add_from_class(klass, true)
      end

      ##
      # add_from_class(Konekt<Class>* klass)
      def add_from_class(klass, is_a_main)
        rktr = klass.new
        add_instance(rktr, is_a_main)
      end

      ##
      # add_instance(Konekt* rktr, bool is_a_main)
      def add_instance(rktr, is_a_main=false)
        rktr.id = @konekts.size
        rktr.vlog = @vlog
        @konekts.push(rktr)
        @konekt_mains.push(rktr) if is_a_main
        yield rktr if block_given?
        return rktr
      end

      ##
      # trigger
      def trigger
        for rktr in @konekt_mains
          rktr.trigger
        end
        @triggers += 1
      end

      ##
      # tick
      def tick
        for rktr in @konekts
          rktr.tick
        end
        @ticks += 1
      end

      ##
      # post_tick
      def post_tick
        for rktr in @konekts
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
          "konekts" => @konekts.map(&:to_rktm_h),
          "konekt_mains" => @konekt_mains.map(&:id),
          "ticks" => @ticks,
          "post_ticks" => @post_ticks,
          "triggers" => @triggers
        }
      end

      def import_rktm_h(hsh)
        @id            = hsh["id"]
        @name          = hsh["name"]
        @konekts      = hsh["konekts"].map { |h| Konekraft::Konekt.load_rktm_h(h) }
        @konekt_mains = hsh["konekt_mains"].map { |id| id=id.to_i;@konekts.find { |r| r.id == id } }
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
