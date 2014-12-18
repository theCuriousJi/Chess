require_relative 'pieces'

class Board
  UNIQUE = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

  attr_reader :grid

  # Initializes baord with a default value of populating the board.
  # If on initialize, false is passed in, the board is blank
  def initialize(pop = true)
    @grid = Array.new(8) { Array.new(8) }
    generate_board if pop
    @killed_pieces = []
  end

  #generates and populates board
  def generate_board
    [0, 7].each do |row|
      0.upto(7) do |col|
        row == 0 ? color = :B : color = :W
        pos = row, col
        self[pos] = UNIQUE[col].new(pos, self, color)
      end
    end

    [1,6].each do |row|
      0.upto(7) do |col|
        row == 1 ? color = :B : color = :W
        pos = row, col
        self[pos] = Pawn.new(pos, self, color)
      end
    end
  end

  #accesses board, given a position
  def [](pos)
    row, col = pos
    grid[row][col]
  end

  #assigns a value to a given position on the board
  def []=(pos, value)
    row, col = pos
    grid[row][col] = value
  end

  #displays the board and pieces
  def display
    print " "
    (0..7).each do |num| print "  #{num}" end
    puts ""
    n = 0

    grid.each do |row|
      print "#{n} "
      row.each do |piece|
        if piece.nil?
          print " _ "
        else
          print " #{piece.inspect} "
        end
      end
      n += 1
      puts "\n"
    end
  end

  #checks if a color's king is in danger of being killed
  def in_check?(color)
    opposite_team = grid.flatten.compact.select do |piece|
      piece.color != color
    end
    king_pos = find_king(color)
    opposite_team.each do |piece|
      return true if piece.move_dirs.include?(king_pos)
    end
    false
  end

  #finds a king's pos by the color given
  def find_king(color)
    king = grid.flatten.compact.select do |piece|
      piece.color == color && piece.class == King
    end
    king.first.pos
  end

  # raises an error if you input invalid positions
  def check_legal_move?(start, end_pos)
    if self[start] == nil
      raise IllegalMoveError.new "No piece at that start position"
    elsif !self[start].move_dirs.include?(end_pos)
      raise IllegalMoveError.new  "Can't move to that position"
    end
  end

  # creates a completely new board with all duped pieces
  # and performs the move. After, it checks if the moved piece's
  # king is in check.
  def move(start, end_pos)
    new_board = deep_dup
    new_board.move!(start, end_pos)
    if new_board.in_check?(new_board[end_pos].color)
      raise IllegalMoveError.new "Move will put you into check"
    else
      move!(start, end_pos)
    end
  end

  def move!(start, end_pos)
    check_legal_move?(start, end_pos)
    self[end_pos] = self[start]
    self[start] = nil
  end

  def deep_dup
    new_board = Board.new(false)

    grid.flatten.compact.each do |piece|
      new_board[piece.pos.dup] =
            piece.class.new(piece.pos.dup, new_board, piece.color)
    end

    new_board
  end
end

class IllegalMoveError < ArgumentError
end
