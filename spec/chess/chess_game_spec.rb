require 'rails_helper'
require 'chess/chess'

RSpec.describe Chess::Game do
  let(:valid_game) { create(:game) }
  let(:white) { valid_game.white }
  let(:black) { valid_game.black }
  let(:piece_classes) { ["Rook", "Knight", "Bishop", "King", "Queen", "Pawn"] }

  describe '.place_pieces' do
    it 'assigns positions to each Piece in given pieces array' do

      white_pieces = Chess::Game.place_pieces(white.pieces, :white)
      expect(white_pieces.length).to eq(16)
      white_pieces.each do |piece|
        expect(piece.position).to_not eq("unplaced")
        expect(piece_classes).to include(piece.class.to_s)
      end

      black_pieces = Chess::Game.place_pieces(black.pieces, :black)
      expect(black_pieces.length).to eq(16)
      black_pieces.each do |piece|
        expect(piece.position).to_not eq("unplaced")
        expect(piece_classes).to include(piece.class.to_s)
      end
    end
  end

  describe '.fill_board' do
    before do
      Chess::Game.place_pieces(valid_game.white.pieces, :white).each(&:save!)
      Chess::Game.place_pieces(valid_game.black.pieces, :black).each(&:save!)
    end

    it 'generates a hash chess board on game' do
      board = Chess::Game.fill_board(valid_game).board
      expect(board).to be_a(Hash)
      expect(board.length).to eq(64)
      expect(board.keys).to include("a1".to_sym)
      expect(board.keys).to include("h8".to_sym)
    end

    it 'adds pieces to game board' do
      board = Chess::Game.fill_board(valid_game).board
      expect(board[:a8]).to be_a(Rook)
      expect(board[:b2]).to be_a(Pawn)
      expect(board[:g8]).to be_a(Knight)
    end

  end

end