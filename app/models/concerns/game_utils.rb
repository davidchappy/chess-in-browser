module GameUtils
  extend ActiveSupport::Concern

  def current_player
    self.white.is_playing ? self.white : self.black
  end

  def current_pieces
    self.current_player == self.white ? self.white_pieces : self.black_pieces
  end

  def other_pieces
    self.current_player == self.white ? self.black_pieces : self.white_pieces
  end

  def current_color
    self.current_player == self.white ? 'white' : 'black'
  end

  def other_color
    self.current_player == self.white ? 'black' : 'white'
  end

  def white_pieces
    self.pieces.where(color: "white")
  end

  def black_pieces
    self.pieces.where(color: "black")
  end

  def white_king
    self.pieces.select{|piece| piece if piece.name == 'white-k'}.first
  end

  def black_king
    self.pieces.select{|piece| piece if piece.name == 'black-k'}.first
  end

  def find_on_board(coordinate)
    if coordinate && coordinate != ""
      target = self.board[coordinate.to_sym]
    end
    if target == "" || target.nil?
      return ""
    else 
      return self.pieces.find(target.to_i)
    end
  end

  def position_by_id(piece_id)
    self.board.select{|t, val| val.to_i == piece_id}.keys[0].to_s
  end

  def find_piece_by_name(name)
    self.pieces.select{ |piece| piece if piece.name == name}.first
  end
end