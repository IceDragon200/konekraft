#
# Konekraft/lib/konekraft/sasm/sasm.rb
#   by IceDragon
# TODO
#   define entry point for a SlateAssembly program
#
# SlateAssembly - Konekraft Assembly
module Konekraft
  module SlateAssembly
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
