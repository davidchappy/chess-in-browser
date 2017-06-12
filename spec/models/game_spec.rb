require 'rails_helper'

RSpec.describe Game, type: :model do
  # using should syntax for Shoulda Matchers
  
  # Association test
  # ensure belongs_to relationship with each player
  it { should belong_to(:white) }
  it { should belong_to(:black) }
  it { should have_many(:pieces).dependent(:destroy) }

  # Validation tests
  # ensure status is one of valid options
  it { should validate_inclusion_of(:status).in_array(["starting", "saved", "playing", "check", "check_mate"]) }
  # ensure player types are valid
  it { should validate_inclusion_of(:black_type).in_array(["Guest", "User"]) }
  it { should validate_inclusion_of(:white_type).in_array(["Guest", "User"]) }

  describe '#generate' do
    let(:guest1) { Guest.create(name: "Jim") }
    let(:guest2) { Guest.create(name: "Bob") }
    # let(:player1) { create(:player) }
    # let(:player2) { create(:player) }
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
