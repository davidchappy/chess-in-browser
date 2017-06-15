require 'rails_helper'
include GamePrep

RSpec.describe GamePrep do

  describe '#generate_pieces' do
    let(:guest1) { Guest.create(name: "Jim") }
    let(:guest2) { Guest.create(name: "Bob") }
    let!(:game) { Game.create(white: guest1, black: guest2, status: "starting") }

    it "adds all game piece objects to a game object" do
      expect(game.pieces).to_not be_empty
      expect(game.pieces.length).to eq(32)
      expect(game.white.pieces).to_not be_empty
      expect(game.white.pieces.length).to eq(16)
      expect(game.black.pieces).to_not be_empty
      expect(game.black.pieces.length).to eq(16)
    end

    it "properly creates db records" do
      expect(Game.last.pieces.length).to eq(32)
      expect(Game.last.white.pieces.length).to eq(16)
      expect(Game.last.black.pieces.length).to eq(16)
    end
  end
  
end