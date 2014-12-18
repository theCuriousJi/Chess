class Piece
  ORTHO = [
    [0,1],
    [1,0],
    [0,-1],
    [-1,0]
  ]

  DIAGS = [
    [1,1],
    [1,-1],
    [-1,-1],
    [-1,1]
  ]

  SYMBOLS = {

  }

  attr_reader :pos, :color, :board

  def initialize(pos, board, color)
    @pos = pos
    @board = board
    @color = color
  end

  def legal_move?(pos)
    return false unless pos.all? { |coord| coord.between?(0, 7) }
    return true if board[pos] == nil
    return false if board[pos].color == color
    true
  end

  def opposite_color
    if color == :B
      return :W
    else
      return :B
    end
  end
end
