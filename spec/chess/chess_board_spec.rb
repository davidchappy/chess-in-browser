require 'rails_helper'
require 'chess/chess'

RSpec.describe Chess::Board do
  let!(:valid_game) { create(:game) }
  let!(:board) { valid_game.board }
  let!(:board_logic) { Chess::Board.new }

  describe "#is_piece?" do
    it "returns true if input is a valid tile on the board" do
      expect(board_logic.is_piece?("a8", board)).to eq(true)
    end

    it "returns false if input is not a valid tile" do
      expect(board_logic.is_piece?("a4", board)).to be(false)
    end
  end


  describe "#castle_moves" do
    it "returns an empty hash if no castle moves are available" do
      expect(board_logic.castle_moves(valid_game)).to be_a(Hash)
      expect(board_logic.castle_moves(valid_game)).to eq({})
    end

    it "returns a white king's valid castle moves when available" do
      game = valid_game
      game.board[:g1] = game.board[:f1] = ""
      player = game.current_player
      king_name = game.current_pieces.select{|p| p if p.type == "King"}.first.name
      castle_moves = board_logic.castle_moves(game)
      expect(castle_moves[king_name]).to eq({ "g1" => "castling" })
    end

    it "returns a black king's valid castle moves when available" do
      game = valid_game
      game.set_turn(game.white, game.black)
      player = game.current_player
      game.board[:g8] = game.board[:f8] = ""

      king_name = game.current_pieces.select{|p| p if p.type == "King"}.first.name
      castle_moves = board_logic.castle_moves(game)
      expect(castle_moves[king_name]).to eq({ "g8" => "castling" })
    end
  end
end