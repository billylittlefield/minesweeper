class Tile

  MOVE = [[0,1],[1,0],[-1,0],[0,-1],[1,1],[-1,-1],[-1,1],[1,-1]]

  attr_accessor :reveal_status, :bomb_status
  attr_reader :board, :disply, :flagged, :position

  def initialize(board, position, bomb_status = false, reveal_status = false)
    @board = board
    @reveal_status = reveal_status
    @bomb_status = bomb_status
    @flagged = false
    @position = position
    @disply = '*'
  end

  def deal_with_flag(flag)
    if flag
      @flagged = true
      @disply = "F"
    else
      @flagged = false
      @disply = '*'
    end
  end

  def reveal(flag)
    if !(flag.nil?)
      deal_with_flag(flag)
    elsif bomb_status
      print "BOOM"
      board.game_over = true
    elsif board.grid.flatten.all? { |tile| tile.reveal_status || tile.flagged } &&
        board.num_flag < 10
      puts "Congrats!"
      board.game_over = true
    else
      reveal!
    end
  end

  def reveal!
    return if reveal_status == true
    @reveal_status = true
    if neighbor_bomb_count > 0
      @disply = neighbor_bomb_count.to_s
      # print position
      nil
    end
    @disply = '_'
    neighbors.each { |neighbor| neighbor.reveal! }
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
    neighbors.count { |tile| tile.bomb_status }
  end



end
