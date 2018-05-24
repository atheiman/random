# This problem was asked by Amazon.

# Implement a stack that has the following methods:

# push(val), which pushes an element onto the stack
# pop(), which pops off and returns the topmost element of the stack. If there
#   are no elements in the stack, then it should throw an error or return null.
# max(), which returns the maximum value in the stack currently. If there are no
#   elements in the stack, then it should throw an error or return null.

# Each method should run in constant time.

class LifoObject
  attr_reader :obj
  attr_accessor :lower

  def initialize(obj)
    @obj = obj
  end
end

class Lifo
  attr_reader :max

  def push(obj)
    lifo_obj = LifoObject.new(obj)

    lifo_obj.lower = @last

    if lifo_obj.obj.is_a? Numeric
      if @max
        if lifo_obj.obj > @max
          @max = lifo_obj.obj
        end
      else
        @max = lifo_obj.obj
      end
    end

    @last = lifo_obj

    self
  end

  def pop
    return nil unless @last
    old_last = @last
    @last = @last.lower
    old_last.obj
  end

  def last
    @last.obj
  end
end

require 'rspec'

describe Lifo do
  let(:lifo) { described_class.new }

  it '#push' do
    expect(lifo.push('asdf').last).to eq('asdf')
    expect(lifo.push(4).last).to eq(4)
  end

  it '#pop' do
    expect(lifo.pop).to be_nil
    lifo.push('asdf').push(4).push(['a', 'b', 'c'])
    expect(lifo.pop).to eq(['a', 'b', 'c'])
    expect(lifo.pop).to eq(4)
    expect(lifo.pop).to eq('asdf')
    expect(lifo.pop).to be_nil
  end

  it '#max' do
    expect(lifo.max).to be_nil
    lifo.push('asdf').push(4).push(['a', 'b', 'c'])
    expect(lifo.max).to eq(4)
    lifo.push(-1)
    expect(lifo.max).to eq(4)
    lifo.push(12)
    expect(lifo.max).to eq(12)
  end
end
