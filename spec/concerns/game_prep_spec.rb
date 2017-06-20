require 'rails_helper'
include GamePrep

RSpec.describe GamePrep do
  let!(:guest1) { Guest.create(name: "Jim") }
  let!(:guest2) { Guest.create(name: "Bob") }
  let!(:game) { Game.create(white: guest1, black: guest2, status: "starting") }

  describe '#generate_pieces' do
    include GamePrep

    it "adds all game piece objects to players" do
      guest1.pieces.destroy_all
      guest2.pieces.destroy_all
      game = Game.new(white: guest1, black: guest2, status: "starting")
      p generate_pieces(game).white.pieces
      # expect(game.white.pieces).to_not be_empty
      # expect(game.white.pieces.length).to eq(16)
      # p game.white.pieces
      # expect(game.black.pieces).to_not be_empty
      # expect(game.black.pieces.length).to eq(16)
    end

    it "assigns a color to each piece" do
      game.white.pieces.each do |piece|
        expect(piece.color).to eq("white")
      end
      game.black.pieces.each do |piece|
        expect(piece.color).to eq("black")
      end
    end

    it "properly creates db records" do
      expect(Game.last.white.pieces.length).to eq(16)
      Game.last.white.pieces.each do |piece|
        expect(piece.color).to eq("white")
      end

      expect(Game.last.black.pieces.length).to eq(16)
      Game.last.black.pieces.each do |piece|
        expect(piece.color).to eq("black")
      end
    end

    it "creates the right number of pieces" do
      expect((game.white.pieces.select {|p| p if p.type == "Rook"}).length).to eq(2)
      expect((game.white.pieces.select {|p| p if p.type == "Knight"}).length).to eq(2)
      expect((game.white.pieces.select {|p| p if p.type == "Bishop"}).length).to eq(2)
      expect((game.white.pieces.select {|p| p if p.type == "Queen"}).length).to eq(1)
      expect((game.white.pieces.select {|p| p if p.type == "King"}).length).to eq(1)
      expect((game.white.pieces.select {|p| p if p.type == "Pawn"}).length).to eq(8)

      expect((game.black.pieces.select {|p| p if p.type == "Rook"}).length).to eq(2)
      expect((game.black.pieces.select {|p| p if p.type == "Knight"}).length).to eq(2)
      expect((game.black.pieces.select {|p| p if p.type == "Bishop"}).length).to eq(2)
      expect((game.black.pieces.select {|p| p if p.type == "Queen"}).length).to eq(1)
      expect((game.black.pieces.select {|p| p if p.type == "King"}).length).to eq(1)
      expect((game.black.pieces.select {|p| p if p.type == "Pawn"}).length).to eq(8)
    end

    it "assigns unique names to each piece" do
      expect((game.white.pieces.select {|p| p if p.name == "white-p1"}).length).to eq(1)
      expect((game.white.pieces.select {|p| p if p.name == "white-k"}).length).to eq(1)
      expect((game.black.pieces.select {|p| p if p.name == "black-p5"}).length).to eq(1)
      expect((game.black.pieces.select {|p| p if p.name == "black-q"}).length).to eq(1)
    end
  end

  describe '#position_pieces' do
    it "adds positions to each player's piece" do
      expect(game.white.pieces).to_not be_empty
      expect(game.white.pieces.first.position).to_not eq("unplaced")
    end

    it "correctly saves the players' pieces in the db" do
      white = Game.last.white
      black = Game.last.black
      
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
      expect(game.board).to be_a(Hash)
      expect(game.board).to_not be_nil
      expect(game.board).to_not be_empty
      expect(game.board.length).to eq(64)
    end

    it "correctly saves the game board" do
      expect(Game.last.board).to_not be_nil
      expect(Game.last.board).to_not be_empty
      expect(Game.last.board.length).to eq(64)
    end
  end
  
end