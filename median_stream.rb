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
    @list = [num]
  end
  @median = calculate_sorted_median(@list.sort)
end

# this solution is better and the difference becomes more obvious the longer the
# list gets
def better_list_append(num)
  if @small_list.nil?
    # first number processed
    @small_list = [num]
    return @median = num
  end

  # assign the number to the small or large list and sort the updated list
  if num > @small_list.last
    if @large_list
      @large_list << num
      @large_list.sort!
    else
      @large_list = [num]
    end
  else
    @small_list << num
    @small_list.sort!
    @median = num
  end

  # balance lists (size should be within one)
  if @large_list.nil?
    # haven't yet added to large list
    @large_list = [@small_list.pop]
  elsif @small_list.size - 1 > @large_list.size
    # small list is getting too big
    @large_list.unshift(@small_list.pop)
  elsif @large_list.size - 1 > @small_list.size
    # large list is getting too big
    @small_list << @large_list.shift
  end

  # return the easy to calculate median
  if (@small_list.size + @large_list.size).odd?
    if @small_list.size > @large_list.size
      @small_list.last
    else
      @large_list.first
    end
  else
    @median = (@small_list.last + @large_list.first).to_f / 2
  end
end


require 'rspec'

describe ::File.basename(__FILE__, '.rb') do
  let(:solutions) do
    [
      [2, 2],
      [1, 1.5],
      [5, 2],
      [7, 3.5],
      [2, 2],
      [0, 2],
      [5, 2]
    ]
  end
  context 'bad_list_append' do
    it 'calculates the median of a sorted list' do
      expect(calculate_sorted_median([1])).to eq(1)
      expect(calculate_sorted_median([-1, -1])).to eq(-1)
      expect(calculate_sorted_median([-1, -1, 1])).to eq(-1)
      expect(calculate_sorted_median([-1, -1, 0, 2])).to eq(-0.5)
      expect(calculate_sorted_median([-1, -1, 1, 2, 3])).to eq(1)
    end

    it 'returns the new median when a number is appended' do
      solutions.each do |solution|
        expect(bad_list_append(solution.first)).to eq(solution.last)
      end
    end
  end

  context 'better_list_append' do
    it 'returns the new median when a number is appended' do
      solutions.each do |solution|
        expect(better_list_append(solution.first)).to eq(solution.last)
      end
    end
  end
end


require 'benchmark'

n = 10000
sequence = [-10, 20, 18, 9, 4, -10, -6, -2, 14, 6, 18, 6, 2, 9, -19, -15, 20,
            -19, -8, -16, 4, 6, -7, -19, 1, -9, -11, -16, -11, -6, -16, 8]
Benchmark.bm(10) do |x|
  x.report('bad_list_append') do
    n.times do
      @small_list = nil
      @large_list = nil
      @median = nil
      sequence.each { |num| bad_list_append(num) }
    end
  end
  x.report('better_list_append') do
    n.times do
      @small_list = nil
      @large_list = nil
      @median = nil
      sequence.each { |num| better_list_append(num) }
    end
  end
end
