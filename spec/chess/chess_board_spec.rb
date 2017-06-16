require 'rails_helper'
require 'chess/chess'

RSpec.describe Chess::Piece do
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
end