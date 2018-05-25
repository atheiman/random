# This problem was asked by Google.

# We can determine how "out of order" an array A is by counting the number of
# inversions it has. Two elements A[i] and A[j] form an inversion if A[i] > A[j]
# but i < j. That is, a smaller element appears after a larger element.

# Given an array, count the number of inversions it has. Do this faster than
# O(N^2) time.

# You may assume each element in the array is distinct.

# For example, a sorted list has zero inversions. The array [2, 4, 1, 3, 5] has
# three inversions: (2, 1), (4, 1), and (4, 3). The array [5, 4, 3, 2, 1] has
# ten inversions: every distinct pair forms an inversion.

class Array
  attr_reader :loop_count

  def inversions
    _inversions = []
    @loop_count = 0
    self.each_with_index do |elem, idx|
      self[idx + 1..-1].each do |compare|
        @loop_count += 1
        _inversions << [elem, compare] if elem > compare
      end
    end
    _inversions
  end
end

require 'rspec'

describe Array do
  let(:solutions) do
    [
      { array: [2, 4, 1, 3, 5], inversions: [[2,1], [4,1], [4,3]] },
      { array: [1, 2, 3], inversions: [] },
      { array: [-4, -5, 6, 2],
        inversions: [[-4, -5], [6, 2]] },
      { array: [5, 4, 3], inversions: [[5, 4], [5, 3], [4, 3]] }
    ]
  end

  it '#inversions' do
    solutions.each do |sol|
      expect(sol[:array].inversions).to match_array(sol[:inversions])
      expect(sol[:array].loop_count).to be <= (sol[:array].size ** 2)
    end
  end
end
