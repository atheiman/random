# This problem was asked by Google.
# Given a list of integers S and a target number k, write a function that returns a subset of S that
# adds up to k. If such a subset cannot be made, then return null.
# Integers can appear more than once in the list. You may assume all numbers in the list are
# positive.
# For example, given S = [12, 1, 61, 5, 9, 2] and k = 24, return [12, 9, 2, 1] since it sums up to
# 24.

# (this is a joke)
def sum_subset_random(sum, list)
  list.select! { |n| n <= sum }
  subset = []
  until sum == subset.sum
    subset = list.sample(1 + rand(list.count))
  end
  subset
end

def sum_subset(sum, available, used = [])
  available.each_with_index do |num, idx|
    if used.sum + num == sum
      solution = used << num
      if @best_subset
        break unless solution.size < @best_subset.size
      end
      return @best_subset = solution
    elsif used.sum + num > sum
      next
    else
      current_used = used.clone
      current_used << num
      current_available = available.clone
      current_available.delete_at(idx)
      sum_subset(sum, current_available, current_used)
    end
  end
  @best_subset
end

require 'rspec'

describe __FILE__ do
  it 'finds the smallest subset of a list that adds to a sum' do
    expect(sum_subset(24, [12, 1, 61, 5, 9, 2].shuffle)).to match_array([12, 9, 2, 1])
    expect(sum_subset(12, [2, 3, 5, 3, 5, 3, 3].shuffle)).to match_array([2, 5, 5])
  end

  it 'returns nil for an impossible sum and list combination' do
    expect(sum_subset(7, [5, 3, 1, 8])).to be_nil
  end
end
