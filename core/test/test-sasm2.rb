#!/usr/bin/ruby
# Konekraft/test/test-sasm.rb
#
require_relative 'common'

class KonekraftSasmTest < Test::Unit::TestCase

  def test_sasm2_lex_and_parse_lines
    str = File.read("data/sasm2_test.sasm")
    str.each_line do |line|
      lx = Konekraft::SlateAssembly::Lexer.lex(line)
      ast = Konekraft::SlateAssembly::Parser.parse(lx, accept: :all)
    end
  end

  def test_sasm2_lex_and_parse_file
    str = File.read("data/sasm2_test.sasm")
    lx = Konekraft::SlateAssembly::Lexer.lex(str)
    ast = Konekraft::SlateAssembly::Parser.parse(lx, accept: :all)
  end

  def test_sasm2_assemble
    prog = Konekraft::SlateAssembly::Assembler.assemble_file("data/sasm2_test.sasm")
    p prog.to_bytecode
  end

end
