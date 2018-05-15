# This problem was asked by Microsoft.

# Compute the running median of a sequence of numbers. That is, given a stream of numbers, print out the median of the list so far on each new element.

# Recall that the median of an even-numbered list is the average of the two middle numbers.

# For example, given the sequence [2, 1, 5, 7, 2, 0, 5], your algorithm should print out:

# 2
# 1.5
# 2
# 3.5
# 2
# 2
# 2

def calculate_sorted_median(list)
  return list[list.size / 2] if list.size.odd?

  low = list[(list.size / 2) - 1]
  high = list[list.size / 2]
  if low == high
    low
  else
    (low.to_f + high.to_f) / 2
  end
end

@list = []
@median = nil

def bad_list_append(num)
  if @median
    if num > @median
      @list << num
    elsif num == @median
      @list.insert((@list.size / 2).round, num)
    else
      @list.unshift(num)
    end
  else
    @list = Array(num)
  end
  @median = calculate_sorted_median(@list.sort)
end

require 'rspec'

describe ::File.basename(__FILE__, '.rb') do
  it 'calculates the median of a sorted list' do
    expect(calculate_sorted_median([1])).to eq(1)
    expect(calculate_sorted_median([-1, -1])).to eq(-1)
    expect(calculate_sorted_median([-1, -1, 1])).to eq(-1)
    expect(calculate_sorted_median([-1, -1, 0, 2])).to eq(-0.5)
    expect(calculate_sorted_median([-1, -1, 1, 2, 3])).to eq(1)
  end

  context 'bad_list_append' do
    it 'returns the new median when a number is appended' do
      expect(bad_list_append(2)).to eq(2)
      expect(bad_list_append(1)).to eq(1.5)
      expect(bad_list_append(5)).to eq(2)
      expect(bad_list_append(7)).to eq(3.5)
      expect(bad_list_append(2)).to eq(2)
      expect(bad_list_append(0)).to eq(2)
      expect(bad_list_append(5)).to eq(2)
    end
  end
end

require 'benchmark'

n = 500
sequence = [2, 1, 5, 7, 2, 0, 5]
Benchmark.bm(10) do |x|
  x.report('bad_list_append') do
    n.times do
      sequence.each { |num| bad_list_append(num) }
    end
  end
end
