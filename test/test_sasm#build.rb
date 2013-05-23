$: << File.join(Dir.getwd, "..", "lib")
require 'test/unit'
require 'sadie'

class SasmTest < Test::Unit::TestCase

  ## TODO
  #
  def test_compile
    file = File.read('data/test.sasm')
    #p Sadie::SASM::ASM_AVR.instruction_set.table.values.map(&:name).join("|")
    p Sadie::SASM::ASM_AVR.build(file)
  end

end
