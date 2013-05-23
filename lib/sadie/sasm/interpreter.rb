#
# Sadie/lib/sadie/sasm/interpreter.rb
#   by IceDragon
#   dc 20/05/2013
#   dm 20/05/2013
#
# TODO
#   finish SASM VM to read SASM compiled code
#
# SASM - Interpreter
module Sadie
  module SASM
    class Interpreter

      VERSION = "0.1.0".freeze

      attr_reader :cpu
      attr_reader :prog_index
      attr_reader :program

      def initialize(cpu)
        @cpu = cpu
        init_stack
        init_prog_index
        init_program
      end

      def init_program
        @program = nil
      end

      def init_prog_index
        @prog_index = []
      end

      def init_stack
        @stack_index = -1
        @stack_label = []
      end

      def set_current_stack(label)
        @stack_label[@stack_index] = label
      end

      def set_current_prog_index(index)
        @prog_index[@stack_index] = index
      end

      ##
      # setup(Sadie::SASM::Program program)
      def setup(program)
        program.assert_entry_label
        init_prog_index
        init_stack
        @stack_index = 0
        @program = program
        set_current_stack(@program.entry_label)
        set_current_prog_index(0)
      end

      def next_instruction
        label = @stack_label[@stack_index]
        index = @prog_index[@stack_index]
        inst = @program[label][index]
        @prog_index[@stack_index] += 1
        return inst
      end

      def stack_return
        @stack_index -= 1
        return @stack_index >= 0
      end

      def program?
        !@program
      end

      def idle?
        !program? && @stack_index < 0
      end

      def tick
        return false if program?
        @cpu.clock.cycle do |clock|
          if inst = next_instruction
            @cpu.exec_inst(inst)
          else
            break unless stack_return
          end
        end
        return true
      end

    end
  end
end
