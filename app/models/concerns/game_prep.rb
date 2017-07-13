module GamePrep
  extend ActiveSupport::Concern

  def generate_pieces
    piece_definitions = Chess::Game.describe_pieces
    piece_definitions.each { |definition| self.pieces.create(definition) }
  end

  def generate_board
    board = Chess::Game.describe_board
    add_pieces_to_board(board)
  end

  private 

    def add_pieces_to_board(board)
      self.board = board
      self.pieces.each do |piece|
        position = piece.position.to_sym
        if self.board.keys.include?(position) 
          self.board[position] = piece.id
        end
      end
      self.save!
    end

end