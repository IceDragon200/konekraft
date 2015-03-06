#
# Konekraft/lib/konekraft/konekt/component/passive.rb
#
require 'konekraft/konekt2/component/base'

module Konekraft
  module Konekt2
    class Passive < Base

      ### constants
      VERSION = "2.1.0".freeze

      ## inputs
      register_port(:in,  INPUT_ID  = :input, "input")

      ## outputs
      register_port(:out, OUTPUT_ID = :output, "output")

      ### registration
      register('passive')

    end
  end
end
