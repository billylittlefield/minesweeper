require_relative 'tile'
require 'yaml'

class Board

  def initialize
    @grid = Array.new(9) {Array.new(9)}
  end

  def play
    populate_grid
    until lost? || won?
      system 'clear'
      render
      pos = prompt_location
      next if pos.empty?
      target = self[pos]
      prompt_flag ? target.flag : target.reveal
    end
    lost? ? puts("BOOM") : puts("You got lucky.")
  end

  def [](pos)
    grid[pos[0]][pos[1]]
  end

  def []=(pos, mark)
    grid[pos[0]][pos[1]] = mark
  end

  private

  attr_reader :grid

  def populate_grid
    grid.each_with_index do |row, row_idx|
      row.each_with_index do |cell, col_idx|
        self[[row_idx, col_idx]] = Tile.new(self, [row_idx, col_idx])
      end
    end
    add_bombs
  end

  def lost?
    grid.flatten.any? {|tile| tile.bombed && tile.revealed }
  end

  def won?
    return false if lost?
    grid.flatten.all? { |tile| tile.bombed || tile.revealed }
  end

  def add_bombs
    9.times do
      position = grid.sample.sample
       until !position.bombed
        position = grid.sample.sample
      end
      position.bombed = true
    end
    nil
  end

  def render
    puts "Welcome to Minesweeper. Prepare to do a good job."
    puts "  #{(0..8).to_a.join(' ')}"
    grid.each_with_index do |row, row_idx|
      print "#{row_idx} "
      row.each do |cell|
        print  "#{cell.display} "
      end
      print "\n"
    end
    nil
  end

  def prompt_location
    puts "Please choose a location"
    puts "If you'd like to save, enter 'save'"
    input = gets.chomp
    if input == 'save'
      puts "Please enter a filename."
      filename = gets.chomp
      File.write(filename, self.to_yaml)
      Kernel.exit
    else
      pos.split(',').map {|num| num.to_i}
    end
  end

  def prompt_flag
    puts "Do you want to flag? (enter 'F') Or unflag? (enter 'U') Or none (hit enter)"
    value = gets.chomp.downcase
    if value == 'f' || value == 'u'
      return true
    end
    false
  end
end

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  board.play
end
