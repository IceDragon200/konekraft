#!/usr/bin/ruby
# Konekraft/test/test-konekraft-tree.rb
#
require_relative 'common'

# https://gist.github.com/workmad3/6257580
#   :D Big Thanks for workmad3 for the graphviz code
require 'graphviz'

def add_module(g, parent, m, visited, depth = 0)
  return if depth > 100
  if visited[m]
    g.add_edges(parent, visited[m])
    return
  end
  visited[m] = current = g.add_nodes(m.name)

  if parent
    g.add_edges(parent, current)
  end

  m.constants.each do |c|
    if m.const_get(c).is_a?(Module)
      add_module(g, current, m.const_get(c), visited, depth.succ)
    end
  end
end

# Create a new graph
g = GraphViz.new( :G, :type => :digraph )
visited = {}
add_module(g, nil, Konekraft, visited)
g.output( :png => "#{visited.keys.first.name}.png" )

###
# and my own not so pretty code...
def tree(visited, tree_ary, mod, depth=0)
  if !mod.is_a?(Module) || visited[mod]
    return nil
  end
  ary = []
  tree_ary.push(mod, ary)
  visited[mod] = true
  mod.constants.map do |name|
    tree(visited, ary, mod.const_get(name), depth+1)
  end
end

def depth_str(ary, obj, depth)
  if obj.is_a?(Array)
    obj.each do |sub_obj|
      depth_str(ary, sub_obj, depth.succ)
    end
  else
    s = obj.inspect
    ary.push(("  " * depth) + s)
  end
end

mod = Konekraft
tree_ary = []
ary = []
tree({}, tree_ary, mod)
depth_str(ary, tree_ary, -1)
File.write("#{mod}-tree.txt", ary.join("\n"))

#class KonekraftTreeTest < Test::Unit::TestCase
#end
