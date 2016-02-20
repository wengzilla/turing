require 'digest'
require 'bigdecimal'

class BloomFilter
  attr_accessor :bit_vector, :count
  DIGESTS = [Digest::MD5, Digest::SHA1, Digest::SHA2]

  def initialize(length=1024)
    @bit_vector = BitVector.new(length)
    @count = 0
  end

  def add(element)
    self.count += 1
    bit_vector.set(get_indices(element))
  end

  def presence?(element)
    bit_vector.set?(get_indices(element))
  end

  def probability_false_positive
    (1 - (1 - BigDecimal.new(1)/bit_vector.length) ** (DIGESTS.length * count)) ** DIGESTS.length
  end

  private

  def get_indices(element)
    DIGESTS.map { |digest| digest.send(:hexdigest, element).hex % bit_vector.length }
  end
end

class BitVector
  attr_accessor :number

  def initialize(length)
    @number = "0" * length
  end

  def set(indices)
    indices.each { |index| self.number[index] = "1" }
  end

  def set?(indices)
    indices.all? { |index| number[index] == "1" }
  end

  def length
    number.length
  end

  def set_bits
    @number.count("1")
  end
end