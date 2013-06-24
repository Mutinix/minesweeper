require 'set'
require 'yaml'

# types of squares
# * - unexplored
# m - unrevealed mine
# M - revealed mine
# F - flagged correctly
# f - flagged incorrectly
# _ - interior
# 1 - fringe square

class Minesweeper
  attr_accessor :board, :game_over

  @@adjacent = [[0,-1], [-1,-1], [-1,0], [-1,1],
                [0,1], [1,1], [1,0], [1,-1]]

  def initialize(size=9, mines=10)
    @game_over = 0
    @board = Array.new
    @size = size

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

  def write_to_file
    puts "Enter filename"
    filename = gets.chomp
    file = File.new(filename, "w")
    file.write(@board.to_yaml)
    file.close
  end

  def load_from_file
    puts "Enter save file name:"
    filename = gets.chomp
    file = File.open(filename, "r")
    @board = YAML::load(file)
    file.close
  end

  def play
    until done?
      print_board
      puts "Do you want to (1) reveal, (2) flag, (3) unflag, (4) save your game, (5) load your game, or (6) quit?"
      move = gets.to_i
      unless move > 3
        puts "Which square? (ex: '1,1')"
        x,y = gets.split(",").map{|coord| coord.to_i}
      end

      case move
      when 1
        reveal(x,y)
      when 2
        flag(x,y)
      when 3
        unflag(x,y)
      when 4
        write_to_file
      when 5
        load_from_file
      when 6
        return
      end
    end

    if @game_over == 1
      puts "You win!"
    else
      puts "You lose!"
    end

    print_board
  end

  def flag(x,y)
    case @board[x][y]
    when :m # correctly flagged
      @board[x][y] = :F
    when :* # incorrectly flagged
      @board[x][y] = :f
    else
      puts "You can't flag this square"
    end
  end

  def unflag(x,y)
    # correctly flagged
    if @board[x][y] == :F
      @board[x][y] = :m
    elsif @board[x][y] == :f
      @board[x][y] = :*
    else
      puts "Not a flagged square"
    end
  end

  def reveal(x, y, first=true)
    #if mine then end
    if @board[x][y] == :m
      @game_over = -1 if first
      return
    else # recursively reveal that square and all adjacent ones
      adj_mine_locs = adjacent_mines(x,y)
      if adj_mine_locs.empty?
        @board[x][y] = :_
        @@adjacent.each do |i, j|
          # only recurse on unexplored squares
          if valid_square?(x+i,y+j) && @board[x+i][y+j] == :*
            reveal(x+i, y+j, false)
          end
        end
      else
        @board[x][y] = adj_mine_locs.length
      end
    end

  end

  def adjacent_mines(x,y)
    @@adjacent.select do |i,j|
      valid_square?(x+i,y+j) &&
      @board[x+i][y+j] == :m
    end
  end

  def valid_square?(x,y)
    ![x,y].collect do |coord|
      (0...@size).member?(coord)
    end.include?(false)
  end

  def print_board
    @board.each do |row|
      row.each do |square|
        if done? || ![:f, :m].include?(square)
          disp_sq = square
        # always show the same symbol for flagged squares
        elsif square == :f
          disp_sq = :F
        elsif square == :m
          disp_sq = :*
        end
        print "#{disp_sq} "
      end
      print "\n"
    end
  end

  def done?
    if @game_over != 0
      true
    elsif @board.flatten.any? { |square| [:m, :f].include?(square)}
      # there are remaining, unrevealed mines
      false
    else # game is over
      if @board.flatten.include?(:M) # player loses
        @game_over = -1
      else # player wins
        @game_over = 1
      end

      true
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

if __FILE__ == $PROGRAM_NAME
  Minesweeper.new.play
end