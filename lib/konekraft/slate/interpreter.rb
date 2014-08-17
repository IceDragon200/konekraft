#
# Konekraft/lib/konekraft/slate/interpreter.rb
#   by IceDragon
require 'konekraft/sasm'
module Konekraft
  module Slate
    class Interpreter

      extend Forwardable
      include Konekraft::SlateAssembly::Constants

      ### constants
      VERSION = "0.3.0".freeze

      ### instance_variables
      attr_reader :cpu
      attr_reader :prog_index
      attr_reader :program

      def_delegators :@cpu, :port, :memory,
                            :reg, :reg_pair,
                            :reg_a,
                            :reg_b, :reg_c,
                            :reg_d, :reg_e,
                            :reg_h, :reg_l,
                            :reg_f,
                            :reg_sp,
                            :reg_pc,
                            :flag_ac, :flag_ac=,
                            :flag_c, :flag_c=,
                            :flag_s, :flag_s=,
                            :flag_p, :flag_p=,
                            :flag_z, :flag_z=,
                            :instruction_set

      ##
      # initialize(Konekraft::SlateAssembly::Sacpu cpu)
      def initialize(cpu)
        @cpu = cpu
        init_stack
        init_prog_index
        init_program
        init_name
        puts "#{@name} initialized!"
      end

      ##
      # init_program
      def init_program
        @program = nil
      end

      ##
      # init_prog_index
      def init_prog_index
        @prog_index = []
      end

      ##
      # init_stack
      def init_stack
        @stack_index = 0
      end

      ##
      # init_name
      def init_name
        @name = "Konekraft - Null Interpreter"
      end

      ##
      # exec(int bytecode, *Array<int> params)
      def exec(bytecode, *params)
        inst_spec = instspec_table[bytecode]
        instance_exec(*params, &inst_spec.func)
      end

      ##
      # prog_index(int index)
      def prog_index=(index)
        @prog_index[@stack_index] = index
      end

      ##
      # load_program(Konekraft::SlateAssembly::Program program)
      def load_program(program)
        @program = program
        init_prog_index
        init_stack
        self.prog_index = 0
        puts "Loaded program of size #{program.size}"
      end

      def halt_program
        @halt = true
      end

      def unhalt_program
        @halt = false
      end

      ##
      # next_instruction
      def next_instruction
        index = @prog_index[@stack_index]
        inst = @program[index]
        @prog_index[@stack_index] += 1
        return inst
      end

      ##
      # clock_cycle { |clock| do_something }
      #   cause the cpu to run a clock loop based on the CPU clock.
      #   you can attempt to complete a list of instructions within this block
      def clock_cycle(&block)
        @cpu.clock.cycle(&block)
      end

      ##
      # stack_return
      def stack_return
        @stack_index -= 1
        return @stack_index >= 0
      end

      ##
      # program? -> bool
      def program?
        !!@program
      end

      ##
      # idle? -> bool
      def idle?
        !program? && @stack_index < 0
      end

      ##
      # tick
      #   Execute all possible instructions from the list in a single clock
      #   cycle
      #   Multiple #tick calls may be needed to complete the program
      def tick
        return false if !program?
        return false if @halt
        clock_cycle do |clock|
          break if @halt
          print "cycle: "
          if (inst = next_instruction)
            exec_inst(inst)
          else
            break
          end
        end
        return true
      end

    end
  end
end
