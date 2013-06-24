require 'set'

class Minesweeper
  attr_accessor :board

  def initialize(size=9, mines=10)
    @board = Array.new
    mine_locs = rand_n(mines, size**2)

    size.times do |i|
      @board << []
      size.times do |j|
        if mine_locs.include?((i+1)*size + (j+1))
          symbol = :M
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

  def print_board
    @board.each do |row|
      row.each do |square|
        if done? || square != :M
          disp_sq = square
        else square == :M
          disp_sq = :*
        end
        print disp_sq
      end
      print "\n"
    end
  end

  def done?
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
