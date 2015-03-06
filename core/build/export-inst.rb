$: << File.dirname(__FILE__)
$LOAD_PATH.unshift(File.join(Dir.getwd, "..", "lib"))
require 'fileutils'
require 'test/unit'
require 'pp'
require 'konekraft'

    #insts = Konekraft::Slate::Interpreter8085.instspec_table.values.map(&:inst_sym).uniq
    #puts
    #insts.sort.map do |sym|
    #  puts "rule(/#{sym}/) { :KI#{sym.to_s.upcase} }"
    #end
    Konekraft::Slate::CPU.struct_spec.map do |c, a|
      sym, params = a
      params = params.map do |prm|
        case prm.to_s
        when 'int', 'int8', 'int16'
          :NUMBER
        when 'address', 'address8', 'address16'
          :address
        when /reg_(\S+)/
          "REG_#{$1.upcase}".to_sym
        when "0".."7"
          "NUM#{prm}"
        else
          prm
        end
      end
      param_s = params.join(" COMMA ")
      param_s = " " + param_s if params.size > 0
      i = 0
      arg_tabs = param_s.split(" ").map do |m|
        case m
        when "NUMBER", "address" then
          i += 1
          "n#{i}"
        else "_"
        end
      end
      prms = arg_tabs.reject { |s| s == "_" }
      arg_tabs = (["_"] + arg_tabs).join(",")
      str =  "clause('KI%<sym>s%<param_s>s')" % { sym: sym.to_s.upcase, param_s: param_s }
      str += "#{" " * (36 - str.size)}{ |%<arg_tabs>s|#{" " * (8 - arg_tabs.size)} AST::Instruction.new(%<code>d, [%<prms>s])}" % { code: c, prms: prms.join(","), arg_tabs: arg_tabs }
      puts (" " * 8) + str
      #p [c, a]
    end
