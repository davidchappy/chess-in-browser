module PieceMethods
  extend ActiveSupport::Concern

  def rooks(parent)
    get_pieces(parent, "Rook")
  end

  def knights(parent)
    get_pieces(parent, "Knight")
  end

  def bishops(parent)
    get_pieces(parent, "Bishop")
  end

  def kings(parent)
    get_pieces(parent, "King")
  end

  def queens(parent)
    get_pieces(parent, "Queen")
  end

  def pawns(parent)
    get_pieces(parent, "Pawn")
  end

  private 

    def get_pieces(parent, type)
      parent.pieces.where(type: type)
    end

end