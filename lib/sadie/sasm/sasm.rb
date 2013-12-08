#
# Sadie/lib/sadie/sasm/sasm.rb
#   by IceDragon
# TODO
#   define entry point for a SASM program
#
# SASM - Sadie Assembly VM
module Sadie
  module SASM

    class CompileError < Exception
      #
    end

    class UnimplementedError < Exception
      #
    end

    class RegisterError < Exception
    end

  end
end
