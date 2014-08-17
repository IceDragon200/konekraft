#
# Konekraft/lib/konekraft/slate/cpu.rb
#   by IceDragon
require 'konekraft/sasm'
require 'konekraft/slate/memory'
require 'konekraft/slate/cpu/clock'
require 'konekraft/slate/cpu/register'
require 'konekraft/slate/cpu/register_pair'
require 'konekraft/slate/cpu/ports'
# Konekraft's CPU is a 16 bit CPU based on the Intel
# 8085 CPU, it interprets assembled SlateAssembly code
# Using 16 bit opcodes
#   INSTRUCTION-PARAM1-PARAM2-PARAM3
#   0000-0000-0000-0000
module Konekraft
  module Slate
    class CPU

      include Konekraft::SlateAssembly::Constants

      ### constants
      VERSION = "0.1.0".freeze

      ### instance_variables
      attr_reader :clock
      attr_reader :register
      attr_accessor :memory
      attr_accessor :halted

      ##
      # initialize([int memory_size, SlateAssembly::InstructionSet instset])
      #   (memory_size) is in number of bytes
      def initialize
        @program_start_pointer = 0
        init_name
        init_clock
        init_register
        init_ports
      end

      ##
      # init_name
      def init_name
        @name = "Konekraft8085"
      end

      ##
      # init_clock
      def init_clock
        @clock = Konekraft::Slate::CPU::Clock.new(self)
      end

      ##
      # init_register
      def init_register
        @register = {}
        REGISTERS.each do |code|
          size = REGISTER_SIZE[code]
          @register[code] = Konekraft::Slate::CPU::Register.new(self, size)
        end.freeze
        REGISTER_PAIR.each_pair do |code, (h_id, l_id)|
          h, l = @register[h_id], @register[l_id]
          @register[code] = Konekraft::Slate::CPU::RegisterPair.new(self, h, l)
        end
        reg_sp.cell_data_set(0xFFFF)
      end

      ##
      # init_ports
      def init_ports
        @ports = Konekraft::Slate::CPU::Ports.new(self, 256, 256)
      end

      ##
      # reset
      def reset
        @halted = false
        @clock.reset
        @register.values.each(&:reset)
        @ports.reset
        reg_sp.cell_data_set(0xFFFF)
      end

      ##
      # freq_s
      #   translates to number of instructions per tick
      def freq_s
        "CPU Clock Frequency: #{@clock.frequency} hz"
      end

      ##
      # status_s
      def status_s
        "a=#{reg_a.cell_data} b=#{reg_b.cell_data} c=#{reg_c.cell_data} " <<
        "d=#{reg_d.cell_data} e=#{reg_e.cell_data} f=#{reg_f.cell_data} " <<
        "h=#{reg_h.cell_data} l=#{reg_l.cell_data} pc=#{reg_pc.cell_data} " <<
        "sp=#{reg_sp.cell_data} psw=#{reg_psw.cell_data} " <<
        "halted=#{halted}"
      end

      ##
      # reg_abs(REG_ID id) -> Register
      def reg_abs(id)
        @register[id]
      end

      ##
      # reg(REG_ID id) -> Register
      def reg(id)
        id == REG_MEMORY ? @memory : reg_abs(id)
      end

      ##
      # reg_pair(REG_ID id) -> RegisterPair
      def reg_pair(id)
        id == REG_MEMORY ? @memory : reg_abs(CODE2REGPAIRCODE[id])
      end

      ##
      # reg_accumulator
      def reg_accumulator
        reg(REG_ACCUMULATOR)
      end

      ## REG_B
      # reg_b
      def reg_b
        reg(REG_B)
      end

      ## REG_C
      # reg_c
      def reg_c
        reg(REG_C)
      end

      ## REG_BC
      # reg_bc
      def reg_bc
        reg_pair(REG_BC)
      end

      ## REG_D
      # reg_d
      def reg_d
        reg(REG_D)
      end

      ## REG_E
      # reg_e
      def reg_e
        reg(REG_E)
      end

      ## REG_DE
      # reg_de
      def reg_de
        reg_pair(REG_DE)
      end

      ## REG_H
      # reg_h
      def reg_h
        reg(REG_H)
      end

      ## REG_L
      # reg_l
      def reg_l
        reg(REG_L)
      end

      ## REG_HL
      # reg_hl
      def reg_hl
        reg_pair(REG_HL)
      end

      ## REG_SP
      # stack_pointer
      def stack_pointer
        reg(REG_SP)
      end

      ## REG_PC
      # reg_pc
      def reg_pc
        reg(REG_PC)
      end

      # reg_psw
      def reg_psw
        reg(REG_PSW)
      end

      ### flags
      ##
      # reg_flag
      def reg_flag
        reg(REG_FLAG)
      end

      ## reg_flag.ac
      # flag_ac
      #   Auxillary Carry
      def flag_ac
        reg_flag[FLAG_AUX_CARRY]
      end

      ##
      # flag_ac=(bit n)
      def flag_ac=(n)
        reg_flag[FLAG_AUX_CARRY] = n
      end

      ## reg_flag.carry
      # flag_c
      def flag_c
        reg_flag[FLAG_C]
      end

      ##
      # flag_c=(bit n)
      def flag_c=(n)
        reg_flag[FLAG_C] = n
      end

      ##
      # flag_z
      def flag_z
        reg_flag[FLAG_ZERO]
      end

      ##
      # flag_z=(bit n)
      def flag_z=(n)
        reg_flag[FLAG_ZERO] = n
      end

      ##
      # flag_p
      def flag_p
        reg_flag[FLAG_PARITY]
      end

      ##
      # flag_p(bit n)
      def flag_p=(n)
        reg_flag[FLAG_PARITY] = n
      end

      ##
      # flag_s
      def flag_s
        reg_flag[FLAG_SIGN]
      end

      ##
      # flag_s=(bit n)
      def flag_s=(n)
        reg_flag[FLAG_SIGN] = n
      end

      ##
      # memory_pointer_reg -> Register
      def memory_pointer_reg
        reg_hl
      end

      ##
      # memory_pointer_value -> Integer
      def memory_pointer_value
        memory_pointer_reg.cell_data
      end

      def clear_flags
        reg_flag.cell_data_set(0)
      end

      ##
      # to_s
      def to_s
        [[:A, reg_a],
         [:B, reg_b], [:C, reg_c], [:D, reg_d], [:E, reg_e],
         [:H, reg_h], [:L, reg_l], [:PC, reg_pc], [:SP, reg_sp]
         ].map { |a| "%s  %s" % [a[0], a[1].to_s] }.join("\n")
      end

      ##
      #
      def halt_program
        @halted = true
      end

      ##
      # exec_opcode(int opcode, Array<int> params)
      def exec_opcode(opcode, params)
        #puts "executing instruction #{self.class.instspec_table[opcode]} with (#{params.join(", ")})"
        __send__("inst_#{opcode}", *params)
      end

      def exec_inst(inst)
        exec_opcode(inst.opcode, inst.params)
      end

      ##
      #
      def load_program(program)
        codes = program.to_bytecode_a.flatten
        reg_pc.cell_data_set(@program_start_pointer)
        mem = memory
        codes.each do |c|
          memory.program_cell_data_set(c)
          reg_pc.cell_inc!
        end
        reg_pc.cell_data_set(@program_start_pointer)
        #p "loaded program of size #{codes.size} bytes"
      end

      def next_instruction
        opcode = memory.program_cell_data
        params = []
        if instspec = self.class.instspec_table[opcode]
          (instspec.bytesize - 1).times do
            reg_pc.cell_inc!
            params << memory.program_cell_data
          end
          params = instspec.bytecode_params_fix(params)
          exec_opcode(opcode, params)
        end
        reg_pc.cell_inc!
      end

      def run
        loop do
          break if @halted
          next_instruction
        end
      end

      def idle?
        @halted
      end

      ##
      # ::instspec_table
      def self.instspec_table
        @instspec_table ||= {}
      end

      ##
      # Used to generate the Parser AST::Instructions
      def self.struct_spec
        @struct_spec ||= {}
      end

      ##
      # ::def_inst(int code, Symbol symbol, Array<int> params_prepend)
      #   Sets (code) as a new bytecode table element
      def self.def_inst(code, symbol, *params, &rel_func)
        struct_spec[code] = [symbol, params] # TMP
        # no function was provided, so we must create one based on given params
        if rel_func
          hardsize = rel_func.arity
        else
          hardcoded = []
          for param in params
            case param.to_s
            when /REG_\S+/i
              hardcoded.push(param)
            else
              break
            end
          end
          rel_func = lambda do |*args|
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
        embed_param_types = embed_params.map { |o| Konekraft::BitTool.identify_type(o) }
        param_types = embed_param_types + (params[lst, hardsize] || [])
        inst_spec = Konekraft::SlateAssembly::InstructionSpec.new(code, symbol,
                                                     param_types, embed_params)
        # debug hook
        #func = lambda do |*args|
        #  puts "|#{reg_pc.cell_data - inst_spec.bytesize + 1}| #{code} #{symbol}(#{args.join(", ")})"
        #  instance_exec(*args, &rel_func)
        #end
        func = rel_func
        define_method("inst_#{inst_spec.opcode}", &func)
        instspec_table[code] = inst_spec
        ###
        Konekraft.try_log do |l|
          l.puts "#{self} [ Added instruction: #{code}|#{symbol} (#{param_types.join(", ")}): bytesize: #{inst_spec.bytesize}"
        end
      rescue Exception => ex
        Konekraft.try_log do |l|
          l.puts "#{self} [ Failure on instruction #{code}|#{symbol}"
        end
        raise ex
      end

      ##
      #
      def compare(a, b)
        if a < b
          self.flag_c = 1
          self.flag_z = 0
        elsif a == b
          self.flag_c = 0
          self.flag_z = 1
        elsif a > b
          self.flag_c = 0
          self.flag_z = 0
        end
      end

      ## gracefully swiped from GNUSim8085
      # is_carry?
      #   check for carry in this operation
      def is_carry?(a, b, op)
        if (op == :+)
          return !((a + b) < 256);
        else
          return a < b;
        end
      end

      ## gracefully swiped from GNUSim8085
      # is_auxillary_carry?
      def is_auxillary_carry?(a, b, op)
        a <<= 4;
        a >>= 4;
        b <<= 4;
        b >>= 4;

        if (op == :+)
          return !((a + b) < 16)
        else
          return !((a - b) <= a)
        end
      end

      def find_and_set_flags(result)
        self.flag_z = result == 0 ? 1 : 0
        self.flag_s = result >= 128 ? 1 : 0
        self.flag_p = (Konekraft::BitTool.count_one_bits(result) % 2) != 0 ? 1 : 0
      end

      def flag_check_and_set_aux_c(a, b, op)
        flag_ac_set(is_auxillary_carry?(a, b, op) ? 1 : 0)
      end

      def flag_check_and_set_carry(a, b, op)
        self.flag_c = (is_carry?(a, b, op) ? 1 : 0)
      end

      ##
      # add_i
      #   Add immediate with flags and op
      def add_i(data, op)
        # check for flags
        flag_check_and_set_carry(reg_a.cell_data, data, op)
        flag_check_and_set_aux_c(reg_a.cell_data, data, op)

        # add
        reg_a.cell_add!((op == :+) ? data : -data)
        find_and_set_flags(reg_a.cell_data);
      end

      ## add register with carry
      # adc(REGISTER_ID reg_id)
      def adc(reg_id)
        reg_a.cell_add!(reg(reg_id)) #.cell_add!(flag_c)
      end

      ## add register without carry
      # add(REGISTER_ID reg_id)
      def add(reg_id)
        reg_a.cell_add!(reg(reg_id))
      end

      ## logical 'and' with register
      # ana(REGISTER_ID reg_id)
      def ana(reg_id)
        reg_a.cell_land!(reg_id)
      end

      ## compare accumulator with register
      # cmp(REGISTER_ID reg_id)
      def cmp(reg_id)
        compare(reg_a.cell_data, reg(reg_id).cell_data)
      end

      ## add register pair to HL
      # dad(REGISTER_PAIR_ID reg_pair_id)
      def dad(reg_pair_id)
        reg_hl.cell_add!(reg_pair(reg_pair_id))
      end

      ## decrement register
      # dcr(REGISTER_ID reg_id)
      def dcr(reg_id)
        reg(reg_id).cell_dec!
      end

      ## decrement register pair
      # dcx(REGISTER_PAIR_ID reg_pair_id)
      def dcx(reg_pair_id)
        reg_pair(reg_pair_id).cell_dec!
      end

      ## increment register
      # inr(REGISTER_ID reg_id)
      def inr(reg_id)
        reg(reg_id).cell_inc!
      end

      ## increment register pair
      # inx(REGISTER_PAIR_ID reg_pair_id)
      def inx(reg_pair_id)
        reg_pair(reg_pair_id).cell_inc!
      end

      ## load value from memory address at reg_pair
      # ldax
      def ldax(reg_pair_id)
        reg_a.cell_set!(memory[reg_pair(reg_pair_id)])
      end

      ## set immediate register pair
      # lxi
      def lxi(reg_pair_id, int16)
        reg_pair(reg_pair_id).cell_set!(int16)
      end

      ## copies src_register into target_register
      # mov(REGISTER_ID trg_reg_id, REGISTER_ID src_reg_id)
      def mov(trg_reg_id, src_reg_id)
        reg(trg_reg_id).cell_set!(reg(src_reg_id).cell_data)
      end

      ## copies immediate into target_register
      # mvi(REGISTER_ID trg_reg_id, int int)
      def mvi(trg_reg_id, int)
        reg(trg_reg_id).cell_set!(int)
      end

      ## no operation
      # nop
      def nop

      end

      ## halt instrustion
      # hlt
      def hlt
        halt_program
      end

      ## logical or with register
      # ora(REGISTER_ID reg_id)
      def ora(reg_id)
        reg_a.cell_lor!(reg_id)
      end

      def sub(reg_id)
        reg_a.cell_sub!(reg(reg_id).cell_data)
      end

      def sbb(reg_id)
        reg_a.cell_sub!(reg(reg_id).cell_data)
      end

      ##
      # pop(REGISTER_ID reg_pair_id)
      def pop(reg_pair_id)
        regpair = reg_pair(reg_pair_id)
        regpair.low_data_set(memory.stack_data)
        reg_sp.cell_inc!
        regpair.high_data_set(memory.stack_data)
      end

      ##
      # push(REGISTER_ID reg_pair_id)
      def push(reg_pair_id)
        regpair = reg_pair(reg_pair_id)
        memory.stack_data_set(regpair.high_data)
        reg_sp.cell_dec!
        memory.stack_data_set(regpair.low_data)
      end

      ## return
      # ret
      def ret
        adr16 = reg_sp.cell_data
        data = memory.cell_data
        reg_pc.low_data_set(data)
        reg_sp.cell_inc!
        data = memory.cell_data
        reg_pc.high_data_set(data)
      end

      ## jump instruction
      # jmp
      def jmp(address16)
        reg_pc.cell_data_set(address16)
      end

      def store_address
        reg = reg_pair(REG_HL)
        address = reg_pc.cell_data
        old_data = reg.cell_data
        reg.cell_data_set(address + 1)
        push(REG_HL)
        reg.cell_data_set(old_data)
      end

      ## call instruction
      # call
      def call(address16)
        # store address
        store_address
        # jump
        jmp(address16)
      end

      ## subtract register from accumulator
      # sub(REGISTER_ID reg_id)
      def sub(reg_id)
        reg_a.cell_sub!(reg(reg_id))
      end

      ##
      # stax
      def stax(reg_pair_id)
        memory[reg_pair(reg_pair_id).cell_data] = reg_a.cell_data
      end

      ## exclusive or (xor) of accumulator with register
      # xra(REGISTER_ID reg_id)
      def xra(reg_id)
        reg_a.cell_xor!(reg(reg_id).cell_data)
      end

    ##
    # def_inst code, :sym,  *prepend_args

      ## no operation
      # nop
      def_inst 0x00, :nop

      ##
      # lxi B, int16
      def_inst 0x01, :lxi, REG_BC, :int16

      ##
      # stax B
      def_inst 0x02, :stax, REG_BC

      ##
      # inx
      def_inst 0x03, :inx, REG_BC
      def_inst 0x04, :inr, REG_B
      def_inst 0x05, :dcr, REG_B
      def_inst 0x06, :mvi, REG_B, :int8

      ##
      # rlc
      def_inst 0x07, :rlc do
        reg_a.cell_rotate!(-1)
      end

      def_inst 0x08, :null
      def_inst 0x09, :dad, REG_BC
      def_inst 0x0A, :ldax, REG_BC
      def_inst 0x0B, :dcx, REG_BC
      def_inst 0x0C, :inr, REG_C
      def_inst 0x0D, :dcr, REG_C
      def_inst 0x0E, :mvi, REG_C, :int8
      ##
      # rrc
      def_inst 0x0F, :rrc do
        reg_a.cell_rotate!(-1)
      end

      def_inst 0x10, :null
      def_inst 0x11, :lxi, REG_DE, :int16
      def_inst 0x12, :stax, REG_DE
      def_inst 0x13, :inx, REG_DE
      def_inst 0x14, :inr, REG_D
      def_inst 0x15, :dcr, REG_D
      def_inst 0x16, :mvi, REG_D, :int8

      ## rotate accumulator by 1 bit to the left
      # ral
      def_inst 0x17, :ral do
        reg_a.cell_rotate!(-1)
      end

      def_inst 0x18, :null
      def_inst 0x19, :dad, REG_DE
      def_inst 0x1A, :ldax, REG_DE
      def_inst 0x1B, :dcx, REG_DE
      def_inst 0x1C, :inr, REG_E
      def_inst 0x1D, :dcr, REG_E
      def_inst 0x1E, :mvi, REG_E, :int8

      ## rotate accumulator by 1 bit to the right
      # rar
      def_inst 0x1F, :rar do
        reg_a.cell_rotate!(+1)
      end

      ##
      # rim
      #   Read Interrupt Status
      def_inst 0x20, :rim do
        # TODO
      end

      ##
      # lxi
      def_inst 0x21, :lxi, REG_HL, :int16

      def_inst 0x22, :shld, :address16 do |address16|
        memory[address16]     = reg_l.cell_data
        memory[address16 + 1] = reg_h.cell_data
      end

      def_inst 0x23, :inx, REG_HL
      def_inst 0x24, :inr, REG_H
      def_inst 0x25, :dcr, REG_H
      def_inst 0x26, :mvi, REG_H, :int8

      def_inst 0x27, :daa do
        old_carry = flag_c
        low_data = reg_a.cell_data & 0x0F

        if low_data > 9 || flag_ac == 1
          add_i(6, :+)
          self.flag_c = ((flag_c == 1 || old_carry == 1) ? 1 : 0)
          flag_ac_set(1)
        end

        if reg_a.cell_data > 0x99 || flag_c == 1
          reg_a.cell_data_set(reg_a.cell_data + 0x60)
          self.flag_c = (1)
        end
      end

      def_inst 0x28, :null
      def_inst 0x29, :dad, REG_HL

      def_inst 0x2A, :lhld, :address16 do |address16|
        reg_l.set!(memory[address16])
        reg_h.set!(memory[address16 + 1])
      end

      def_inst 0x2B, :dcx, REG_HL
      def_inst 0x2C, :inr, REG_L
      def_inst 0x2D, :dcr, REG_L
      def_inst 0x2E, :mvi, REG_L, :int8

      ## complement accumulator
      # cma
      def_inst 0x2F, :cma do
        reg_a.cell_complement!
      end

      ##
      # sim
      def_inst 0x30, :sim do
        # TODO
      end

      def_inst 0x31, :lxi, REG_SP, :int16

      ##
      # sta
      #   store contents of accumulator in memory at (address16)
      def_inst 0x32, :sta, :address16 do |address16|
        memory[address16] = reg_a.cell_data
      end

      def_inst 0x33, :inx, REG_SP
      def_inst 0x34, :inr, REG_M
      def_inst 0x35, :dcr, REG_M
      def_inst 0x36, :mvi, REG_M, :int8

      ##
      # stc
      #   carry flag is set to 1
      def_inst 0x37, :stc do
        @cpu.carry = 1
      end

      def_inst 0x38, :null

      def_inst 0x39, :dad, REG_SP

      def_inst 0x3A, :lda, :address16 do |address16|
        reg_a.set!(memory[address16])
      end

      def_inst 0x3B, :dcx, REG_SP
      def_inst 0x3C, :inr, REG_A
      def_inst 0x3D, :dcr, REG_A
      def_inst 0x3E, :mvi, REG_A, :int8

      ## complement carry flag
      # cmc
      def_inst 0x3F, :cmc do
        @cpu.carry = @cpu.carry == 1 ? 0 : 1
      end

      def_inst 0x40, :mov, REG_B, REG_B
      def_inst 0x41, :mov, REG_B, REG_C
      def_inst 0x42, :mov, REG_B, REG_D
      def_inst 0x43, :mov, REG_B, REG_B
      def_inst 0x44, :mov, REG_B, REG_H
      def_inst 0x45, :mov, REG_B, REG_L
      def_inst 0x46, :mov, REG_B, REG_M
      def_inst 0x47, :mov, REG_B, REG_A
      def_inst 0x48, :mov, REG_C, REG_B
      def_inst 0x49, :mov, REG_C, REG_C
      def_inst 0x4A, :mov, REG_C, REG_D
      def_inst 0x4B, :mov, REG_C, REG_E
      def_inst 0x4C, :mov, REG_C, REG_H
      def_inst 0x4D, :mov, REG_C, REG_L
      def_inst 0x4E, :mov, REG_C, REG_M
      def_inst 0x4F, :mov, REG_C, REG_A
      def_inst 0x50, :mov, REG_D, REG_B
      def_inst 0x51, :mov, REG_D, REG_C
      def_inst 0x52, :mov, REG_D, REG_D
      def_inst 0x53, :mov, REG_D, REG_E
      def_inst 0x54, :mov, REG_D, REG_H
      def_inst 0x55, :mov, REG_D, REG_L
      def_inst 0x56, :mov, REG_D, REG_M
      def_inst 0x57, :mov, REG_D, REG_A
      def_inst 0x58, :mov, REG_E, REG_B
      def_inst 0x59, :mov, REG_E, REG_C
      def_inst 0x5A, :mov, REG_E, REG_D
      def_inst 0x5B, :mov, REG_E, REG_E
      def_inst 0x5C, :mov, REG_E, REG_H
      def_inst 0x5D, :mov, REG_E, REG_L
      def_inst 0x5E, :mov, REG_E, REG_M
      def_inst 0x5F, :mov, REG_E, REG_A
      def_inst 0x60, :mov, REG_H, REG_B
      def_inst 0x61, :mov, REG_H, REG_C
      def_inst 0x62, :mov, REG_H, REG_D
      def_inst 0x63, :mov, REG_H, REG_E
      def_inst 0x64, :mov, REG_H, REG_H
      def_inst 0x65, :mov, REG_H, REG_L
      def_inst 0x66, :mov, REG_H, REG_M
      def_inst 0x67, :mov, REG_H, REG_A
      def_inst 0x68, :mov, REG_L, REG_B
      def_inst 0x69, :mov, REG_L, REG_C
      def_inst 0x6A, :mov, REG_L, REG_D
      def_inst 0x6B, :mov, REG_L, REG_E
      def_inst 0x6C, :mov, REG_L, REG_H
      def_inst 0x6D, :mov, REG_L, REG_L
      def_inst 0x6E, :mov, REG_L, REG_M
      def_inst 0x6F, :mov, REG_L, REG_A
      def_inst 0x70, :mov, REG_M, REG_B
      def_inst 0x71, :mov, REG_M, REG_C
      def_inst 0x72, :mov, REG_M, REG_D
      def_inst 0x73, :mov, REG_M, REG_E
      def_inst 0x74, :mov, REG_M, REG_H
      def_inst 0x75, :mov, REG_M, REG_L

      def_inst 0x76, :hlt

      def_inst 0x77, :mov, REG_M, REG_A
      def_inst 0x78, :mov, REG_A, REG_B
      def_inst 0x79, :mov, REG_A, REG_C
      def_inst 0x7A, :mov, REG_A, REG_D
      def_inst 0x7B, :mov, REG_A, REG_E
      def_inst 0x7C, :mov, REG_A, REG_H
      def_inst 0x7D, :mov, REG_A, REG_L
      def_inst 0x7E, :mov, REG_A, REG_M
      def_inst 0x7F, :mov, REG_A, REG_A

      def_inst 0x80, :add, REG_B
      def_inst 0x81, :add, REG_C
      def_inst 0x82, :add, REG_D
      def_inst 0x83, :add, REG_E
      def_inst 0x84, :add, REG_H
      def_inst 0x85, :add, REG_L
      def_inst 0x86, :add, REG_M
      def_inst 0x87, :add, REG_A

      ## add register with carry
      # adc(REGISTER_ID reg_id)
      def_inst 0x88, :adc, REG_B
      def_inst 0x89, :adc, REG_C
      def_inst 0x8A, :adc, REG_D
      def_inst 0x8B, :adc, REG_E
      def_inst 0x8C, :adc, REG_H
      def_inst 0x8D, :adc, REG_L
      def_inst 0x8E, :adc, REG_M
      def_inst 0x8F, :adc, REG_A

      def_inst 0x90, :sub, REG_B
      def_inst 0x91, :sub, REG_C
      def_inst 0x92, :sub, REG_D
      def_inst 0x93, :sub, REG_E
      def_inst 0x94, :sub, REG_H
      def_inst 0x95, :sub, REG_L
      def_inst 0x96, :sub, REG_M
      def_inst 0x97, :sub, REG_A

      def_inst 0x98, :sbb, REG_B
      def_inst 0x99, :sbb, REG_C
      def_inst 0x9A, :sbb, REG_D
      def_inst 0x9B, :sbb, REG_E
      def_inst 0x9C, :sbb, REG_H
      def_inst 0x9D, :sbb, REG_L
      def_inst 0x9E, :sbb, REG_M
      def_inst 0x9F, :sbb, REG_A

      def_inst 0xA0, :ana, REG_B
      def_inst 0xA1, :ana, REG_C
      def_inst 0xA2, :ana, REG_D
      def_inst 0xA3, :ana, REG_E
      def_inst 0xA4, :ana, REG_H
      def_inst 0xA5, :ana, REG_L
      def_inst 0xA6, :ana, REG_M
      def_inst 0xA7, :ana, REG_A

      def_inst 0xA8, :xra, REG_B
      def_inst 0xA9, :xra, REG_C
      def_inst 0xAA, :xra, REG_D
      def_inst 0xAB, :xra, REG_E
      def_inst 0xAC, :xra, REG_H
      def_inst 0xAD, :xra, REG_L
      def_inst 0xAE, :xra, REG_M
      def_inst 0xAF, :xra, REG_A

      def_inst 0xB0, :ora, REG_B
      def_inst 0xB1, :ora, REG_C
      def_inst 0xB2, :ora, REG_D
      def_inst 0xB3, :ora, REG_E
      def_inst 0xB4, :ora, REG_H
      def_inst 0xB5, :ora, REG_L
      def_inst 0xB6, :ora, REG_M
      def_inst 0xB7, :ora, REG_A

      def_inst 0xB8, :cmp, REG_B
      def_inst 0xB9, :cmp, REG_C
      def_inst 0xBA, :cmp, REG_D
      def_inst 0xBB, :cmp, REG_E
      def_inst 0xBC, :cmp, REG_H
      def_inst 0xBD, :cmp, REG_L
      def_inst 0xBE, :cmp, REG_M
      def_inst 0xBF, :cmp, REG_A

      ##
      # rnz
      #   return if not zero
      def_inst 0xC0, :rnz do
        ret if flag_z == 1
      end

      def_inst 0xC1, :pop, REG_BC

      def_inst 0xC2, :jnz, :address16 do |address16|
        jmp(address16) if flag_z == 0
      end

      def_inst 0xC3, :jmp, :address16

      def_inst 0xC4, :cnz, :address16 do |address16|
        call(address16) if flag_z == 0
      end

      def_inst 0xC5, :push, REG_BC

      ## add immediate without carry
      # adi(int int8)
      def_inst 0xC6, :adi, :int8 do |int8|
        reg_a.cell_add!(int8)
      end

      def_inst 0xC7, :rst,  0

      ##
      # rz
      #   return if zero
      def_inst 0xC8, :rz do
        ret if flag_z == 0
      end

      def_inst 0xC9, :ret do
        ret
      end

      def_inst 0xCA, :jz, :address16 do |address16|
        jmp(address16) if flag_z == 1
      end

      def_inst 0xCB, :null

      def_inst 0xCC, :cz, :address16 do |address16|
        call(address16) if flag_z == 1
      end

      def_inst 0xCD, :call, :address16 do |address16|
        call(address16)
      end

      ## add immediate with carry
      # aci(int n)
      def_inst 0xCE, :aci, :int8 do |int8|
        reg_a.cell_add!(int8).cell_add!(flag_c)
      end

      def_inst 0xCF, :rst,  1

      ##
      # rnc
      #   return if no carry
      def_inst 0xD0, :rnc do
        ret if flag_c == BFALSE
      end

      def_inst 0xD1, :pop, REG_DE

      def_inst 0xD2, :jnc, :address16 do |address16|
        jmp(address16) if flag_c == 0
      end

      ## IO output
      # out(address)
      def_inst 0xD3, :out, :address8 do |address8|
        port.output[address8] << reg_a
      end

      def_inst 0xD4, :cnc, :address16 do |address16|
        call(address16) if flag_c == 0
      end

      def_inst 0xD5, :push, REG_DE

      ## subtract immediate from accumulator
      # sui(int n)
      def_inst 0xD6, :sui, :int8 do |int8|
        reg_a.cell_sub!(int8)
      end

      def_inst 0xD7, :rst,  2

      ##
      # rc
      #   return if carry
      def_inst 0xD8, :rc do
        ret if flag_c == BTRUE
      end

      def_inst 0xD9, :null

      def_inst 0xDA, :jc, :address16 do |address16|
        jmp(address16) if flag_c == 1
      end

      ## IO input
      # in
      def_inst 0xDB, :in, :address8 do |address8|
        port.input[address8] >> reg_a
      end

      def_inst 0xDC, :cc, :address16 do |address16|
        call(address16) if flag_c == 1
      end

      def_inst 0xDD, :null

      ## subtract immediate from accumulator with borrow
      # sbi
      def_inst 0xDE, :sbi, :int8 do |int8|
        reg_a.cell_sub!(int8)
      end

      def_inst 0xDF, :rst,  3

      ##
      # rpo
      #   return if odd parity
      def_inst 0xE0, :rpo do
        ret if flag_p == 0
      end

      def_inst 0xE1, :pop, REG_HL

      def_inst 0xE2, :jpo do
        jmp if flag_p == 0
      end

      def_inst 0xE3, :xthl do
        reg_l.set!(memory.stack_data)
        reg_h.set!(memory.stack_data(+1))
      end

      ## call if odd parity
      # cpo
      def_inst 0xE4, :cpo, :address16 do |address16|
        call(address16) if flag_p == 0
      end

      def_inst 0xE5, :push, REG_HL

      ## logical 'and' with immediate
      # ani(int n)
      def_inst 0xE6, :ani, :int8 do |int8|
        reg_a.land!(n)
      end

      def_inst 0xE7, :rst,  4

      ##
      # rpe
      #   return if even parity
      def_inst 0xE8, :rpe do
        ret if flag_p == 1
      end

      ##
      # pchl
      def_inst 0xE9, :pchl do
        reg_pc.low_data_set(reg_l.cell_data)
        reg_pc.high_data_set(reg_h.cell_data)
      end

      ## jmp if even parity
      # jpe
      def_inst 0xEA, :jpe, :address16 do |address16|
        jmp(address16) if flag_p == 1
      end

      ## exchanges the contents of register D with H and E with L
      # xchng
      def_inst 0xEB, :xchg do
        a, b = reg_d.cell_data, reg_h.cell_data
        reg_d.cell_data_set(b)
        reg_h.cell_data_set(a)
        a, b = reg_e.cell_data, reg_l.cell_data
        reg_e.cell_data_set(b)
        reg_l.cell_data_set(a)
      end

      def_inst 0xEC, :cpe, :address16 do |address16|
        call(address16) if flag_p == 1
      end

      def_inst 0xED, :null

      ## exclusive or (xor) of accumulator with immediate
      # xri(Integer int8)
      def_inst 0xEE, :xri, :int8 do |int8|
        reg_a.xor!(int8)
      end

      def_inst 0xEF, :rst,  5

      ##
      # rp
      #  return if positive sign
      def_inst 0xF0, :rp do
        ret if flag_s == 0
      end

      def_inst 0xF1, :pop, REG_PSW

      ## jump if positive
      # jp
      def_inst 0xF2, :jp, :address16 do |address16|
        jmp(address16) if flag_p == 1
      end

      ## disable interrupt system
      # di
      def_inst 0xF3, :di do
        # TODO
      end

      def_inst 0xF4, :cp, :address16 do |address16|
        call(address16) if flag_p == 1
      end

      def_inst 0xF5, :push, REG_PSW

      ## logical or with immediate
      # ori(Integer int)
      def_inst 0xF6, :ori, :int8 do |int8|
        reg_a.cell_lor!(int8)
      end

      def_inst 0xF7, :rst,  6

      ##
      # rm
      #   return if negative sign
      def_inst 0xF8, :rm do
        ret if flag_s == 1
      end

      def_inst 0xF9, :sphl do
        reg_sp.high_data_set(reg_h.cell_data)
        reg_sp.low_data_set(reg_l.cell_data)
      end

      def_inst 0xFA, :jm, :address16 do |address16|
        jmp(address16) if flag_p == 0
      end

      ## enable interrupt system
      # ei
      def_inst 0xFB, :ei do
        # TODO
      end

      def_inst 0xFC, :cm, :address16 do |address16|
        call(address16) if flag_p == 0
      end

      def_inst 0xFD, :null

      def_inst 0xFE, :cpi, :int8 do |int8|
        compare(reg_a, int8)
      end

      def_inst 0xFF, :rst,  7

      alias :reg_a :reg_accumulator
      alias :reg_f :reg_flag
      alias :reg_sp :stack_pointer

    end
  end
end
