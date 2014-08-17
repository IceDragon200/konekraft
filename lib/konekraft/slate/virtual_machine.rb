#
# Konekraft/lib/konekraft/slate/sasm_vm.rb
#   by IceDragon
# CHANELOG
#   vr 0.1.0 (28/07/2013)
#     Started the Slate Virtual Machine
#
# Introduction
#   This is the Slate Virtual Machine, a virtual machine for the SlateAssembly language
require 'konekraft/slate/cpu'
require 'konekraft/slate/memory'
module Konekraft
  module Slate
    class VirtualMachine

      ### constants
      VERSION = "0.1.0".freeze

      ## memory
      @@default_memory_size = 0x200 #0x800 #65536 # bytes

      ## instance_attributes
      attr_reader :cpu
      attr_reader :memory

      def initialize(memory_size=@@default_memory_size)
        @memory_blocksize = 8 # 8-bit
        @memory_size = memory_size
        init_cpu
        init_memory
      end

      ##
      # init_cpu
      def init_cpu
        @cpu = Konekraft::Slate::CPU.new
      end

      ##
      # init_memory
      def init_memory
        @memory = Konekraft::Slate::Memory.new(@cpu, @memory_size, @memory_blocksize)
      end

      ##
      # reset
      def reset
        @cpu.reset
        @memory.reset
      end

      ##
      # exec_opcode(int bytecode, Array<int> parameters)
      def exec_opcode(bytecode, parameters)
        @cpu.exec_opcode(bytecode, parameters)
      end

      ##
      # exec_inst(Konekraft::SlateAssembly::Instruction inst)
      def exec_inst(inst)
        @cpu.exec_inst(inst)
      end

      ##
      # exec_eval(String str)
      def exec_eval(str)
        Konekraft::SlateAssembly::Assembler.assemble_string(str).each do |inst|
          puts inst # DEBUG
          @slate.exec(inst)
        end
      end

      def load_program(program)
        @cpu.load_program(program)
      end

      def run
        @cpu.run
      end

      ##
      # exec(*args)
      def exec(*args)
        arg = args.shift
        case arg
        when Integer                           then exec_opcode(arg, *args)
        when String                            then exec_eval(arg)
        when Konekraft::SlateAssembly::Program::Instruction then exec_inst(arg)
        else
          raise ArgumentError,
                "wrong argument type #{arg.class} (expected a Bytecode, String, or Instruction)"
        end
      end

      def status_s
        "cpu: #{@cpu.status_s}\n" <<
        "memory: #{@memory.status_s}"
      end

      def memmap_s
        blks = 2 ** @memory.block_size
        objs = %W[\s . _ = #]
        @memory.map { |n| objs[n * objs.size / blks] }.each_slice(@memory.block_size).to_a.map(&:join).join("\n")
      end

      def cpumap_s
        blks = 0x2
        objs = %W[\s . _ = #]
        "a=#{"%08b" % @cpu.reg_a.cell_data}\n" <<
        "b=#{"%08b" % @cpu.reg_b.cell_data} " <<
        "c=#{"%08b" % @cpu.reg_c.cell_data}\n" <<
        "d=#{"%08b" % @cpu.reg_d.cell_data} " <<
        "e=#{"%08b" % @cpu.reg_e.cell_data}\n" <<
        "f=#{"%08b" % @cpu.reg_f.cell_data}\n" <<
        "h=#{"%08b" % @cpu.reg_h.cell_data} " <<
        "l=#{"%08b" % @cpu.reg_l.cell_data}\n" <<
        "pc=#{"%016b" % @cpu.reg_pc.cell_data}\n" <<
        "sp=#{"%016b" % @cpu.reg_sp.cell_data}\n" <<
        "psw=#{"%016b" % @cpu.reg_psw.cell_data}\n"
      end

    end
  end
end
