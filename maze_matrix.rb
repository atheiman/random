# This problem was asked by Google.

# You are given an M by N matrix consisting of booleans that represents a board.
# Each True boolean represents a wall. Each False boolean represents a tile you
# can walk on.

# Given this matrix, a start coordinate, and an end coordinate, return the
# minimum number of steps required to reach the end coordinate from the start.
# If there is no possible path, then return null. You can move up, left, down,
# and right. You cannot move through walls. You cannot wrap around the edges of
# the board.

# For example, given the following board:

# [[f, f, f, f],
# [t, t, f, t],
# [f, f, f, f],
# [f, f, f, f]]

# and start = (3, 0) (bottom left) and end = (0, 0) (top left), the minimum
# number of steps required to reach the end is 7, since we would need to go
# through (1, 2) because there is a wall everywhere else on the second row.

def step(path: [], matrix: , goal: )
  options = possible_positions(path.last, matrix) - path
  # sort_toward_goal(options, goal).each do |possible_position|
  sort_toward_goal_with_shuffle(options, goal).each do |possible_position|
    if possible_position == goal
      @best_path = path << possible_position
      puts "new best path! #{path.size} #{path}"
      print_path(path, matrix)
    else
      new_path = path.clone << possible_position
      if @best_path
        # dont step farther if the best_path size is the minimum distance from
        # start to goal
        return @best_path if @best_path.size - 1 == distance(path.first, goal)

        # dont step farther if the best_path size is only one more than the
        # new_path size because the best solution ahead cant be better than the
        # current best_path
        return @best_path if @best_path.size <= new_path.size + 1
      end
      step(path: new_path, matrix: matrix, goal: goal)
    end
  end
  @best_path
end

def distance(first, goal)
  (first[0] - goal[0]).abs + (first[1] - goal[1]).abs
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

def sort_toward_goal(possible_positions, goal)
  possible_positions.sort_by! { |pos| distance(pos, goal) }
end

def sort_toward_goal_with_shuffle(possible_positions, goal)
  # returns the possible positions sorted toward the goal, but with equally
  # ranked possible positions shuffled (so the runner doesnt always try
  # directions in the same order)
  distance_map = {}
  possible_positions.each do |pos|
    d = distance(pos, goal)
    if distance_map[d]
      distance_map[d] << pos
    else
      distance_map[d] = [pos]
    end
  end
  sorted = []
  distance_map.keys.sort.each do |d|
    distance_map[d].shuffle.each { |pos| sorted << pos }
  end
  sorted
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

def print_path(path, matrix)
  matrix.each_index do |row|
    matrix[row].each_index do |col|
      if path.include? [row, col]
        print 'X'
      else
        print '_'
      end
      print ' '
    end
    puts
  end
end


require 'rspec'

def start(matrix)
  # returns bottom-left corner
  [matrix.size - 1, 0]
end

def goal(matrix)
  # returns top-right corner
  [0, matrix[0].size - 1]
end

describe 'maze matrix' do
  context 'small' do
    let(:matrix) do
      [[false, false, false, false],
       [true,  true,  false, true ],
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
      solution = step(path: [start(matrix)], matrix: matrix, goal: goal(matrix))
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

    it '#sort_toward_goal' do
      best_option = sort_toward_goal([[0,1], [1,0], [1,2], [2,1]], [0,3]).first
      expect([[0,1], [1,2]]).to include(best_option)

      best_option = sort_toward_goal([[0,1], [1,0], [1,2], [2,1]], [3,0]).first
      expect([[1,0], [2,1]]).to include(best_option)
    end

    it '#distance' do
      expect(distance([0,1], [3,4])).to eq(6)
      expect(distance([3,4], [2,2])).to eq(3)
    end

    it '#walls' do
      expect(walls(matrix)).to match_array([[1,0], [1,1], [1,3]])
    end
  end

  context 'big' do
    let(:matrix) do
      [[false, false, false, false, false, false],
       [false, false, false, false, false, false],
       [false, false, false, false, false, false],
       [false, false, false, false, false, false],
       [false, false, false, false, false, false],
       [false, false, false, false, false, false]]
    end

    it '#step' do
      solution = step(path: [start(matrix)], matrix: matrix, goal: goal(matrix))
      expect(solution.size).to eq(11)
    end
  end

  context 'big and tricky' do
    let(:matrix) do
      [[false, false, false, false, true , false, true , false],
       [false, false, false, false, true , false, true , false],
       [false, true , true , true , false, false, true , false],
       [false, true , false, false, false, false, true , false],
       [false, false, false, false, false, true , true , false],
       [false, true , false, false, true , false, true , false],
       [false, false, true , false, false, false, true , false],
       [false, false, true , false, false, false, false, false]]
    end

    it '#step' do
      solution = step(path: [start(matrix)], matrix: matrix, goal: goal(matrix))
      expect(solution.size).to eq(21)
    end
  end

  context 'different direction' do
    let(:matrix) do
      [[false, false, false, false, false, false, false, false, false, false],
       [false, true , false, false, false, false, false, true , true , false],
       [true , false, false, true , true , false, false, true , true , false],
       [false, false, true , false, true , false, false, true , true , false],
       [true , true , true , false, true , false, false, true , true , false],
       [false, false, false, false, true , false, false, false, false, false],
       [false, true , true , true , true , false, false, false, true , false],
       [false, true , false, false, false, false, true , false, false, false],
       [false, true , false, true , true , true , true , false, true , false],
       [false, false, false, true , false, false, false, false, false, false]]
     end

    it '#step' do
      solution = step(path: [[7,7]], matrix: matrix, goal: [3,3])
      expect(solution.size).to eq(21)
    end
  end

  context 'big maze' do
    let(:matrix) do
      [[false, false, false, false, true , true , false, false, true , false],
       [false, true , true , true , true , true , false, true , false, false],
       [false, true , false, false, false, false, false, true , true , false],
       [false, true , false, true , false, true , true , true , true , false],
       [false, true , false, true , false, false, false, false, false, false],
       [false, true , false, false, true , true , true , true , true , true ],
       [false, true , true , false, true , false, false, false, false, false],
       [false, true , true , false, true , false, true , true , true , false],
       [false, false, true , false, true , false, false, false, true , false],
       [true , false, true , false, false, false, true , false, true , false],
       [true , false, true , true , true , false, true , false, false, false],
       [true , false, true , false, true , false, true , false, true , false],
       [false, false, false, false, true , false, true , false, true , false],
       [false, true , false, false, false, false, true , false, true , false],
       [false, true , false, true , false, true , true , false, false, false],
       [false, true , false, false, false, false, false, false, true , false]]
    end

    it '#step' do
      solution = step(path: [start(matrix)], matrix: matrix, goal: goal(matrix))
      expect(solution.size).to eq(37)
    end
  end
end
