#
# Konekraft/lib/konekraft/logger.rb
# (mistdragon100@gmail.com)
require 'konekraft/version'
module Konekraft
  module Logger

    ### instance_variables
    attr_accessor :log # IO

    def try_log
      yield(@log) if @log
    end

  end
  extend Logger
end
