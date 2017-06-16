require 'rails_helper'
include GameUpdate

RSpec.describe GameUpdate do
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

  describe '#get_moves' do
    let(:game_with_moves) { get_moves(game) }

    it "assigns moves to each player's piece" do
      [game_with_moves.white, game_with_moves.black].each do |player|
        player.pieces.each do |piece|
          expect(piece.available_moves.length).to_not eq(0)
          expect(piece.available_moves).to_not be_nil
        end
      end
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
          piece = game_with_moves.white.pieces.where(name: piece_name).take
          if moves.length > 0
            moves.each do |move|
              expect(parse(piece.available_moves)).to include(move)
            end
          else
            expect(parse(piece.available_moves)).to eq(moves)
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
        black_starting_moves.each do |piece_name, moves|
          piece = game_with_moves.black.pieces.where(name: piece_name).take
          if moves.length > 0
            moves.each do |move|
              expect(parse(piece.available_moves)).to include(move)
            end
          else
            expect(parse(piece.available_moves)).to eq(moves)
          end
        end
      end # end it black pieces
          
    end # end context

  end # end #get_moves
      
end # end RSpec describe GameUpdate