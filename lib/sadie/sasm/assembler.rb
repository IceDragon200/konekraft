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

      ### constants
      VERSION = "0.2.0".freeze

      ### instance_variables
      attr_reader :instruction_set

      ##
      # initialize(InstructionSet*(Class) instruction_set)
      def initialize(instset)
        @instruction_set = instset
      end

      ##
      # strip_commments(String string) -> String
      def strip_commments(string)
        string.gsub(/;(.*)/, '')
      end

      ##
      # chunkify(String string) -> Array<Chunk>
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

      def cast_as_null(data)
        return Sadie::SASM::Sacpu::BNULL
      end

      def cast_as_register(data)
        if code = Sadie::SASM::Sacpu::REGISTER2CODE[data]
          return code
        else
          raise(RegisterError, "invalid register %s" % data)
        end
      end

      def cast_as_register_pair(data)
        reg2code = Sadie::SASM::Sacpu::REGISTERPAIR2CODE[data]
        a = data[0]
        b = data[1]
        return (reg2code[a] << 4) | reg2code[b]
      end

      def cast_as_int(data)
        if mtch_data = data.match(/(?:0x([A-F0-9]+)|([A-F0-9]+H))/i) # is a Hexi Decimal
          return (mtch_data[1] || mtch_data[2]).hex
        elsif mtch_data = data.match(/(0[01]+)/) # is a binary number
          return mtch_data[1].to_i(2)
        #elsif mtch_data = data.match(/(\d+)/) # is a regular integer
        else
          return data.to_i
        end
      end

      def cast_as_int16(data)
        cast_as_int(data)
      end

      def cast_as_float(data)
        raise(UnimplementedError, "Sacpu does not support casting to 16 bit float")
      end

      def cast_as_address(data)
        cast_as_int(data)
      end

      def cast_as_address16(data)
        cast_as_int(data)
      end

      def data_cast_as(target_datatype, data)
        case target_datatype
        when :null
          cast_as_null(data)
        when :register, :reg # A, B, C, D, E, H, L
          cast_as_register(data)
        when :register_pair, :reg_pair
          cast_as_register_pair(data)
        when :integer, :int # Hex or Integer
          cast_as_int(data)
        when :integer16, :int16
          cast_as_int16(data)
        when :float, :flt   # unimplemented
          cast_as_float(data)
        when :address, :adr
          cast_as_address(data)
        when :address16, :adr16
          cast_as_address16(data)
        else
          raise(CastFailure,
                "failed to cast %s as a %s" % [data.inspect,
                                               target_datatype.inspect])
        end
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
        code_id = @instruction_set.mnemonic_to_code[instname.upcase]
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
