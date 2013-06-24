require 'set'

# types of squares
# * - unexplored
# m - unrevealed mine
# M - revealed mine
# F - flagged
# _ - interior
# 1 - fringe square

class Minesweeper
  attr_accessor :board, :game_over

  def initialize(size=9, mines=10)
    @game_over = 0
    @board = Array.new

    @mine_locs = rand_n(mines, size**2)
    @mine_locs.map! do |mine_loc|
      [mine_loc / size, mine_loc % size]
    end

    size.times do |i|
      @board << []
      size.times do |j|
        if @mine_locs.include?([i,j])
          symbol = :m
        else
          symbol = :*
        end

        @board.last << symbol
      end
    end
  end

  def play
    until done?
      puts "Do you want to (1) reveal or (2) flag?"
      move = gets.to_i
      puts "Which square? (ex: '1,1')"
      x,y = gets.split(",").map{|coord| coord.to_i}

      case move
      when 1
        reveal(x,y)
      when 2
        flag(x,y)
      end
    end
  end

  def flag(x,y)
  end

  def reveal(x,y)
  end

  def print_board
    @board.each do |row|
      row.each do |square|
        if done? || square != :m
          disp_sq = square
        elsif square == :m
          disp_sq = :*
        end
        print disp_sq
      end
      print "\n"
    end
  end

  def done?
    0
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
