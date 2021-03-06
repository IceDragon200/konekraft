#!/usr/bin/ruby
# Konekraft/test/test-sasm.rb
#
require_relative 'common'

class KonekraftSasmTest < Test::Unit::TestCase
  def test_sasm_sacpu_clock
    clock = Konekraft::Slate::CPU::Clock.new(nil, 2 ** 4)
    10.times do
      clock.cycle do |clk|
        #puts "TICK[#{clk.tick}] CYCLE[#{clk.cycle_count}] CYCLETICK[#{clk.cycle_tick}]"
      end
    end
  end

  ## TODO
  #
  def test_assemble
    puts "Assembling test program"
    file = 'data/test.sasm'
    pp Konekraft::SlateAssembly::Assembler.assemble_file(file)
  end

  ## TODO
  #
  def test_cpu_load_program
    file = 'data/test-8085.sasm'
    assembler = Konekraft::SlateAssembly::Assembler
    sasmvm = Konekraft::Slate::SlateVM.new
    cpu = sasmvm.cpu
    program = assembler.assemble_file(file)
    pp program
    File.write("vm_mem.bin", sasmvm.memory.dump)
    cpu.load_program(program)
    File.write("vm_mem.bin", sasmvm.memory.dump)
    puts cpu.to_s
    puts cpu.run
    puts cpu.to_s
    puts "cpu.idle? => %s" % cpu.idle?
  end
end
