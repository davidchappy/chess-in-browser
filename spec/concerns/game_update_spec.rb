require 'rails_helper'
include GameUpdate

RSpec.describe GameUpdate do
  let(:game) { create(:game) }

  describe "#set_status" do
    before { game.set_status("check") }

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

  describe '#get_moves' do
    let(:game_with_moves) { get_moves(game) }

    it "assigns moves to the current player's piece" do
      game_with_moves.black_pieces.each do |piece|
        expect(piece.moves).to be_empty
      end
      pieces_with_moves = game_with_moves.current_pieces.select do |piece|
        piece if piece.moves.length > 0
      end
      expect(pieces_with_moves).to_not be_empty
    end

    context 'when starting up' do
      it "assigns correct moves to white pieces" do
        white_starting_moves = {
          "white-p1": ["a3", "a4"],
          "white-p2": ["b3", "b4"],
          "white-p3": ["c3", "c4"],
          "white-p4": ["d3", "d4"],
          "white-p5": ["e3", "e4"],
          "white-p6": ["f3", "f4"],
          "white-p7": ["g3", "g4"],
          "white-p8": ["h3", "h4"],
          "white-r1": [],
          "white-r2": [],
          "white-n1": ["a3", "c3"],
          "white-n2": ["h3", "f3"],
          "white-b1": [],
          "white-b2": [],
          "white-k":  [],
          "white-q":  [],
        }
        white_starting_moves.each do |piece_name, moves|
          piece = game_with_moves.white_pieces.where(name: piece_name).take
          if moves.length > 0
            moves.each do |move|
              expect(piece.moves.select {|p| p if p["to"] == move}.length).to be > 0
            end
          else
            expect(piece.moves).to be_empty
          end
        end
      end # end it white pieces
          
      it "assigns correct moves to black pieces" do
        black_starting_moves = {
          "black-p1": ["a6", "a5"],
          "black-p2": ["b6", "b5"],
          "black-p3": ["c6", "c5"],
          "black-p4": ["d6", "d5"],
          "black-p5": ["e6", "e5"],
          "black-p6": ["f6", "f5"],
          "black-p7": ["g6", "g5"],
          "black-p8": ["h6", "h5"],
          "black-r1": [],
          "black-r2": [],
          "black-n1": ["a6", "c6"],
          "black-n2": ["h6", "f6"],
          "black-b1": [],
          "black-b2": [],
          "black-k":  [],
          "black-q":  [],
        }
        game_with_moves.set_turn(game_with_moves.white, game_with_moves.black)
        get_moves(game_with_moves)
        
        black_starting_moves.each do |piece_name, moves|
          piece = game_with_moves.black_pieces.where(name: piece_name).take
          if moves.length > 0
            moves.each do |move|
              expect(piece.moves.select {|p| p if p[:to] == move}.length).to be > 0
            end
          else
            expect(piece.moves).to be_empty
          end
        end
      end # end it black pieces
          
    end # end context

  end # end #get_moves
      
end # end RSpec describe GameUpdate