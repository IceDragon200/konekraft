#
# Konekraft/lib/konekraft/sasmc.rb
#
# SlateAssembly::Compiler is a bytecode compiler for SlateAssembly
require 'konekraft/sasm0'

module Konekraft
  module SlateAssembly0
    module Compiler
      def self.to_bytecode_prog(prog)
        bytecode = prog.to_bytecode
        vstr = "VR%-06s" % SlateAssembly0::VERSION.split(".").map { |n| "%02d" % n }.join("")
        head = ("SlateAssembly" + "PROG" + vstr).bytes.pack("c*")
        return head + bytecode
      end

      def self.compile(filename)
        assemble_file_to_program
        prog = SlateAssembly0::Assembler.assemble_file_to_program(filename)
        data = to_bytecode_prog(prog)
        return data
      end

      def self.compile_to(src_filename, dst_filename)
        data = compile(src_filename)
        File.open(dst_filename, "wb") do |f|
          f.write(data)
        end
      end
    end
  end
end
