require_relative 'tile'
require 'yaml'


class Board

attr_accessor :cursor

  def initialize
    @grid = Array.new(9) {Array.new(9)}
    @cursor = [0,0]
  end

  def [](pos)
    grid[pos[0]][pos[1]]
  end

  def []=(pos, mark)
    grid[pos[0]][pos[1]] = mark
  end

  def populate_grid
    grid.each_with_index do |row, row_idx|
      row.each_index do |col_idx|
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

  def status
    grid.flatten.select { |tile| !tile.revealed }.map { |tile| tile.position}
  end

  def render
    system 'clear'
    puts "Welcome to Minesweeper. Prepare to do a good job."
    puts "  #{(0..8).to_a.join(' ')}"
    grid.each_with_index do |row, row_idx|
      print "#{row_idx} "
      row.each do |tile|
        if cursor == tile.position
          print "#{tile.display.colorize(:white).colorize(:background => :black)} "
        else
          print  "#{tile.display} "
        end
      end
      print "\n"
    end
  end

  private

  attr_reader :grid

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

end
