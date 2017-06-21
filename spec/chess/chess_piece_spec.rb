require 'rails_helper'
require 'chess/chess'

RSpec.describe Chess::Piece do
  let!(:valid_game) { create(:game) }
  let!(:pawn)   { valid_game.white_pieces.where(name: "white-p1").take }
  let!(:rook)   { valid_game.white_pieces.where(name: "white-r1").take }
  let!(:knight) { valid_game.white_pieces.where(name: "white-n1").take }
  let!(:bishop) { valid_game.white_pieces.where(name: "white-b1").take }
  let!(:king)   { valid_game.white_pieces.where(name: "white-k").take }
  let!(:queen)  { valid_game.white_pieces.where(name: "white-q").take }

  describe '.get_piece_moves' do
    it 'returns hash of all moves for a piece' do
      expect(described_class.get_piece_moves(valid_game.board, pawn)).to eq({"a3"=>"", "a4" => ""})
    end

    # it 'returns check flag if move would place board in check' do
    #   board_in_check = valid_game.board
    #   board_in_check[:c2].position = "unplaced"
    #   board_in_check[:c2] = ""
    #   board_in_check[:d7].position = "unplaced"
    #   board_in_check[:d7] = ""
    #   expect(described_class.get_piece_moves("a4", board_in_check, queen)["a4"]).to include("check")
    # end
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

  describe '#check' do
    it "returns true if a move would cause check or false if not" do
      board_in_check = valid_game.board
      board_in_check[:e2].position = "unplaced"
      board_in_check[:e2] = ""
      board_in_check[:f7].position = "unplaced"
      board_in_check[:f7] = ""
      piece = queen
      move = { "h5" => "" }
      expect(described_class.new.check?(piece, move, board_in_check)).to eq(true)
    end
  end

  describe Chess::Piece::Pawn do
    let(:pawn_class) { described_class.new }

    describe '#moves' do
      it 'returns pawn moves given a board state and pawn model' do
        valid_game.board[:a3] = ""
        expect(pawn_class.moves(valid_game.board, pawn).keys).to include("a3")
      end
    end
  end

  describe Chess::Piece::Knight do
    let(:knight_class) { described_class.new }

    describe '#moves' do
      it 'returns knight moves given a board state and knight model' do
        expect(knight_class.moves(valid_game.board, knight).keys).to include("c3")
      end
    end

    describe '#knight_wrapped?' do
      let(:next_tile) { "h3" }
      let(:last_tile) { "b1" }

      it "prevents Knight horizontally wrapping around board" do
        expect(knight_class.knight_wrapped?(next_tile, last_tile)).to eq(true)

        next_tile = "b5"
        last_tile = "h4"
        expect(knight_class.knight_wrapped?(next_tile, last_tile)).to eq(true)
      end

      it "prevents Knight vertically wrapping around board" do
        next_tile = "a2"
        last_tile = "b5"
        expect(knight_class.knight_wrapped?(next_tile, last_tile)).to eq(true)

        next_tile = "f7"
        last_tile = "g1"
        expect(knight_class.knight_wrapped?(next_tile, last_tile)).to eq(true)
      end

      it "allows legal Knight moves" do
        next_tile = "h6"
        last_tile = "g8"

        expect(knight_class.knight_wrapped?(next_tile, last_tile)).to eq(false)
      end
    end
  end

  describe Chess::Piece::Rook do
    let(:rook_class) { described_class.new }

    describe '#moves' do
      it 'returns rook moves given a board state and rook model' do
        expect(rook_class.moves(valid_game.board, rook)).to eq({})
        pawn = valid_game.board[:a2]
        pawn.position = "unplaced"
        valid_game.board[:a2] = ""
        valid_game.board[:a3] = ""
        expect(rook_class.moves(valid_game.board, rook).keys).to include("a7")
      end
    end
  end

  describe Chess::Piece::Bishop do
    let(:bishop_class) { described_class.new }

    describe '#moves' do

    end

  end

end