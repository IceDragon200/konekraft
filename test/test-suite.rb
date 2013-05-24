$: << File.dirname(__FILE__)
$: << File.join(Dir.getwd, "..", "lib")
require 'test/unit'
require 'sadie'

class SasmTest < Test::Unit::TestCase

  def test_sasm_sacpu_clock
    clock = Sadie::SASM::Sacpu::Clock.new(nil)
    10.times do
      clock.cycle do |clk|
        puts "TICK[#{clk.tick}] CYCLE[#{clk.cycle_count}] CYCLETICK[#{clk.cycle_tick}]"
      end
    end
  end

  ## TODO
  #
  def test_compile
    file = File.read('data/test.sasm')
    p Sadie::SASM::ASM_8085.instruction_set.table.values.map(&:name).join("|")
    #p 1 - Sadie::SASM::ASM_8085.instruction_set._completion_rate.map(&:to_f).inject(&:/)
    p Sadie::SASM::ASM_AVR.build(file)
  end

  ## TODO
  #
  def test_interpreter
    file = File.read('data/test-8085.sasm')
    assmebler = Sadie::SASM::ASM_8085
    instset = assmebler.instruction_set
    cpu = Sadie::SASM::Sacpu.new(64, instset)
    program = assmebler.build(file)
    puts cpu.freq_s
    intp = cpu.interpreter
    intp.setup(program)
    puts cpu.to_s
    puts intp.tick
    puts cpu.to_s
    puts intp.idle?
  end

end
