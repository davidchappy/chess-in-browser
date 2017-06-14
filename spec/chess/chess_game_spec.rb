require 'rails_helper'
require 'chess/chess'

RSpec.describe Chess::Game do
  let!(:valid_game) { create(:game) }
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

end