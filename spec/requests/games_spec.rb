require "rails_helper"

RSpec.describe "Game Requests", :type => :request do
  # Create sample players
  let(:names) { ["Guest Player One", "Guest Player Two"]}
  let(:guest_params) do 
    { guest1: names[0], guest2: names[1] } 
  end  

  # When game is requested as a guest player
  context 'when starting game as guest' do
    describe 'POST /api/games' do
      before { post "/api/games", params: guest_params }

      it "returns a game" do
        expect(json).not_to be_empty
        expect(json).not_to be_nil
        expect(json['game']['status']).to eq('playing')
      end

      it "returns two guest players" do
        white = json['white']
        expect(white).to_not be_nil
        expect(white['is_playing']).to eq(true)
        expect(white['email']).to be_nil

        black = json['black']
        expect(black).to_not be_nil
        expect(black['email']).to be_nil
        
        expect(names).to include(white['name'])
        expect(names).to include(black['name'])
      end

      it "returns 16 pieces for each player" do
        expect(json['white']['pieces'].length).to eq(16)
        expect(json['black']['pieces'].length).to eq(16)
        expect(json['white']['pieces'].first).not_to eq("unplaced")
        expect(json['black']['pieces'].first).not_to eq("unplaced")
      end
    end

  end

  # When game is requested as a valid user
end