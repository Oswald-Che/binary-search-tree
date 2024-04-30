
class Tree
  def initialize(array)
    array = array.uniq!.sort
    @root = build_tree(array)
  end

  def build_tree(array)
    mid_index = array.length/2
    start_index = 0
    end_index = array.length - 1
    return nil if start_index > end_index

    root = Node.new(array[mid_index])
    root.left = build_tree(array[start_index...mid_index])
    root.right = build_tree(array[(mid_index+1)..end_index])

    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

# Node class for binary search tree to store data and other nodes
class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  def <=>(other)
    data <=> other.data
  end
end

tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
puts tree.pretty_print