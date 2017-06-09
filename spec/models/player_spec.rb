require 'rails_helper'

RSpec.describe Player, type: :model do
  # should syntax for Shoulda Matchers
  
  # Association test
  # ensure 1:m relationship with games as either black or white player
  it { should have_many(:black_games).dependent(:destroy) }
  it { should have_many(:white_games).dependent(:destroy) }
  it { should have_many(:pieces).dependent(:destroy) }
  # validation tests
  # ensure presence of name 
  it { should validate_presence_of(:name) }
end
