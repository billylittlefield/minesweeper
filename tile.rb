class Tile

  MOVE = [[0,1],[1,0],[-1,0],[0,-1],[1,1],[-1,-1],[-1,1],[1,-1]]

  attr_accessor :reveal_status, :bomb_status, :disply

  def initialize(board, position, bomb_status = false, reveal_status = false)
    @board = board
    @reveal_status = reveal_status
    @bomb_status = bomb_status
    @flagged = false
    @position = position
    @disply = '*'
  end

  def reveal(flag)
    if !(flag.nil?)
      flagged = true if flag
      flagged = false if flag == false
    elsif bomb_status
      print "BOOM"
      board.game_over = true
    elsif board.flatten.all? {|tile| tile.reveal_status || tile.flagged} &&
        board.num_flag < 10
      puts "Congrats!"
      board.game_over = true
    else
      reveal!
    end
  end

  def reveal!
    if neighbor_bomb_count > 0
      reveal_status = true
      disply = neighbor_bomb_count.to_s
      return
    end
    disply = '_'
    neighbors.each {|neighbor| neighbor.reveal!}
  end

  def neighbors
    neighbors_pos = []
    MOVE.each do |move|
      possible_neigbhor = [move[0] + position[0] , move[1]+position[1]]
      if possible_neigbhor.all? { |cord| cord.between?(0,8) }
        neighbors_pos << possible_neigbhor
      end
    end
    neighbors = neighbors_pos.map {|pos| board[pos]}
  end

  def neighbor_bomb_count
    neighbors.count {|tile| tile.bomb_status}
  end



end
