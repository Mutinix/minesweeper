require 'set'

class Minesweeper
  attr_accessor :board

  def initialize(size=9, mines=10)
    @board = Array.new

    size.times do |i|
      @board << []
      size.times do |j|
        @board.last << :*
      end
    end
  end

  def print_board
    @board.each do |row|
      row.each do |square|
        print square
      end
      print "\n"
    end
  end

  private

  def rand_n(n, max)
    randoms = Set.new
    loop do
      randoms << rand(max)
      return randoms.to_a if randoms.size >= n
    end
  end
end

Minesweeper.new.print_board