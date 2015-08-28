require_relative 'tile'

class Board
  attr_accessor :game_over, :num_flag
  attr_reader :grid

  def initialize
    @grid = Array.new(9) {Array.new(9)}
    @game_over = false
    @num_flag = 0
  end



  def populate_grid
    grid.each_with_index do |row, row_idx|
      row.each_with_index do |cell, col_idx|
        self[[row_idx, col_idx]] = Tile.new(self, [row_idx, col_idx])
      end
    end
    add_bombs
  end

  def [](pos)
    grid[pos[0]][pos[1]]
  end

  def []=(pos, mark)
    grid[pos[0]][pos[1]] = mark
  end

  def add_bombs
    9.times do
      position = grid.sample.sample
       until !position.bomb_status
        position = grid.sample.sample
      end
      # p position.bomb_status
      position.bomb_status = true
      # p position.bomb_status
    end
    nil
  end

  def render
    print "  #{(0..8).to_a.join(' ')}\n"
    grid.each_with_index do |row, row_idx|
      print "#{row_idx} "
      row.each do |cell|
        print  "#{cell.disply} "
      end
      print "\n"
    end
    nil
  end

  def play
    populate_grid
    until game_over
      system 'clear'
      render
      pos = prompt_location
      flag = prompt_flag
      self[pos].reveal(flag)
    end
  end

  def prompt_location
    puts "Please choose a location"
    pos = gets.chomp.split(',').map {|num| num.to_i}
  end

  def prompt_flag
    puts "Do you want to flag? (enter 'F') Or unflag? (enter 'U') Or none (hit enter)"
    value = gets.chomp.downcase
    if value == 'f'
      @num_flag += 1
      return true
    elsif value == 'u'
      @num_flag -= 1
      return false
    else
      return nil
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  board.play
end
