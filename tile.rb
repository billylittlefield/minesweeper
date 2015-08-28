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
    return "F" if flagged
    return "_" if revealed && neighbor_bomb_count == 0
    return neighbor_bomb_count.to_s if revealed
    return "*"
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
