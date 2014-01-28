#
# Sadie/lib/sadie/sasm/program/instruction.rb
#   by IceDragon
require 'sadie/internal/bit_tool'
require 'sadie/sasm/instruction_spec'
module Sadie
  module SASM
    class Program
      class Instruction

        ### constants
        VERSION = "1.0.0".freeze

        ### instance_variables
        attr_reader :instruction_set
        attr_reader :opcode
        attr_reader :params

        ##
        # initialize(inst_set, int opcode, params)
        def initialize(inst_set, opcode, params=[])
          @instruction_set = inst_set
          @opcode          = opcode
          @params          = params
        end

        ##
        # instruction_spec
        def instruction_spec
          @instruction_set.instspec_table[@opcode]
        end

        ##
        # name
        def name
          instruction_spec.name
        end

        def bytecode_params
          result = []
          raw = params.dup
          for type in instruction_spec.param_types
            bytesize = Sadie::BitTool.type_bytesize(type)
            next unless bytesize > 0
            r = raw.shift
            ary = []
            bytesize.times do
              ary << (r & 0xFF)
              r >>= 8
            end
            #ary.reverse! # BigEndian
            result.concat(ary)
          end
          return result
        end

        def to_bytecode_a
          [opcode, *bytecode_params]
        end

        def to_bytecode
          to_bytecode_a.pack("C*")
        end

        def inspect
          #"<#{self.class.name}[#{self.object_id}]: #{"%03d" % opcode} | #{name}(#{params.join(", ")})>"
          "<#{"%03d" % opcode} | #{name}(#{params.join(", ")})>"
        end

      end
    end
  end
end
