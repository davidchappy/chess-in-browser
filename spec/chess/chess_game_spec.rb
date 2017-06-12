require 'rails_helper'
require 'chess/chess'

RSpec.describe Chess::Game do
  let(:valid_game) { create(:game) }

  describe '.start' do
    before do 
      Chess::Game.start(valid_game)
    end

    it 'assigns positions to each game piece' do
      piece_classes = ["Rook", "Knight", "Bishop", "King", "Queen", "Pawn"]

      white_pieces = valid_game.white.pieces
      expect(white_pieces.length).to eq(16)
      white_pieces.each do |piece|
        expect(piece.position).to_not eq("unplaced")
        expect(piece_classes).to include(piece.class.to_s)
      end

      black_pieces = valid_game.black.pieces
      expect(black_pieces.length).to eq(16)
      black_pieces.each do |piece|
        expect(piece.position).to_not eq("unplaced")
        expect(piece_classes).to include(piece.class.to_s)
      end
    end

  end

end