$: << File.dirname(__FILE__)
$LOAD_PATH.unshift(File.join(Dir.getwd, "..", "lib"))
require 'fileutils'
require 'test/unit'
require 'pp'
require 'konekraft'

target = File.open("rasm.rb", "w")
target.sync = true
specs = Konekraft::Slate::CPU.struct_spec#.uniq { |_,a| a[0] }
spec_batches = specs.each_with_object({}) do |(c, a), hsh|
  #puts [c, a].inspect
  op_sym = a[0]
  (hsh[op_sym] ||= []) << [c, a[1]]
end

spec_batches.each do |op_sym, ops|
  #p ops
  fixed_ops = ops.map do |(opcode, params)|
    new_params = params.map do |prm|
      case prm.to_s
      when 'int', 'int8', 'int16'
        'NUMBER'
      when 'address', 'address8', 'address16'
        'address'
      when /reg_([ABCDEFHLSPM]+)/i
        "REG_#{$1.upcase}"
      when "0".."7"
        "NUM#{prm}"
      else
        prm
      end
    end
    [opcode, new_params]
  end
  #p fixed_ops
  op_param_pairs = fixed_ops.map do |op|
    param_count = {}
    param_count.default = 0
    op[1].map do |param|
      case param
      when 'NUMBER'                then [param, "numb" + (param_count[:numb] += 1).to_s]
      when 'address'               then [param, "addr" + (param_count[:addr] += 1).to_s]
      # Fixed value
      when /reg_([ABCDEFHLSPM]+)/i then [param, "regi" + (param_count[:regi] += 1).to_s]
      when /NUM(\d+)/              then [param, "fixn" + (param_count[:fixn] += 1).to_s]
      end
    end
  end
  common_params = op_param_pairs.first
  fixed_state = fixed_ops.size == 1
  #!common_params.find { |s| s =~ /regi(\d+)/ || s =~ /fixn(\d+)/ }
  param_s = common_params.size > 0 ? "(#{common_params.map(&:last).join(", ")})" : ""
  #p param_s
  type_cast = lambda do |lst|
    lst.map do |(n,s)|
      case s
      when /numb(\d+)/ then [n, "#{s}.to_i"]
      when /addr(\d+)/ then [n, "#{s}.to_i"]
      when /regi(\d+)/ then [n, "_register(#{s})"]
      when /fixn(\d+)/ then [n, "_rst(#{s})"]
      end
    end
  end
  contents = if fixed_state
    first_op = fixed_ops.first
    opcode = first_op.first
    type_casted = type_cast.(common_params)
    extra_params = type_casted.empty? ? "" : ", " + type_casted.map(&:last).join(",")
    "_op(#{opcode}#{extra_params})"
  else
    type_casted = type_cast.(common_params)
    rejected = type_casted.select{|(_,s)|s=~/(regi|fixn)(\d+)/}
    remaining = (type_casted - rejected)
    extra_params = remaining.empty? ? "" : ", " + remaining.map(&:last).join(",")
    "case [#{rejected.map(&:last).join(", ")}]\n" <<
    fixed_ops.zip(op_param_pairs).map do |((opcode, _), op_params)|
      opp = op_params.reject { |(k,l)| ['NUMBER', 'address'].include?(k) }
      opp.map! do |(k,l)|
        [":#{k.downcase.sub("reg_","")}", l]
      end
      ("  " * 5) + "when [#{opp.map(&:first).join(", ")}] then _op(#{opcode}#{extra_params})"
    end.join("\n") <<
    "\n          else raise ArgumentError, \"invalid parameters \#{[#{rejected.map(&:last).join(", ")}]}\"" <<
    "\n          end"
  end
target.puts <<-__EOF__
        def #{op_sym}#{param_s}
          #{contents}
        end

__EOF__
end
