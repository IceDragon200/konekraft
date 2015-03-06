#
# Konekraft/lib/konekraft/sasm/sasm.rb
#
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
