#
# Konekraft/lib/konekraft/internal/logic_tool.rb
#
module Konekraft
  module LogicTool

    def and(a, b)
      (a && b) ? true : false
    end

    def or(a, b)
      (a || b) ? true : false
    end

    def buffer(a)
      !!a
    end

    def invert(a)
      !a
    end

    def nand(a, b)
      (a && b) ? false : true
    end

    def nor(a, b)
      (a || b) ? false : true
    end

    def xor(a, b)
      (a || b) && !(a && b) ? true : false
    end

    def xnor(a, b)
      (a && b) || (!a && !b) ? true : false
    end

    extend self

  end
end
