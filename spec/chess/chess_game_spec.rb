require 'rails_helper'
require 'chess/chess'

RSpec.describe Chess::Game do
  let(:valid_game) { create(:game) }
  let(:white) { valid_game.white }
  let(:black) { valid_game.black }
  let(:piece_classes) { ["Rook", "Knight", "Bishop", "King", "Queen", "Pawn"] }

  describe '.position_pieces' do
    it 'assigns positions to each Piece in given pieces array' do
      white_pieces = Chess::Game.position_pieces(valid_game.white_pieces)
      expect(white_pieces.length).to eq(16)
      white_pieces.each do |piece|
        expect(piece.position).to_not eq("unplaced")
        expect(piece_classes).to include(piece.class.to_s)
      end

      black_pieces = Chess::Game.position_pieces(valid_game.black_pieces)
      expect(black_pieces.length).to eq(16)
      black_pieces.each do |piece|
        expect(piece.position).to_not eq("unplaced")
        expect(piece_classes).to include(piece.class.to_s)
      end
    end
  end

  describe '.init_board' do
    before do
      Chess::Game.position_pieces(valid_game.white_pieces).each(&:save!)
      Chess::Game.position_pieces(valid_game.black_pieces).each(&:save!)
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
    let(:moves) { Chess::Game.get_moves(valid_game) }
    
    it "returns a hash with piece names as keys" do
      expect(moves).to be_a(Hash)
      expect(moves.length).to eq(10)

      expect(moves['white-p4']).to_not be_empty
      expect(moves['black-n2']).to be_nil      
      expect(moves['white-k']).to be_nil
    end

    it "returns arrays of moves for each piece" do
      expect(moves['white-p4']).to be_a(Hash)
      expect(moves['white-p4'].keys).to include("d3")

      expect(moves['white-k']).to be_nil
    end    
  end

  describe '.update_board' do
    let(:updated_board) { Chess::Game.update_board(valid_game) }

    it "" do
    end
  end

  describe '#castle' do
    it "updates board with ids of moved king and rook" do
      board = valid_game.board
      board[:g1] = board[:f1] = ""
      king = valid_game.current_king
      rook = valid_game.pieces.where(name: 'white-r2').take
      to = 'g1'
      described_class.castle(to, king, board)
      expect(board[:g1]).to eq(king.id) 
      expect(board[:f1]).to eq(rook.id) 
    end
  end

end




