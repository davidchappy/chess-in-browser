require 'rails_helper'
require 'chess/chess'

RSpec.describe Chess::Piece do
  let(:piece_logic) { Chess::Piece.new }
  let!(:valid_game) { create(:game) }
  let!(:pawn)   { valid_game.white_pieces.where(name: "white-p1").take }
  let!(:rook)   { valid_game.white_pieces.where(name: "white-r1").take }
  let!(:knight) { valid_game.white_pieces.where(name: "white-n1").take }
  let!(:bishop) { valid_game.white_pieces.where(name: "white-b1").take }
  let!(:king)   { valid_game.white_pieces.where(name: "white-k").take }
  let!(:queen)  { valid_game.white_pieces.where(name: "white-q").take }

  describe '.get_piece_moves' do
    it 'returns hash of all available moves by piece' do
      moves = {
        "white-n1"=>{"a3"=>[], "c3"=>[]}, 
        "white-n2"=>{"f3"=>[], "h3"=>[]}, 
        "white-p1"=>{"a3"=>[], "a4"=>[]},
        "white-p2"=>{"b3"=>[], "b4"=>[]},
        "white-p3"=>{"c3"=>[], "c4"=>[]},
        "white-p4"=>{"d3"=>[], "d4"=>[]},
        "white-p5"=>{"e3"=>[], "e4"=>[]},
        "white-p6"=>{"f3"=>[], "f4"=>[]}, 
        "white-p7"=>{"g3"=>[], "g4"=>[]}, 
        "white-p8"=>{"h3"=>[], "h4"=>[]}, 
      }
      expect(described_class.get_piece_moves(valid_game)).to eq(moves)
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

  describe '#check' do
    it "returns true if a move would cause check or false if not" do
      board_in_check = valid_game.board
      valid_game.find_on_board('e2').position = "unplaced"
      board_in_check[:e2] = ""
      valid_game.find_on_board('f7').position = "unplaced"
      board_in_check[:f7] = ""
      piece = queen
      move = "h5"
      expect(described_class.new.check?(piece, move, valid_game)).to eq(true)
    end
  end

  describe '#filter_king_moves' do
    it "removes moves for king if they place him in danger" do      
      attacker = valid_game.pieces.where(name: 'black-q').first
      attacker.position = 'h4'
      attacker.save!
      valid_game.board[:h4] = attacker.id
      valid_game.board[:f2] = ""
      valid_game.board[:d2] = ""
      valid_game.save!

      king_moves = Chess::Piece::King.new.moves(king, valid_game)
      expect(king_moves.keys).to eq(['d2', 'f2'])

      filtered_moves = piece_logic.filter_king_moves(king_moves, valid_game)
      expect(filtered_moves).to include('d2')
      expect(filtered_moves).to_not include('f2')
    end
  end

  describe Chess::Piece::Pawn do
    let(:pawn_class) { described_class.new }

    describe '#moves' do
      it 'returns pawn moves given a board state and pawn model' do
        valid_game.board[:a3] = ""
        expect(pawn_class.moves(pawn, valid_game).keys).to include("a3")
      end
    end
  end

  describe Chess::Piece::Knight do
    let(:knight_class) { described_class.new }

    describe '#moves' do
      it 'returns knight moves given a board state and knight model' do
        expect(knight_class.moves(knight, valid_game).keys).to include("c3")
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
        expect(rook_class.moves(rook, valid_game)).to eq({})
        pawn = valid_game.find_on_board('a2')
        pawn.position = "unplaced"
        valid_game.board[:a2] = ""
        valid_game.board[:a3] = ""
        expect(rook_class.moves(rook, valid_game).keys).to include("a7")
      end
    end
  end

  describe Chess::Piece::Bishop do
    let(:bishop_class) { described_class.new }

    describe '#moves' do

    end

  end

end