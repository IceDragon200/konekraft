#
# Sadie/lib/sadie/sasm/assembler.rb
#   by IceDragon
#   dc 23/05/2013
#   dm 23/05/2013
module Sadie
  module SASM
    class Assembler

      ### constants
      VERSION = "0.2.0".freeze

      include Sadie::BitTool

      ### instance_variables
      attr_reader :instruction_set

      ##
      # initialize(Interpreter*(Class) instruction_set)
      def initialize(instruction_set)
        @instruction_set = instruction_set
      end

      ##
      # strip_commments(String string) -> String
      def strip_commments(string)
        string.gsub(/;(.*)/, '')
      end

      def sasm_tokenize(code_stack)
        result = []
        code_stack.each do |line|
          if data = line.match(/(?<instruction>\S+)\s+(?<params>.*)/)
            instname = data[:instruction]
            params   = data[:params].gsub("\s", "").split(",").compact
            result.push([instname, params])
          end
        end
        return result
      end

      def tokenize(string)
        code = string.dup
        code = strip_commments(code)
        sasm_tokenize(code.each_line.to_a)
      end

      def instname_to_instspec(instname, *params)
        symbol = instname.to_sym
        @instruction_set.instspec_table.find do |(k, instspec)|
          # l.puts "Looking at instruction: #{instspec.opcode} for #{instname}"
          if instspec.inst_sym != symbol
            false
          else
            # l.puts "Found an instruction_spec: #{instspec.to_s}"
            instspec.valid_params?(*params)
          end
        end
      end

      ##
      # ::assemble_instruction(String instname, *Array<String> params)
      def assemble_instruction(instname, *params)
        instname = instname.downcase
        _, instspec = instname_to_instspec(instname, *params)
        if !instspec
          puts "warning: instruction #{instname} supporting params(#{params.join(", ")}) not found. nop-ing instruction"
          return Sadie::SASM::Instruction.new(@instruction_set, 0)
        else
          code, param_data = instspec.compile(*params)
          return Sadie::SASM::Instruction.new(@instruction_set, code, param_data)
        end
      rescue Exception => ex
        puts "compilation error: #{instname} #{params.join(", ")}"
        raise ex
      end

      ##
      # ::assemble(String string)
      def assemble(string)
        src_a = tokenize(string)
        result = []
        puts "Assembling a #{src_a.size} size source tree"
        src_a.each_with_index do |(instname, params), i|
          inst = assemble_instruction(instname, *params)
          result.push(inst)
          puts "asm [#{result.size}/#{src_a.size}] #{instname} #{params.join(", ")}"
          puts "    #{inst.to_s}"
        end
        return result
      end

      ##
      # ::build(String string)
      def build(string)
        Sadie::SASM::Program.new(assemble(string))
      end

    end
  end
end

require 'sadie/sasm/assembler/assembler_8085.rb'