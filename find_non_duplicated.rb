# This problem was asked by Google.

# Given an array of integers where every integer occurs three times except for one integer, which only occurs once, find and return the non-duplicated integer.

# For example, given [6, 1, 3, 3, 3, 6, 6], return 1. Given [13, 19, 13, 13], return 19.

# Do this in O(N) time and O(1) space.

def find_solo(list)
  seen = {}
  list.each do |num|
    seen[num] = seen[num].to_i + 1
  end
  seen.select { |num, count| count == 1 }.keys.first
end

describe ::File.basename(__FILE__, '.rb') do
  it 'returns the non-duplicated integer' do
    expect(find_solo([6, 1, 3, 3, 3, 6, 6])).to eq(1)
    expect(find_solo([13, 19, 13, 13])).to eq(19)
  end
end
