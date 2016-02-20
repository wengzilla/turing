require 'minitest/autorun'
require './../bloom_filter'

describe "BloomFilter" do
  before { @bf = BloomFilter.new }
  
  describe "#new" do
    it "should instantiate a new bit vector" do
      @bf.bit_vector.wont_be_nil
    end
  end

  describe "#presence?" do
    it "should return true if there is probability the element is in the set" do
      @bf.add("pizza")
      @bf.presence?("pizza").must_equal true
    end

    it "should return false if there is no probability the elmement is in the set" do
      @bf.add("pizza")
      @bf.presence?("pasta").must_equal false
    end
  end

  describe "#add" do
    it "should add the element to the bit vector" do
      @bf.add("pizza")
      @bf.bit_vector.set_bits.must_equal 3
    end
  end

  describe "#probability_false_positive" do
    it "should increase as more elements are added" do
      p_one = @bf.probability_false_positive
      @bf.add("pizza")
      p_two = @bf.probability_false_positive
      p_one.must_be :<, p_two
      @bf.add("pasta")
      p_three = @bf.probability_false_positive
      p_two.must_be :<, p_three
    end
  end
end