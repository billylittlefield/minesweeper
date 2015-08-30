require_relative 'board'
require 'io/console'

class Minesweeper

  attr_reader :board

  def initialize(board)
    @board = board
    board.populate_grid
    p $stdin.class
  end

  def play
    p $stdin.class
    until board.lost? || board.won?
      board.render
      pos = prompt
      until pos == 'REVEAL' || pos == "FLAG"
        pos = prompt
      end
    end
    board.lost? ? puts("BOOM".colorize(:red)) : puts("You got lucky.")
  end

  def prompt
    puts "\nUse arrow keys to select a location. Hit enter to reveal, or 'F' to toggle flag"
    puts "If you'd like to save, enter 'save'"
    input = show_input
    cursor = board.cursor
    if input == 'SAVE'
      puts "Please enter a filename."
      filename = gets.chomp
      File.write(filename, self.to_yaml)
      Kernel.exit
    elsif input == 'UP ARROW'
      board.cursor = [cursor[0] - 1, cursor[1]] if cursor[0] > 0
      board.render
      'NO RETURN'
    elsif input == 'DOWN ARROW'
      board.cursor = [cursor[0] + 1, cursor[1]] if cursor[0] < 8
      board.render
      'NO RETURN'
    elsif input == 'RIGHT ARROW'
      board.cursor = [cursor[0], cursor[1] + 1] if cursor[1] < 8
      board.render
      'NO RETURN'
    elsif input == 'LEFT ARROW'
      board.cursor = [cursor[0], cursor[1] - 1] if cursor[1] > 0
      board.render
      'NO RETURN'
    elsif input == 'REVEAL'
      board[cursor].reveal
      board.render
      'RETURN'
    elsif input == 'FLAG'
      board[cursor].flag
      board.render
      'FLAG'
    end
  end

  # def prompt_flag
  #   puts "Enter 'F' to flag, 'U' to unflag, or just hit enter to reveal"
  #   value = gets.chomp.downcase
  #   if value == 'f' || value == 'u'
  #     return true
  #   end
  #   false
  # end

  def read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end

  def show_input
    c = read_char

    case c
    when "\r"
      return "REVEAL"
    when "\e[A"
      return "UP ARROW"
    when "\e[B"
      return "DOWN ARROW"
    when "\e[C"
      return "RIGHT ARROW"
    when "\e[D"
      return "LEFT ARROW"
    when "\u0003"
      exit
      return "CONTROL-C"
    when "s"
      return "SAVE"
    when "f" || "F" || "u" || "U"
      return "FLAG"
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  game = ARGV[0] ? YAML.load_file(ARGV.shift) : Minesweeper.new(board)
  game.play
end
