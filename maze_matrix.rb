# This problem was asked by Google.

# You are given an M by N matrix consisting of booleans that represents a board. Each True boolean represents a wall. Each False boolean represents a tile you can walk on.

# Given this matrix, a start coordinate, and an end coordinate, return the minimum number of steps required to reach the end coordinate from the start. If there is no possible path, then return null. You can move up, left, down, and right. You cannot move through walls. You cannot wrap around the edges of the board.

# For example, given the following board:

# [[f, f, f, f],
# [t, t, f, t],
# [f, f, f, f],
# [f, f, f, f]]
# and start = (3, 0) (bottom left) and end = (0, 0) (top left), the minimum number of steps required to reach the end is 7, since we would need to go through (1, 2) because there is a wall everywhere else on the second row.

def step(path: [], matrix: , goal: )
  (possible_positions(path.last, matrix) - path).each do |possible_position|
    if possible_position == goal
      puts "solution found! #{path}"
      if @best_path
        next if @best_path.size <= path.size + 1
      end
      @best_path = path << possible_position
      puts "new best path!"
    else
      step(path: path.clone << possible_position, matrix: matrix, goal: goal)
    end
  end
  @best_path
end

def adjacent_positions(current_position, matrix)
  positions = []
  unless matrix.size == 1
    # add "up" and "down"
    unless current_position[0].zero?
      # add "up" unless at top of board
      positions << [current_position[0] - 1, current_position[1]]
    end
    unless current_position[0] == matrix.size - 1
      # add "down" unless at bottom of board
      positions << [current_position[0] + 1, current_position[1]]
    end
  end
  unless matrix[0].size == 1
    # add "left" and "right"
    unless current_position[1].zero?
      # add "left" unless at left side of board
      positions << [current_position[0], current_position[1] - 1]
    end
    unless current_position[1] == matrix[0].size - 1
      # add "right" unless at right side of board
      positions << [current_position[0], current_position[1] + 1]
    end
  end
  positions
end

def possible_positions(current_position, matrix)
  adjacent_positions(current_position, matrix) - walls(matrix)
end

def walls(matrix)
  # return @walls if @walls
  @walls = []
  matrix.each_index do |row|
    matrix[row].each_index do |col|
      @walls << [row, col] if matrix[row][col]
    end
  end
  @walls
end


require 'rspec'

describe 'maze matrix' do
  let(:matrix) do
    [[false, false, false, false],
     [true,  true,  false, true],
     [false, false, false, false],
     [false, false, false, false]]
  end
  let(:solutions) do
    [
      [[3,0], [3,1], [3,2], [2,2], [1,2], [0,2], [0,3]],
      [[3,0], [3,1], [2,1], [2,2], [1,2], [0,2], [0,3]],
      [[3,0], [2,0], [2,1], [2,2], [1,2], [0,2], [0,3]]
    ]
  end

  it '#step' do
    solution = step(path: [[3,0]], matrix: matrix, goal: [0,3])
    expect(solutions).to include(solution)
    expect(solution.size).to eq(7)
  end

  it '#adjacent_positions' do
    expect(adjacent_positions([1,1], matrix)).to match_array([[0,1], [1,0], [1,2], [2,1]])
    expect(adjacent_positions([0,1], matrix)).to match_array([[0,0], [0,2], [1,1]])
    expect(adjacent_positions([0,3], matrix)).to match_array([[0,2], [1,3]])
    expect(adjacent_positions([3,3], matrix)).to match_array([[3,2], [2,3]])
  end

  it '#possible_positions' do
    expect(possible_positions([2,1], matrix)).to match_array([[2,0], [3,1], [2,2]])
    expect(possible_positions([1,2], matrix)).to match_array([[0,2], [2,2]])
  end

  it '#walls' do
    expect(walls(matrix)).to match_array([[1,0], [1,1], [1,3]])
  end
end
