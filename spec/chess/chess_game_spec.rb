require 'rails_helper'
require 'chess/chess'

RSpec.describe Chess::Game do
  let(:valid_game) { create(:game) }
  let(:white) { valid_game.white }
  let(:black) { valid_game.black }
  let(:piece_classes) { ["Rook", "Knight", "Bishop", "King", "Queen", "Pawn"] }

  describe '.position_pieces' do
    it 'assigns positions to each Piece in given pieces array' do
      white_pieces = Chess::Game.position_pieces(white.pieces)
      expect(white_pieces.length).to eq(16)
      white_pieces.each do |piece|
        expect(piece.position).to_not eq("unplaced")
        expect(piece_classes).to include(piece.class.to_s)
      end

      black_pieces = Chess::Game.position_pieces(black.pieces)
      expect(black_pieces.length).to eq(16)
      black_pieces.each do |piece|
        expect(piece.position).to_not eq("unplaced")
        expect(piece_classes).to include(piece.class.to_s)
      end
    end
  end

  describe '.init_board' do
    before do
      Chess::Game.position_pieces(valid_game.white.pieces).each(&:save!)
      Chess::Game.position_pieces(valid_game.black.pieces).each(&:save!)
    end

    it 'generates a hash chess board on game' do
      board = Chess::Game.init_board(valid_game).board
      expect(board).to be_a(Hash)
      expect(board.length).to eq(64)
      expect(board.keys).to include("a1".to_sym)
      expect(board.keys).to include("h8".to_sym)
    end

    it 'adds pieces to game board' do
      board = Chess::Game.init_board(valid_game).board
      expect(board.keys).to include(:a1)
      expect(board.keys).to include(:h8)
    end
  end

  describe '.get_moves' do
    # fills each player's piece with legal moves
    
    # iterate through each player's piece
    # loop through each tile of game.board
    # check if that tile is a possible move for that piece
    
    it "" do
    end
    
    
  end

end




