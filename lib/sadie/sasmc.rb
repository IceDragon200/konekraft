#
# Sadie/lib/sadie/sasmc.rb
#   by IceDragon
# SASMC is a bytecode compiler for SASM
require 'sadie/sasm'
module Sadie
  module SASM
    module SASMC

      def self.to_bytecode_prog(prog)
        bytecode = prog.to_bytecode
        vstr = "VR%-06s" % Sadie::SASM::VERSION.split(".").map { |n| "%02d" % n }.join("")
        head = ("SASM" + "PROG" + vstr).bytes.pack("c*")
        return head + bytecode
      end

      def self.compile(filename)
        assemble_file_to_program
        prog = Sadie::SASM::Assembler.assemble_file_to_program(filename)
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