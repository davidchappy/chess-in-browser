require "rails_helper"

RSpec.describe GamesController, :type => :controller do
  let!(:guest1) { create(:white_guest) }
  let!(:guest2) { create(:black_guest) }
  # let(:player1) { create(:player) }
  # let(:player2) { create(:player) }
  let(:game) { Game.create(white: guest1, black: guest2, status: "starting") }

  describe '#generate_pawns' do
    before { generate_pawns(game) }

    it "should add pawn objects to a game object" do
      expect(game.pieces).to_not be_nil
      expect(game.white.pieces).to_not be_nil
      expect(game.black.pieces).to_not be_nil
      expect(generate_pawns(game)).to_not be_nil
    end
  end

end