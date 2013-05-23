#
# Sadie/lib/sadie/sasm/assembler.rb
#   by IceDragon
#   dc 23/05/2013
#   dm 23/05/2013
module Sadie
  module SASM
    class Assembler

      class CompileError < Exception
        #
      end

      class CastFailure < Exception
        #
      end

      class UnimplementedError < Exception
        #
      end

      VERSION = "0.2.0".freeze

      attr_reader :instruction_set

      ##
      # initialize(InstructionSet*(Class) instruction_set)
      def initialize(instset)
        @instruction_set = instset
      end

      def strip_commments(string)
        string.gsub(/;(.*)/, '')
      end

      def chunkify(string)
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
        label_chunks = chunkify(code)
        code_chunks = label_chunks.map { |(name, data)|
                                         [name, sasm_tokenize(data)] }
        code_chunks
      end

      def literal_cast_as(target_datatype, data)
        case target_datatype
        when :register, :reg
          return Sadie::SASM::Sacpu::CODE2REGISTER[data]
        else
          return data
        end
      end

      def data_cast_as(target_datatype, data)
        case target_datatype
        when :null
          return Sadie::SASM::Sacpu::BNULL
        when :register, :reg # A, B, C, D, E, H, L
          if code = Sadie::SASM::Sacpu::REGISTER2CODE[data]
            return code
          end
        when :register_pair, :reg_pair
          reg2code = Sadie::SASM::Sacpu::REGISTER2CODE
          a = data[0]
          b = data[1]
          return (reg2code[a] << 8) | reg2code[b]
        when :integer, :int # Hex or Integer
          if mtch_data = data.match(/(?:0x([A-F0-9]+)|([A-F0-9]+H))/i) # is a Hexi Decimal
            return (mtch_data[1] || mtch_data[2]).hex
          elsif mtch_data = data.match(/(0[01]+)/) # is a binary number
            return mtch_data[1].to_i(2)
          elsif mtch_data = data.match(/(\d+)/) # is a regular integer
            return mtch_data[1].to_i
          end
        when :float, :flt   # unimplemented
          raise(UnimplementedError, "Sacpu does not support casting to 16 bit float")
        when :address, :adr
          raise(UnimplementedError, "8 bit address is not yet supported")
        when :address16, :adr16
          raise(UnimplementedError, "16 bit address is not yet supported")
        end
        raise(CastFailure, "failed to cast %s as a %s" % [data.inspect, target_datatype.inspect])
      end

      def assert_code_id(instname, code_id)
        raise(CompileError,
                "Code ID for instruction %s does not exist" % instname
              ) unless code_id
        return true
      end

      ##
      # ::assert_instruction_spec()
      def assert_instruction_spec(instspec, code_id)
        raise(CompileError,
              "InstructionSpec does not match code_id %d" %
              code_id) if instspec.code != code_id
        # TODO

        return true
      end

      def assert_instruction_params(instspec, params)
        raise(CompileError,
              "InstructionSpec %s expected %d args of %s but received %s" %
                [instspec.name, instspec.param_types.size, instspec.param_types,
                 params.inspect]
              ) if instspec.param_types.size != params.size
        return true
      end

      ##
      # ::instname_to_code_id(String instname)
      def instname_to_code_id(instname)
        code_id = @instruction_set.nmemonic_to_code[instname.upcase]
        assert_code_id(instname, code_id)
        return code_id
      end

      ##
      # ::code_id_to_inst(Integer code_id, Array<String> given_params)
      def code_id_to_inst(code_id)
        instspec = @instruction_set.table[code_id]
        assert_instruction_spec(instspec, code_id)
        return instspec
      end

      ##
      # ::compile_instruction(String instname, Array<String> params)
      def compile_instruction(instname, params)
        code_id    = instname_to_code_id(instname)
        instspec   = code_id_to_inst(code_id)
        assert_instruction_params(instspec, params)
        zipdata    = instspec.param_types.zip(params)
        param_data = zipdata.map { |(type, data)| data_cast_as(type, data) }
        return Sadie::SASM::Instruction.new(@instruction_set, code_id, param_data)
      end

      ##
      # ::compile_chunk(Array<<Array[String, Array<String>]>> src_a)
      def compile_chunk(src_a)
        src_a.map { |(instname, params)| compile_instruction(instname, params) }
      end

      ##
      # ::code_chunks(Array[String label, CodeChunk codechunk])
      def compile(code_chunks)
        Hash[code_chunks.map { |(label, codechunk)| [label, compile_chunk(codechunk)] }]
      end

      ##
      # ::build(String string)
      def build(string)
        Sadie::SASM::Program.new(compile(tokenize(string)))
      end

    end
  end
end
