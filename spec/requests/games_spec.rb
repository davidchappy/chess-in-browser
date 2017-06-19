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
      # before { post "/api/games", params: guest_params }

      it "returns a game" do
        post "/api/games", params: guest_params

        expect(json).not_to be_empty
        expect(json).not_to be_nil
        expect(json['game']['status']).to eq('playing')
      end

      it "returns a game board with pieces" do
        post "/api/games", params: guest_params

        expect(json['game']['board']).to_not be_nil
        expect(json['game']['board']).to_not be_empty
        expect(json['game']['board']['a8']['name']).to eq('black-r1')
        expect(json['game']['board']['b8']['name']).to eq('black-n1')
        expect(json['game']['board']['c8']['name']).to eq('black-b1')
        expect(json['game']['board']['d8']['name']).to eq('black-q')
        expect(json['game']['board']['e8']['name']).to eq('black-k')
        expect(json['game']['board']['f8']['name']).to eq('black-b2')
        expect(json['game']['board']['g8']['name']).to eq('black-n2')
        expect(json['game']['board']['h8']['name']).to eq('black-r2')
        expect(json['game']['board']['a7']['name']).to eq('black-p1')
        expect(json['game']['board']['b7']['name']).to eq('black-p2')
        expect(json['game']['board']['c7']['name']).to eq('black-p3')
        expect(json['game']['board']['d7']['name']).to eq('black-p4')
        expect(json['game']['board']['e7']['name']).to eq('black-p5')
        expect(json['game']['board']['f7']['name']).to eq('black-p6')
        expect(json['game']['board']['g7']['name']).to eq('black-p7')
        expect(json['game']['board']['h7']['name']).to eq('black-p8')

        expect(json['game']['board']['a1']['name']).to eq('white-r1')
        expect(json['game']['board']['b1']['name']).to eq('white-n1')
        expect(json['game']['board']['c1']['name']).to eq('white-b1')
        expect(json['game']['board']['d1']['name']).to eq('white-q')
        expect(json['game']['board']['e1']['name']).to eq('white-k')
        expect(json['game']['board']['f1']['name']).to eq('white-b2')
        expect(json['game']['board']['g1']['name']).to eq('white-n2')
        expect(json['game']['board']['h1']['name']).to eq('white-r2')
        expect(json['game']['board']['a2']['name']).to eq('white-p1')
        expect(json['game']['board']['b2']['name']).to eq('white-p2')
        expect(json['game']['board']['c2']['name']).to eq('white-p3')
        expect(json['game']['board']['d2']['name']).to eq('white-p4')
        expect(json['game']['board']['e2']['name']).to eq('white-p5')
        expect(json['game']['board']['f2']['name']).to eq('white-p6')
        expect(json['game']['board']['g2']['name']).to eq('white-p7')
        expect(json['game']['board']['h2']['name']).to eq('white-p8')
      end

      it "returns two guest players" do
        post "/api/games", params: guest_params

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
        post "/api/games", params: guest_params

        expect(json['white']['pieces'].length).to eq(16)
        expect(json['black']['pieces'].length).to eq(16)
        expect(json['white']['pieces'].first).not_to eq("unplaced")
        expect(json['black']['pieces'].first).not_to eq("unplaced")
      end

      it "returns accurate available moves for pieces" do
        post "/api/games", params: guest_params
        
        white_pawn = json['white']['pieces'].select{|p| p if p['name'] == 'white-p1'}[0]
        white_moves = white_pawn['moves']
        expect(white_moves.any? {|m| m if m["to"] == "a3"}).to be_truthy
        expect(white_moves.any? {|m| m if m["to"] == "a4"}).to be_truthy

        black_knight = json['black']['pieces'].select{|p| p if p['name'] == 'black-n1'}[0]
        black_moves = black_knight['moves']
        expect(black_moves.any? {|m| m if m["to"] == "a6"}).to be_truthy
        expect(black_moves.any? {|m| m if m["to"] == "c6"}).to be_truthy

        white_queen = json['white']['pieces'].select{|p| p if p['name'] == 'white-q'}[0]
        queen_moves = white_queen['moves']
        expect(queen_moves).to be_empty
      end
    end

    describe 'PUT /api/games/:id' do
      let!(:game) { create(:game) }
      let!(:game_board) { game.board }
      let!(:valid_params) { { move: "a2,a4" } }
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
        a2 = json['game']['board']['a2']
        expect(a2).to eq("")
        a4 = json['game']['board']['a4']
        expect(a4['name']).to eq(pawn['name'])
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