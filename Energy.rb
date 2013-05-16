#
# Sadie/src/Energy.rb
#   by IceDragon
#   dc 11/03/2013
#   dm 09/04/2013
# vr 1.1.1
module Sadie
class Energy

  VERSION = "1.1.1".freeze

  TYPE_POWER = 0x0
  TYPE_DATA  = 0x1

  attr_accessor :value, :data

  def initialize(value=0, type=TYPE_POWER)
    @value = value
    @type = type
  end

  def same_type?(src_type)
    self.type == src_type
  end

  def cast_value_type(obj, type)
    obj.is_a?(Energy) ? (same_type?(type) ? obj.value : nil) : obj.to_i
  end

  def cast_value(obj)
    cast_value_type(obj, self.type)
  end

  def +(other)
    if v = cast_value(other)
      @value += v if v
    end
  end

  def -(other)
    if v = cast_value(other)
      @value -= v
    end
  end

  def *(other)
    if v = cast_value(other)
      @value *= v
    end
  end

  def /(other)
    if v = cast_value(other)
      @value /= v
    end
  end

  def zero
    @value = 0
  end

  def calc_pull(src_energy, max, min, cap)
    rem  = src_energy.value - max
    pull = rem < 0 ? (max + rem) : max
    pull = (n = self.value + pull) > cap ? n - cap : pull
    return pull >= min ? pull : 0
  end

  private :cast_value

end
end
