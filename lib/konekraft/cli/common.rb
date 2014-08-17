require 'colorize'

@env_table = { }
@line_number = 1
@prompt_heading = "konekraft"

def to_commands(str)
  return to_enum :to_commands, str unless block_given?
  str.to_s.chomp.each_line do |line|
    l = line.gsub(/\#(.*)/,'').chomp
    unless l.empty?
      yield l
      @line_number += 1
    end
  end
end

def prompt
  print "#{@prompt_heading}:#{"%03d" % @line_number}~> ".light_green
end

def log_error(str)
  puts "!!! ".light_red << str
end

def subsitute_env(str)
  str.gsub(/\$([A-Z0-9_]+)/i) { @env_table[$1] }
end
