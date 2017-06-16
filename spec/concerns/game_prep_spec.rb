require 'rails_helper'
include GamePrep

RSpec.describe GamePrep do
  let!(:guest1) { Guest.create(name: "Jim") }
  let!(:guest2) { Guest.create(name: "Bob") }
  let!(:game) { Game.create(white: guest1, black: guest2, status: "starting") }

  describe '#generate_pieces' do
    it "adds all game piece objects to a game object" do
      expect(game.pieces).to_not be_empty
      expect(game.pieces.length).to eq(32)
      expect(game.white.pieces).to_not be_empty
      expect(game.white.pieces.length).to eq(16)
      expect(game.black.pieces).to_not be_empty
      expect(game.black.pieces.length).to eq(16)
    end

    it "assigns a color to each piece" do
      
    end

    it "properly creates db records" do
      expect(Game.last.pieces.length).to eq(32)
      expect(Game.last.white.pieces.length).to eq(16)
      expect(Game.last.black.pieces.length).to eq(16)
    end
  end

  describe '#place_pieces' do
    it "adds positions to each player's piece" do
      expect(game.white.pieces).to_not be_empty
      expect(game.white.pieces.first.position).to_not eq("unplaced")
    end

    it "should add positions to pieces and save them" do
      white = game.white
      black = game.black
      
      expect(white.pieces).to_not be_empty
      white.pieces.each do |piece|
        expect(piece.position).to_not eq("unplaced")
      end
      
      expect(black.pieces).to_not be_empty
      black.pieces.each do |piece|
        expect(piece.position).to_not eq("unplaced")
      end
    end
  end

  describe '#init_board' do
    it 'fills game.board' do
      expect(game.board).to_not be_nil
      expect(game.board).to_not be_empty
      expect(game.board.length).to eq(64)
    end
  end
  
end