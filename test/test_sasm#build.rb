$: << File.join(Dir.getwd, "..", "lib")
require 'test/unit'
require 'sadie'

class SasmTest < Test::Unit::TestCase

  ## TODO
  #
  def test_compile
    file = File.read('data/test.sasm')
    p Sadie::SASM::ASM_8085.instruction_set.table.values.map(&:name).join("|")
    #p 1 - Sadie::SASM::ASM_8085.instruction_set._completion_rate.map(&:to_f).inject(&:/)
    p Sadie::SASM::ASM_AVR.build(file)
  end

end
