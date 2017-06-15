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

end