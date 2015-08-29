require 'colorize'

class Tile

  MOVE = [[0,1],[1,0],[-1,0],[0,-1],[1,1],[-1,-1],[-1,1],[1,-1]]

  attr_reader :flagged, :revealed
  attr_accessor :bombed

  def initialize(board, position)
    @board = board
    @position = position
    @revealed = false
    @bombed = false
    @flagged = false
  end

  def display
    return "F".colorize(:red) if flagged
    return "_".colorize(:light_white) if revealed && neighbor_bomb_count == 0
    return colorize_numbers if revealed
    return "*".colorize(:white)
  end

  def flag
    if flagged
      @flagged = false
    else
      @flagged = true
    end
  end

  def reveal
    return if revealed || flagged
    @revealed = true
    return if bombed
    return if neighbor_bomb_count > 0
    neighbors.each(&:reveal)
  end

  private

  attr_reader :board, :position

  def colorize_numbers
    case num = neighbor_bomb_count
    when 3
      return num.to_s.colorize(:magenta)
    when 2
      return num.to_s.colorize(:yellow)
    when 1
      return num.to_s.colorize(:light_green)
    else
      return num.to_s.colorize(:light_black)
    end
  end

  def neighbors
    neighbors_pos = []
    MOVE.each do |move|
      possible_neighbor = [move[0] + position[0] , move[1]+position[1]]
      if possible_neighbor.all? { |cord| cord.between?(0,8) }
        neighbors_pos << possible_neighbor
      end
    end
    neighbors = neighbors_pos.map {|pos| board[pos]}
  end

  def neighbor_bomb_count
    neighbors.count { |tile| tile.bombed }
  end

end
