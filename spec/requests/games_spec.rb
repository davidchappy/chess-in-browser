require "rails_helper"

RSpec.describe "Game Requests", :type => :request do
  # Create sample players
  let(:names) { ["Guest Player One", "Guest Player Two"]}
  let!(:guest_params) do 
    { guest1_name: names[0], guest2_name: names[1] } 
  end  

  # When game is requested as a guest player
  context 'when starting game as guest' do
    describe 'POST /api/games' do
      before { post "/api/games", params: guest_params }

      it "returns a game" do
        expect(json).not_to be_empty
        expect(json['game']).not_to be_nil
        expect(json['game']['status']).to eq('playing')
      end

      it "returns a game with two guest players" do
        expect(json['white']['email']).to be_nil
        expect(json['black']['email']).to be_nil
        expect(names).to include(json['white']['name'])
        expect(names).to include(json['black']['name'])
      end

      it "returns 16 pieces for each player" do
        expect(json['white']['pieces'].length).to eq(16)
        expect(json['black']['pieces'].length).to eq(16)
      end
    end

  end

  # When game is requested as a valid user
end