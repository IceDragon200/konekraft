$: << File.join(Dir.getwd, "..", "lib")
require 'test/unit'
require 'sadie'

class SasmSacpuInterpreterTest < Test::Unit::TestCase

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
