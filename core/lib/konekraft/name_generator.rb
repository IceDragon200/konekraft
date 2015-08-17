module Konekraft
  class NameGenerator
    def initialize
      @data_path = File.join(File.dirname(__FILE__), "data")
      @words = File.read(File.join(@data_path, "words.txt")).split("\n")
      @names = File.read(File.join(@data_path, "names.txt")).split("\n")
    end

    def random_name
      @words.sample + '-' + @names.sample
    end

    def self.instance
      @instance ||= new
    end

    def self.random_name
      instance.random_name
    end
  end
end
