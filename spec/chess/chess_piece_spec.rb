require 'rails_helper'
require 'chess/chess'

RSpec.describe Chess::Piece do
  let!(:valid_game) { create(:game) }
  let(:pawn)   { valid_game.white.pieces.where(name: "white-p1").take }
  let(:rook)   { valid_game.white.pieces.where(name: "white-r1").take }
  let(:knight) { valid_game.white.pieces.where(name: "white-n1").take }
  let(:bishop) { valid_game.white.pieces.where(name: "white-b1").take }
  let(:king)   { valid_game.white.pieces.where(name: "white-k").take }
  let(:queen)  { valid_game.white.pieces.where(name: "white-q").take }

  describe '.process_move' do
    it 'returns hash of move with flags/empty string as values' do
      expect(described_class.process_move("a3", valid_game.board, pawn)).to eq("a3"=>"")
    end
  end

  describe '#wrapped?' do
    let(:next_tile) { "a3" }
    let(:last_tile) { "h3" }

    it "prevents wrapping horizontally around board" do
      expect(described_class.new.wrapped?(next_tile, last_tile)).to eq(true)
    end

    it "prevents wrapping vertically around board" do
      next_tile = "c1"
      last_tile = "c8"
      expect(described_class.new.wrapped?(next_tile, last_tile)).to eq(true)
    end

    it "allows normal movement" do
      next_tile = "b4"
      last_tile = "a3"
      expect(described_class.new.wrapped?(next_tile, last_tile)).to eq(false)

      next_tile = "a4"
      expect(described_class.new.wrapped?(next_tile, last_tile)).to eq(false)
    end
  end

  describe Chess::Piece::Pawn do
    let(:pawn_class) { described_class.new }

    describe '#moves' do
      it 'returns pawn moves given a board state and pawn model' do
        expect(pawn_class.moves(valid_game.board, pawn)).to include("a3")
      end
    end
  end

  describe Chess::Piece::Knight do
    let(:knight_class) { described_class.new }

    describe '#moves' do
      it 'returns knight moves given a board state and knight model' do
        expect(knight_class.moves(valid_game.board, pawn)).to include("c3")
      end
    end
  end

  describe Chess::Piece::Rook do
    let(:rook_class) { described_class.new }

    describe '#moves' do
      it 'returns rook moves given a board state and rook model' do
        expect(rook_class.moves(valid_game.board, rook)).to be_empty
      end
    end
  end

end