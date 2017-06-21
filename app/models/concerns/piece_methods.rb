module PieceMethods
  extend ActiveSupport::Concern

  def rooks(collection)
    get_pieces(collection, "Rook")
  end

  def knights(collection)
    get_pieces(collection, "Knight")
  end

  def bishops(collection)
    get_pieces(collection, "Bishop")
  end

  def kings(collection)
    get_pieces(collection, "King")
  end

  def queens(collection)
    get_pieces(collection, "Queen")
  end

  def pawns(collection)
    get_pieces(collection, "Pawn")
  end

  private 

    def get_pieces(collection, type)
      collection.where(type: type)
    end

end