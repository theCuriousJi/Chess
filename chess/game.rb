require_relative "board"

class Game

  attr_reader :board

  def initialize
    @board = Board.new
  end

  #gets input from user and asserts that coord is on the board
  def get_input
    begin
      puts "What's the location of the piece you want to move"
      from_pos = gets.chomp.split(" ").map(&:to_i)
      assert_input_valid?(from_pos)
      puts "What's the location you want to move the piece to?"
      to_pos = gets.chomp.split(" ").map(&:to_i)
      assert_input_valid?(to_pos)
    rescue InvalidInputError => e
      puts e.message
      retry
    end

    [from_pos, to_pos]
  end

  # asserts valid input
  def assert_input_valid?(piece_pos)
    unless piece_pos.all? { |coord| coord.between?(0,7) }
      raise InvalidInputError.new "That is not a valid position on the board"
    end
  end

  def play
    puts "Welcome! You're playing CHHHHHHEEEESSSS!!"
    puts "Enter your input like this '1 2'"
    board.display

    loop do

      begin
        puts "It's White's turn"
        from, to = get_input
        if board[from].color == :B
          raise IllegalMoveError.new "It is White's turn you cheater."
        end
        board.move(from, to)
        board.display
      rescue IllegalMoveError => e
        puts e.message
        retry
      end

      begin
        puts "It's Black's turn"
        to, from = get_input
        if board[from].color == :W
          raise IllegalMoveError.new "It is Black's turn you cheater."
        end
        board.move(from, to)
        board.display
      rescue IllegalMoveError => e
        e.message
        retry
      end
    end
  end
end


class InvalidInputError < ArgumentError
end

g = Game.new
p g.play
