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
        expect(json['game']).to_not be_nil
        expect(json['game']['status']).to eq('playing')
      end

      it "returns a valid game board" do
        expect(json['game']['board']).to_not be_nil
        expect(json['game']['board']).to_not be_empty

        pieces = json['pieces']
        ids = pieces.map {|piece| piece['id']}
        json['game']['board'].each do |tile, value|
          unless value == ""
            expect(ids).to include(value)
          end
        end
      end

      it "returns an array of 32 placed game pieces" do
        pieces = json['pieces']
        expect(pieces.length).to eq(32)
        expect(pieces.all? { |piece| piece['position'] != "unplaced" }).to eq(true)
      end

      it "includes unique names for each piece" do
        pieces = json['pieces']
        names = pieces.map { |piece| piece['name'] }
        expect(names).to eq(
          [ "white-r1", "white-r2", 
            "white-n1", "white-n2", 
            "white-b1", "white-b2", 
            "white-k",  "white-q", 
            "white-p1", "white-p2", 
            "white-p3", "white-p4", 
            "white-p5", "white-p6", 
            "white-p7", "white-p8", 
            "black-r1", "black-r2", 
            "black-n1", "black-n2", 
            "black-b1", "black-b2", 
            "black-k",  "black-q", 
            "black-p1", "black-p2", 
            "black-p3", "black-p4", 
            "black-p5", "black-p6", 
            "black-p7", "black-p8"]
        )
      end

      it "returns a game board with blank tiles" do
        expect(json['game']['board']['a6']).to eq('')
        expect(json['game']['board']['a5']).to eq('')
        expect(json['game']['board']['a4']).to eq('')
        expect(json['game']['board']['a3']).to eq('')
        expect(json['game']['board']['b6']).to eq('')
        expect(json['game']['board']['b5']).to eq('')
        expect(json['game']['board']['b4']).to eq('')
        expect(json['game']['board']['b3']).to eq('')
        expect(json['game']['board']['c6']).to eq('')
        expect(json['game']['board']['c5']).to eq('')
        expect(json['game']['board']['c4']).to eq('')
        expect(json['game']['board']['c3']).to eq('')
        expect(json['game']['board']['d6']).to eq('')
        expect(json['game']['board']['d5']).to eq('')
        expect(json['game']['board']['d4']).to eq('')
        expect(json['game']['board']['d3']).to eq('')
        expect(json['game']['board']['e6']).to eq('')
        expect(json['game']['board']['e5']).to eq('')
        expect(json['game']['board']['e4']).to eq('')
        expect(json['game']['board']['e3']).to eq('')
        expect(json['game']['board']['f6']).to eq('')
        expect(json['game']['board']['f5']).to eq('')
        expect(json['game']['board']['f4']).to eq('')
        expect(json['game']['board']['f3']).to eq('')
        expect(json['game']['board']['g6']).to eq('')
        expect(json['game']['board']['g5']).to eq('')
        expect(json['game']['board']['g4']).to eq('')
        expect(json['game']['board']['g3']).to eq('')
        expect(json['game']['board']['h6']).to eq('')
        expect(json['game']['board']['h5']).to eq('')
        expect(json['game']['board']['h4']).to eq('')
        expect(json['game']['board']['h3']).to eq('')
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

      it "returns accurate available moves for pieces" do        
        white_pawn = json['pieces'].select{|p| p if p['name'] == 'white-p1'}[0]
        white_moves = white_pawn['moves']
        expect(white_moves.any? {|m| m if m["to"] == "a3"}).to be_truthy
        expect(white_moves.any? {|m| m if m["to"] == "a4"}).to be_truthy

        white_knight = json['pieces'].select{|p| p if p['name'] == 'white-n1'}[0]
        white_moves = white_knight['moves']
        expect(white_moves.any? {|m| m if m["to"] == "a3"}).to be_truthy
        expect(white_moves.any? {|m| m if m["to"] == "c3"}).to be_truthy

        white_queen = json['pieces'].select{|p| p if p['name'] == 'white-q'}[0]
        queen_moves = white_queen['moves']
        expect(queen_moves).to be_empty
      end
    end

    describe 'PUT /api/games/:id' do
      let!(:game) { create(:game) }
      let!(:game_board) { game.board }
      let!(:valid_params) { { "move" => { "from" => "a2", "to" => "a4", "flags" => [] } } }
      let!(:id) { game.id }

      before do
        put "/api/games/#{id}", params: valid_params
      end

      it "returns an updated board" do
        expect(json).to_not be_empty
        expect(json['game']).to_not be_empty
        expect(json['game']['board']).to_not eq(JSON.parse(game_board.to_json))
      end

      it "moves a piece" do
        pawn = json['pieces'].select{ |piece| piece if piece['name'] == 'white-p1' }.first
        a2 = json['game']['board']['a2']
        expect(a2).to eq("")
        pawn_id = json['game']['board']['a4']
        expect(pawn_id).to eq(pawn['id'])
      end

      it "alters the state of the Game's board" do
        board = Game.find(game.id).board
        piece = game.find_piece_by_name('white-p1')
        expect(board[:a2]).to eq("")
        expect(board[:a4]).to eq(piece.id)
      end

      it "changes player turns" do
        expect(game.current_player).to eq(game.white)
        expect(Game.find(game.id).current_player).to eq(game.black)
      end

      it "returns moves only for the new current player's pieces" do
        white_pieces = game.white_pieces
        white_pieces.each do |piece|
          expect(piece.moves).to be_empty
        end

        black_pieces = game.black_pieces
        black_pawn = black_pieces.select{|p| p if p.name == 'black-p1'}[0]
        expect(black_pawn.moves.any? {|m| m if m.to == "a6"}).to be_truthy
        expect(black_pawn.moves.any? {|m| m if m.to == "a5"}).to be_truthy  
      end
    end

    # For saved games
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