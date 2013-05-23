$: << File.join(Dir.getwd, "..", "lib")
require 'test/unit'
require 'sadie'

class SasmSacpuClockTest < Test::Unit::TestCase

  def test_sasm_sacpu_clock
    clock = Sadie::SASM::Sacpu::Clock.new(nil)
    10.times do
      clock.cycle do |clk|
        puts "TICK[#{clk.tick}] CYCLE[#{clk.cycle_count}] CYCLETICK[#{clk.cycle_tick}]"
      end
    end
  end

end
