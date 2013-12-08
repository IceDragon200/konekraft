#
# Sadie/lib/sadie/sasm/instruction_spec.rb
#   by IceDragon
module Sadie
  module SASM
    class InstructionSpec

      ### instance_attributes
      attr_reader :opcode
      attr_reader :inst_sym
      attr_reader :embed_params
      attr_reader :param_types
      attr_reader :bytesize
      attr_reader :arity

      ##
      # initialize(int opcode, Symbol inst_sym, *Array<int> params)
      def initialize(opcode, inst_sym, param_types, embed_params)
        @embed_params = embed_params.dup.freeze
        @opcode       = opcode
        @inst_sym     = inst_sym
        @param_types  = param_types.freeze
        @bytesize     = 1 + @param_types.inject(0) { |r, t| Sadie::BitTool.type_bytesize(t) }
        @arity        = @param_types.size - @embed_params.size
      end

      def bytecode_params_fix(params)
        result = []
        nparams = params.dup
        @param_types.each do |type|
          case type
          when :int, :int8, :integer, :integer8, :adr, :adr8, :address8
            result << nparams.shift
          when :int16, :integer16, :adr16, :address16
            a = nparams.shift
            b = nparams.shift
            result << Sadie::BitTool.ary2_to_int16([a, b])
          when :register, :reg, :reg_pair, :register_pair
            # ignore
          end
        end
        return result
      end

      def fix_params(params)
        result = []
        zip_params = params.zip(@param_types)
        for (param, type) in zip_params
          case type
          when :int, :int8, :integer, :integer8, :adr, :adr8, :address8
            result << param
          when :int16, :integer16, :adr16, :address16
            result.concat(Sadie::BitTool.int16_to_be_ary(param))
          when :register, :reg, :reg_pair, :register_pair
            # don't push it
          end
        end
        return result
      end

      def cast_params(params)
        return [] if @param_types.empty?
        zip_params = params.zip(@param_types)
        zip_params.map do |o, t|
          Sadie::BitTool.data_cast_as(t, o)
        end
      end

      def valid_params_size?(params)
        @param_types.size == params.size
      end

      def valid_params_abs?(params)
        return false unless valid_params_size?(*params)
        return params[0, @embed_params.size] == @embed_params
      end

      def valid_params?(params)
        return false unless valid_params_size?(*params)
        valid_params_abs?(*cast_params(*params))
      end

      def compile(params)
        return nil unless valid_params_size?(*params)
        cparams = cast_params(*params)
        return nil unless valid_params_abs?(*cparams)
        fparams = fix_params(*cparams)
        return [@opcode, fparams]
      end

      ##
      # name -> String
      def name
        @inst_sym.to_s
      end

      def to_s
        "#{"%03d" % opcode} | #{name} (#{param_types.join(", ")}) [#{@arity}]"
      end

    end
  end
end
