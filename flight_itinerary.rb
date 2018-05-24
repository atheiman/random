# This problem was asked by Facebook.

# Given an unordered list of flights taken by someone, each represented as
# (origin, destination) pairs, and a starting airport, compute the person's
# itinerary. If no such itinerary exists, return null. If there are multiple
# possible itineraries, return the lexicographically smallest one. All flights
# must be used in the itinerary.

# For example, given the list of flights [('SFO', 'HKO'), ('YYZ', 'SFO'),
# ('YUL', 'YYZ'), ('HKO', 'ORD')] and starting airport 'YUL', you should return
# the list ['YUL', 'YYZ', 'SFO', 'HKO', 'ORD'].

# Given the list of flights [('SFO', 'COM'), ('COM', 'YYZ')] and starting
# airport 'COM', you should return null.

# Given the list of flights [('A', 'B'), ('A', 'C'), ('B', 'C'), ('C', 'A')] and
# starting airport 'A', you should return the list ['A', 'B', 'C', 'A', 'C']
# even though ['A', 'C', 'A', 'B', 'C'] is also a valid itinerary. However, the
# first one is lexicographically smaller.

def flight_itinerary(start, remaining_flights, itinerary = [])
  remaining_flights.each_with_index do |flight, idx|
    # if flight is not from current location, move on
    next unless flight.first == start

    if remaining_flights.size == 1
      # only one flight left and it solves the puzzle
      solution_flights = itinerary << flight
      solution = []
      solution_flights.each { |f| solution << f.first }
      solution << solution_flights.last.last
      if @solution
        # store the lexicographically smaller solution
        break if solution.join > @solution.join
      end
      @solution = solution
    else
      current_itinerary = itinerary.clone
      current_remaining_flights = remaining_flights.clone
      current_itinerary << current_remaining_flights.delete_at(idx)
      flight_itinerary(
        current_itinerary.last.last,
        current_remaining_flights,
        current_itinerary
      )
    end
  end
  @solution
end

require 'rspec'

describe __FILE__ do
  it 'returns the lexicographically smallest itinerary from an unordered list of flights' do
    expect(flight_itinerary(
      'YUL',
      [['SFO', 'HKO'], ['YYZ', 'SFO'], ['YUL', 'YYZ'], ['HKO', 'ORD']]
    )).to eq(
      ['YUL', 'YYZ', 'SFO', 'HKO', 'ORD']
    )
    expect(flight_itinerary(
      'A',
      [['A', 'B'], ['A', 'C'], ['B', 'C'], ['C', 'A']]
    )).to eq(
      ['A', 'B', 'C', 'A', 'C']
    )
  end

  it 'returns nil if no solution exists' do
    expect(flight_itinerary('COM', [['SFO', 'COM'], ['COM', 'YYZ']])).to be_nil
  end
end
