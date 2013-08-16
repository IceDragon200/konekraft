#!/usr/bin/ruby
# Sadie/test/test-sasm.rb
#
require_relative 'common'

class SadieSasmTest < Test::Unit::TestCase

  def test_sasm_sacpu_clock
    clock = Sadie::SASM::Sacpu::Clock.new(nil, 2 ** 4)
    10.times do
      clock.cycle do |clk|
        #puts "TICK[#{clk.tick}] CYCLE[#{clk.cycle_count}] CYCLETICK[#{clk.cycle_tick}]"
      end
    end
  end

  ## TODO
  #
  def test_compile
    file = File.read('data/test.sasm')
    puts Sadie::SASM::Assembler8085.build(file).instructions_str
  end

  ## TODO
  #
  def test_interpreter
    file = File.read('data/test-8085.sasm')
    assembler = Sadie::SASM::Assembler8085
    sasmvm = Sadie::SASM::SlateVM.new
    cpu = sasmvm.cpu
    program = assembler.build(file)
    puts program.instructions_str
    puts cpu.freq_s
    intp = sasmvm.interpreter
    intp.load_program(program)
    puts cpu.to_s
    puts intp.tick
    puts cpu.to_s
    puts "cpu.idle? => %s" % intp.idle?
  end

end
