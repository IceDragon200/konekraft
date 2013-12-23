#
# Sadie/lib/sadie/sasm/assembler.rb
#
require 'sadie/sasm/ast'
module Sadie
  module SASM
    class Assembler

      SoftLabel = Struct.new(:name)

      ##
      # namespace code is written to the bottom while instructions are
      # written at the top
      # the global namespace is ALWAYS placed first, all of its code will
      # be collapsed (regardless of its position in the source code)
      def self.assemble(asts)
        namespaces = {}
        default_namespace = ["global"]
        current_namespace = namespaces[default_namespace] ||= []

        namespace_map = {}
        visited = {}

        flat = []

        label_index = {}

        convert_params = lambda do |ary|
          ary.map do |obj|
            case obj
            when AST::NamespaceLabel
              if ns = obj.ns
                name = ns.path.join(".") + "." + obj.name
              else
                name = obj.name
              end
              SoftLabel.new(name)
            when AST::Label
              SoftLabel.new("global." + obj.name)
            else
              obj
            end
          end
        end
        ns_flatten = lambda do |hsh|
          (hsh[:code] || []).each do |inst|
            case inst
            when AST::Label
              lb = hsh[:path].join(".") + "." + inst.name
              flat << [:label, [SoftLabel.new(lb)]]
            when AST::Instruction
              flat << [:inst, [inst.code, convert_params.(inst.params)]]
            end
          end
          (hsh[:ns] || []).each do |k, hsh|
            end_label = hsh[:path].join(".") + "." + "end"
            flat << [:inst, [195, [SoftLabel.new(end_label)]]]
            ns_flatten.(hsh)
            flat << [:label, [SoftLabel.new(end_label)]]
          end
        end

        # build initial namespaces
        asts.each do |ast|
          case ast
          when AST::UsingNamespace
            p "keyword `using` is not yet supported"
          when AST::ExternLabel
            p "keyword `extern` is not yet supported"
          when AST::NamespaceDeclaration
            if ns = ast.ns
              current_namespace = (namespaces[ns.path] ||= [])
            else
              current_namespace = namespaces[default_namespace]
            end
          when AST::Label
            current_namespace << ast
          when AST::Instruction
            current_namespace << ast
          else
            p ast
          end
        end
        # compact and setup all namespaces with their respective codes
        namespaces.each_key do |k|
          next if visited[k]
          back = []
          bckey = []
          k = Array(k)
          prev = nil
          k.each do |ks|
            bckey << ks
            prev = (prev || namespace_map)[ks] ||= {}
            if !visited[bckey]
              bck_code = namespaces[bckey]
              prev[:parent] = back
              prev[:path] = bckey
              prev[:labels] ||= []
              prev[:code] ||= []
              prev[:code].concat(bck_code) if bck_code
              prev[:code].each do |inst|
                case inst
                when AST::Label
                  prev[:labels].push(inst.name)
                end
              end
            end
            prev = (prev[:ns] ||= {})
            visited[bckey] = true
            back = bckey
          end
        end
        # flatten the namespace code into a single stream
        namespace_map.each do |k, hsh|
          ns_flatten.(hsh)
        end
        # create label indecies
        flat.each_with_index do |(t, prms), i|
          case t
          when :label
            label_index[prms.first] = i
          end
        end
        # replace all SoftLabels with the label_index values
        flat.each do |(t, prms)|
          if t == :inst
            if prms
              prms[1].map! do |prm|
                if prm.is_a?(SoftLabel)
                  label_index.fetch(prm)
                else
                  prm
                end
              end
            end
          end
        end
        # discard all labels by replacing them with "nop"
        insts = flat.map do |(t, prms)|
          if t == :label
            [0, []]
          else
            prms
          end
        end
        #pp insts
        Program.new(insts.map do |code, params|
          # TODO.
          #   Slate::CPU is used for the InstructionSet, this needs to be
          #   changed
          Program::Instruction.new(Sadie::Slate::CPU, code, params)
        end)
      end

      def self.assemble_file(filename)
        str = File.read(filename)
        lxs = str.each_line.map { |line| Sadie::SASM::Lexer.lex(line) }
        asts = lxs.map { |lx| Sadie::SASM::Parser.parse(lx, accept: :all) }
        Sadie::SASM::Assembler.assemble(asts.flatten)
      end

    end
  end
end