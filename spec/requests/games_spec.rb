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

      it "returns a game board with pieces" do
        expect(json['game']['board']).to_not be_nil
        expect(json['game']['board']).to_not be_empty
        expect(json['game']['board']['a8']['name']).to eq('black-r1')
        expect(json['game']['board']['f1']['name']).to eq('white-b2')
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

      it "returns accurate available moves for pieces" do
        white_pawn = json['white']['pieces'].select{|p| p if p['name'] == 'white-p1'}[0]
        expect(parse(white_pawn['available_moves'])).to include("a3")
        expect(parse(white_pawn['available_moves'])).to include("a4")

        black_knight = json['black']['pieces'].select{|p| p if p['name'] == 'black-n1'}[0]
        expect(parse(black_knight['available_moves'])).to include("a6")
        expect(parse(black_knight['available_moves'])).to include("c6")

        white_queen = json['white']['pieces'].select{|p| p if p['name'] == 'white-q'}[0]
        expect(parse(white_queen['available_moves'])).to eq([])
      end
    end

    describe 'PUT /api/games/:id' do
      let!(:game) { create(:game) }
      let!(:game_board) { game.board }
      let(:valid_params) { { move: "a2,a4" } }
      let!(:id) { game.id }

      before do
        put "/api/games/#{id}", params: valid_params
      end

      it "returns an updated board" do
        expect(json).to_not be_empty
        expect(json['game']).to_not be_empty
        expect(json['game']['board']).to_not eq(game_board)
      end

      it "moves a piece" do
        pawn = game_board[:a2]
        expect(json['game']['board']['a2']).to eq("")
        expect(json['game']['board']['a4']['name']).to eq(pawn.name)
      end

    end

    describe 'GET /api/games/:id' do
      # let(:game) { create(:game) }

      # before do 
      #   id = game.id
      #   get "/api/games/#{id}" 
      # end

      # it "returns a game" do
      #   expect(json).not_to be_empty
      #   expect(json).not_to be_nil
      #   expect(json['game']['status']).to eq('playing')
      # end

    end

  end
  # When game is requested as a valid user
end