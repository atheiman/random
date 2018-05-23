def make_change(amount, coins = [20, 10, 5, 1, 0.25, 0.1, 0.05, 0.01])
  hsh = {}
  coins.sort.reverse.each do |coin|
    coin = coin.to_f
    hsh[coin] = (amount / coin).to_i
    amount = (amount - coin * hsh[coin]).round(2)
    # an alternative is to use modulo operator here, I found no speed difference
    #amount = (amount % coin).round(2)
  end
  hsh.select { |_coin, count| count > 0 }
end

solutions = {
  7.67 => { 5.0 => 1, 1.0 => 2, 0.25 => 2, 0.1 => 1, 0.05 => 1, 0.01 => 2 },
  8 => { 5.0 => 1, 1.0 => 3 },
  0.09 => { 0.05 => 1, 0.01 => 4 },
  89.64 => { 20.0 => 4, 5.0 => 1, 1.0 => 4, 0.25 => 2, 0.1 => 1, 0.01 => 4 }
}

require 'rspec'

describe ::File.basename(__FILE__, '.rb') do
  it 'makes change with modulo' do
    solutions.each do |amount, output|
      expect(make_change(amount)).to eq(output)
    end
  end
end
