require "rails_helper"

RSpec.describe GamesController, :type => :controller do
  let!(:guests) { subject.create_guests("Susy", "Joanna") }
  let!(:game_array) { Game.start(guests[0], guests[1]) }

  describe '#create_guests' do
    it "returns an array of guest objects" do
      expect(guests).to be_a(Array)
      expect(guests[0]).to be_a(Guest)
    end  

    it "creates two objects with given names" do
      expect(Guest.all.length).to eq(2)
      expect(["Susy", "Joanna"]).to include(Guest.last.name)
    end
  end

  describe "#set_status" do
    it "marks game status as playing" do
      game = game_array[0]
      expect(set_status(game).status).to eq("playing")
    end
  end

  describe "#set_turn" do
    it "assigns white as playing or switches players" do
      white = guests[0]
      black = guests[1]
      expect(white.is_playing).to eq(false)
      expect(black.is_playing).to eq(false)

      set_turn(white, black)
      expect(white.is_playing).to eq(true)
      expect(black.is_playing).to eq(false)

      set_turn(white, black)
      expect(white.is_playing).to eq(false)
      expect(black.is_playing).to eq(true)
    end
  end

end