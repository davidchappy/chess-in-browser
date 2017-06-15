require 'rails_helper'
include Turns

RSpec.describe Turns do
  let(:game) { create(:game) }

  describe "#set_status" do
    before { set_status(game, "check") }

    it "marks game status as a valid status" do
      expect(game.status).to eq("check")
    end
  end

  describe "#set_turn" do
    it "assigns white as playing or switches players" do
      white = game.white
      black = game.black

      expect(white.is_playing).to eq(true)
      expect(black.is_playing).to eq(false)

      set_turn(white, black)
      expect(white.is_playing).to eq(false)
      expect(black.is_playing).to eq(true)
    end
  end

end