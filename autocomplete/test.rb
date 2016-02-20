require "minitest/autorun"
require "./lib/complete_me"

describe CompleteMe do
  before do
    @cm = CompleteMe.new
  end

  describe "#insert" do
    it "should build a tree with nodes containing letters of the word" do
      @cm.insert('piz')
      @cm.head.visit('p').visit('i').visit('z').wont_be_nil
    end

    it "should not build a tree with nodes not containing letters of the word" do
      @cm.insert('pizza')
      @cm.head.visit('i').must_equal nil
    end

    it "should not add nodes with the same letter as other child nodes" do
      @cm.insert('pizza')
      @cm.insert('papa')
      @cm.head.children.length.must_equal 1
    end
  end
end

describe CompleteFinder do
  before do
    @cm = CompleteMe.new
  end

  describe "#results" do
    it "should return all complete words from a given node" do
      @cm.insert('pizza')
      @cm.insert('papa')
      CompleteFinder.new(@cm.head.visit('p').visit('i')).results.must_equal ['pizza']
    end
  end
end

describe Node do
  before do
    @cm = CompleteMe.new
  end
  
  describe "#word" do
    it "should return a complete word from a given node" do
      @cm.insert('pizza')
      @cm.insert('papa')
      @cm.head.visit('p').visit('i').visit('z').word.must_equal 'piz'
    end
  end
end