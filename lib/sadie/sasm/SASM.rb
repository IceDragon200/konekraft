#
# Sadie/src/SASM.rb
#   by IceDragon
#   dc 14/05/2013
#   dm 14/05/2013
# TODO
#   define entry point for a SASM program
#   finish SASM VM to read SASM compiled code
#
# SASM - Sadie Assembly VM

# one day this place will grow codez
module Sadie
  module SASM

    VERSION = "0.1.0".freeze

    class CompileError < Exception
    end

    class CastFailure < Exception
    end

    Instruction = Struct.new(:code, :name, :cpu_method_name,
                             :param_count, :param_types)

    SasmSet = Struct.new(:code, :labels, :labels_index)

    @@inst_table = {}
    @@nmemonic_to_code = {}

    nae = '\S+'
    @label_lexer_rules = [
      [/\A#{nae}:([^(#{nae})])+/i, ?l],
    ]

    @sasm_lexer_rules = [
      [/\A(#{nae})\s+(#{nae})\s*,\s*(#{nae})\s*,\s*(#{nae})/i, ?3],# 3 Param
      [/\A(#{nae})\s+(#{nae})\s*,\s*(#{nae})/i, ?2],               # 2 Param
      [/\A(#{nae})\s+(#{nae})/i, ?1],                              # 1 Param
      [/\A(#{nae})/i, ?0],                                         # 0 Param
    ]

    def self.strip_commments(string)
      string.gsub(/;(.*)/, '')
    end

    def self.chunkify(string)
      chunks = [] # [String name, Array<String> code]
      chunk = nil
      chunk_flush = -> do
        chunks.push(chunk) if chunk
        chunk = nil
      end
      new_chunk = ->(name) do
        chunk_flush.()
        chunk = [name, []]
        chunk
      end
      label_regex = /(?<name>[A-Z][A-Z0-9]*):/i
      string.each_line do |line|
        line.gsub!("\n", "")
        line.gsub!(/\A\s*/, "")
        if mtch_data = line.match(label_regex)
          new_chunk.(mtch_data[:name])
        else
          chunk[1].push(line) if chunk
        end
      end
      chunk_flush.()
      chunks
    end

    def self.sasm_tokenize(code_stack)
      result = []
      code_stack.each do |line|
        @sasm_lexer_rules.each do |(regex, _)|
          if data = line.match(regex)
            label  = data[1]
            params = [data[2], data[3], data[4]]
            params.compact!
            result.push([label, params.size, params])
            break
          end
        end
      end
      return result
    end

    def self.tokenize(string)
      code = string.dup
      code = strip_commments(code)
      label_chunks = chunkify(code)
      code_chunks = label_chunks.map { |(name, data)|
                                       [name, sasm_tokenize(data)] }
      code_chunks
    end

    def self.data_cast_as(data, target_datatype)
      case target_datatype
      when :register # A, B, C, D, E, H, L
        if code = Sadie::Sacpu::REGISTER2CODE[data]
          return code
        end
      when :integer # Hex or Integer
        if mtch_data = data.match(/(?:0x([A-F0-9]+)|([A-F0-9]+H))/i) # is a Hexi Decimal
          return (mtch_data[1] || mtch_data[2]).hex
        elsif mtch_data = data.match(/(0[01]+)/) # is a binary number
          return mtch_data[1].to_i(2)
        elsif mtch_data = data.match(/([1-9][0-9]*)/) # is a regular integer
          return mtch_data[1].to_i
        end
      when :float   # unimplemented

      end
      raise(CastFailure, "failed to cast %s as a %s" % [data, target_datatype])
    end

    def self.compile(code_chunks)
      code_chunks.map do |(label, src_a)|
        src_a_new = src_a.map do |(inst, param_count, params)|
          code_id = @@nmemonic_to_code[inst.upcase]
          unless code_id
            raise(CompileError,
                  "Code ID for instruction %s does not exist" % inst)
          end
          inst = @@inst_table[code_id]
          if param_count != inst.param_count
            raise(CompileError,
                  "Instruction %s expected %d args %s but received %d args %s" %
                  [inst.name, inst.param_count, inst.param_types,
                   param_count, params])
          end
          # [[Type, Data]..]
          zipdata = inst.param_types.zip(params)
          param_data = zipdata.map { |(type, data)| data_cast_as(data, type) }
          [code_id, param_data.size, param_data]
        end
        [label, src_a_new]
      end
    end

    def self.build(string)
      compile(tokenize(string))
    end

    def self.reg(name, code, *params)
      cpu_method_name, param_count, param_types = name.downcase, params.size, params
      inst = @@inst_table[code] = Instruction.new(code, name, cpu_method_name,
                                                  param_count, param_types)
      @@nmemonic_to_code[inst.name] = inst.code
    end

    e = Enumerator.new { |yielder| i = 0; loop { yielder.yield(i); i += 1 } }

    reg('NOP',  e.next)
    reg('ADD',  e.next, :register, :register)
    reg('ADDI', e.next, :register, :integer)
    reg('SUB',  e.next, :register, :register)
    reg('SUBI', e.next, :register, :integer)
    reg('MUL',  e.next, :register, :register)
    reg('MULI', e.next, :register, :integer)
    reg('DIV',  e.next, :register, :register)
    reg('DIVI', e.next, :register, :integer)
    reg('MOV',  e.next, :register, :register)
    reg('HLT',  e.next)

    class SASMVM

      def initialize(cpu)
        @cpu = cpu
      end

      def run(sasm)
        # TODO O:
        #sasm.each do |()|
      end

    end

  end
end

__END__

label:
INSTRUCTION param, param ; comment
