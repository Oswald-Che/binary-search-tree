
class Tree
  attr_accessor :root
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

  def insert(data, root = @root)
    return root = Node.new(data) if root.nil?

    if root.data > data
      root.left = insert(data, root.left)
    elsif root.data < data
      root.right = insert(data, root.right)
    end

    root
  end

  def delete(data, root = @root)
    return root if root.nil?

    if root.data > data
      root.left = delete(data, root.left)
    elsif root.data < data
      root.right = delete(data, root.right)
    else
      if root.left.nil?
        return root.right
      elsif root.right.nil?
        return root.left
      end

      root.data = minv(root.right)

      root.right = delete(root.data, root.right)

    end
    root
  end

  def minv(root)
    min = root.data
    until root.nil?
      min = root.data
      root = root.left
    end
    min
  end

  def find(data, root = @root)
    return root if root.nil?

    if root.data > data
      value = find(data, root.left)
    elsif root.data < data
      value = find(data, root.right)
    else
      value = root
    end
    value
  end

  def level_order_iteration
    array = []
    queue = Array.new(1, @root)
    until queue.none?
      node = queue.shift
      yield node if block_given?
      array << node.data
      queue.push(node.left, node.right).compact!
    end
    array unless block_given?
  end

  def level_order_recursion(array = [], queue = [@root], &block)
    return array if queue.none?

    root = queue.shift
    if block_given?
      yield root
    else
      array << root.data
    end
    queue.push(root.left, root.right).compact!
    array = level_order_recursion(array, queue, &block)
    array unless block_given?
  end

  def preoder(root = @root, array = [], &block)
    return array if root.nil?

    if block_given?
      yield root
    else
      array.push(root.data)
    end
    array = preoder(root.left, array, &block)
    array = preoder(root.right, array, &block)

    array unless block_given?
  end

  def inoder(root = @root, array = [], &block)
    return array if root.nil?

    array = inoder(root.left, array, &block)
    if block_given?
      yield root
    else
     array.push(root.data)
    end
    array = inoder(root.right, array, &block)

    array unless block_given?
  end

  def postoder(root = @root, array = [], &block)
    return array if root.nil?

    array = postoder(root.left, array, &block)
    array = postoder(root.right, array, &block)
    if block_given?
      yield root
    else
     array.push(root.data)
    end

    array unless block_given?
  end

  def height(node, count = 0)
    return count if node.nil?

    count += 1
    l_count = height(node.left, count)
    r_count = height(node.right, count)

    l_count > r_count ? l_count : r_count
  end

  def depth(node, root = @root, count = 0)
    return count if node.nil?

    count += 1
    if root > node
      count = depth(node, root.left, count)
    elsif root < node
      count = depth(node, root.right, count)
    else
      return count
    end
    count
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def balanced?
    (height(@root.left) - height(@root.right)).abs <= 1
  end

  def rebalance
    array = inoder
    @root = build_tree(array)
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

tree = Tree.new(Array.new(15) { rand(1..100) })
puts tree.balanced?
puts tree.preoder
puts tree.inoder
puts tree.postoder
tree.insert(120)
tree.insert(130)
tree.insert(170)
puts tree.balanced?
tree.rebalance
puts tree.balanced?
puts tree.preoder
puts tree.inoder
puts tree.postoder