require "rails_helper"

RSpec.describe GamesController, :type => :controller do

  describe '#create_guests' do
    let!(:guests) { subject.create_guests("Susy", "Joanna") }
      
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