#
# Sadie/lib/sadie/sasm/interpreter.rb
#   by IceDragon
#   dc 27/05/2013
#   dm 29/05/2013
module Sadie
  module SASM
    class Interpreter

      extend Forwardable
      include Sadie::SASM::Constants

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
      # initialize(Sadie::SASM::Sacpu cpu)
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
        @name = "Sadie - Null Interpreter"
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
      # load_program(Sadie::SASM::Program program)
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
      # exec_opcode(int opcode, Array<int> params)
      def exec_opcode(opcode, *params)
        __send__("inst_#{opcode}", *params)
      end

      ##
      # exec_inst(Sadie::SASM::Instruction inst)
      def exec_inst(inst)
        puts "executing: #{inst}"
        exec_opcode(inst.opcode, *inst.params)
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

      ##
      # ::instspec_table
      def self.instspec_table
        @instspec_table ||= {}
      end

      ##
      # ::def_inst(int code, Symbol symbol, Array<int> params_prepend)
      #   Sets (code) as a new bytecode table element
      def self.def_inst(code, symbol, *params, &func)
        # no function was provided, so we must create one based on given params
        if func
          hardsize = func.arity
        else
          hardcoded = []
          for param in params
            break if param.is_a?(Symbol)
            hardcoded.push(param)
          end
          func = ->(*args) do
            begin
              __send__(symbol, *hardcoded, *args)
            rescue Exception => ex
              STDERR.puts("Error: instruction #{code} | #{symbol} { hardcoded: #{hardcoded}, args: #{args} }")
              raise ex
            end
          end
          hardsize = params.size - hardcoded.size
        end
        lst = params.size - hardsize
        embed_params = params[0, lst]
        embed_param_types = embed_params.map { |o| Sadie::BitTool.identify_type(o) }
        param_types = embed_param_types + (params[lst, hardsize] || [])
        inst_spec = Sadie::SASM::InstructionSpec.new(code, symbol,
                                                     param_types, embed_params,
                                                     &func)
        define_method("inst_#{inst_spec.opcode}", &func)
        instspec_table[code] = inst_spec
        ###
        Sadie.try_log do |l|
          l.puts "#{self} [ Added instruction: #{code}|#{symbol} (#{param_types.join(", ")}): bytesize: #{inst_spec.bytesize}"
        end
      rescue Exception => ex
        Sadie.try_log do |l|
          l.puts "#{self} [ Failure on instruction #{code}|#{symbol}"
        end
        raise ex
      end

    end
  end
end

require 'sadie/sasm/interpreter/interpreter_8085'