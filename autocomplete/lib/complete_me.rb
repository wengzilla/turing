class CompleteMe
  attr_accessor :head, :count

  def initialize
    @head = Node.new
    @count = 0
  end

  def insert(word)
    current_node = head
    self.count += 1

    word.split(//).each do |letter|
      previous_node = current_node
      current_node = current_node.visit(letter)

      if current_node.nil?
        current_node = Node.new(letter, previous_node)
        previous_node.children << current_node
      end
    end

    current_node.complete!
  end

  def populate(string)
    string.split(/\n/).each { |word| insert(word) }
  end

  def suggest(string)
    current_node = head

    string.split(//).each do |letter|
      current_node = current_node.visit(letter)
      return [] if current_node.nil?
    end

    CompleteFinder.new(current_node).results
  end
end

class CompleteFinder
  attr_accessor :head, :results

  def initialize(head)
    @head = head
    @results = []
    find_all
  end

  def find_all
    queue = [head]

    while queue.any?
      current_node = queue.shift
      results.push(current_node.word) if current_node.complete
      queue.concat(current_node.children)
    end
  end
end

class Node
  attr_accessor :value, :children, :complete, :parent

  def initialize(value=nil, parent=nil)
    @value = value
    @parent = parent
    @children = []
    @complete = nil
  end

  def visit(letter)
    children.find { |node| node.value == letter }
  end

  def complete!
    self.complete = true
  end

  def word
    letters = []
    current_node = self
    until current_node.value.nil?
      letters.unshift(current_node.value)
      current_node = current_node.parent
    end
    letters.join
  end
end