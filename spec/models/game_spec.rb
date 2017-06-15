require 'rails_helper'

RSpec.describe Game, type: :model do
  # using should syntax for Shoulda Matchers
  
  describe 'association tests' do
    it { should belong_to(:white) }
    it { should belong_to(:black) }
    it { should have_many(:pieces).dependent(:destroy) }
  end

  describe 'validation tests' do
    # Validation tests
    # ensure status is one of valid options
    it { should validate_inclusion_of(:status).in_array(["starting", "saved", "playing", "check", "check_mate"]) }
    # ensure player types are valid
    it { should validate_inclusion_of(:black_type).in_array(["Guest", "User"]) }
    it { should validate_inclusion_of(:white_type).in_array(["Guest", "User"]) }
  end

  context 'when playing as guest vs guest' do

    describe '.start' do
      let!(:white) { Guest.create(name: "Player 1") }
      let!(:black) { Guest.create(name: "Player 2") }
      let!(:game) { Game.start(white, black) }

      it "should return an array with a game and 2 players/guests" do
        expect(game).to be_a(Array)
        expect(game.length).to eq(3)
        expect(game[0]).to be_a(Game)
        expect(game[1]).to be_a(Guest)
        expect(game[2]).to be_a(Guest)
      end
    end

  end

end
