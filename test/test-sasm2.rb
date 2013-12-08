#!/usr/bin/ruby
# Sadie/test/test-sasm.rb
#
require_relative 'common'

class SadieSasmTest < Test::Unit::TestCase

  def test_sasm2_lex_and_parse_lines
    str = File.read("data/sasm2_test.sasm")
    str.each_line do |line|
      lx = Sadie::SASM::Lexer.lex(line)
      ast = Sadie::SASM::Parser.parse(lx, accept: :all)
    end
  end

  def test_sasm2_lex_and_parse_file
    str = File.read("data/sasm2_test.sasm")
    lx = Sadie::SASM::Lexer.lex(str)
    ast = Sadie::SASM::Parser.parse(lx, accept: :all)
  end

  def test_sasm2_assemble
    prog = Sadie::SASM::Assembler.assemble_file("data/sasm2_test.sasm")
    p prog.to_bytecode
  end

end