#
# Konekraft/lib/konekraft/sasm/ast.rb
#   by IceDragon
require 'rltk/ast'
module Konekraft
  module SlateAssembly
    module AST

      class Expression < RLTK::ASTNode ; end

      class Number < Expression
        value :value, Integer
      end

      class Register < Expression
        value :value, String
      end

      class Namespace < Expression
        value :path, [String]
      end

      class NamespaceCall < Expression
        child :ns, Namespace
        value :func_name, String
      end

      class NamespaceDeclaration < Expression
        child :ns, Namespace
      end

      class Label < Expression
        value :name, String
      end

      class LabelNamespace < Label
        child :ns, Namespace
      end

      class ExternLabel < LabelNamespace
      end

      class NamespaceLabel < LabelNamespace
      end

      class UsingNamespace < NamespaceDeclaration
      end

      class Instruction < Expression
        value :code, Integer
        value :params, [Object]
      end

      class InstructionCall < Expression
        value :inst, String
        child :params, [Expression]
      end

    end
  end
end
