require_relative 'board'


class Minesweeper

  attr_reader :board

  def initialize(board)
    @board = board
    board.populate_grid
  end

  def play
    until board.lost? || board.won?
      system 'clear'
      board.render
      pos = prompt_location
      next if pos.empty?
      target = board[pos]
      prompt_flag ? target.flag : target.reveal
    end
    board.lost? ? puts("BOOM".colorize(:red)) : puts("You got lucky.")
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
      input.split(',').map {|num| num.to_i}
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
  game = ARGV[0] ? YAML.load_file(ARGV.shift) : Minesweeper.new(board)
  game.play
end
