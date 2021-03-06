require 'rails_helper'

RSpec.describe Guest, type: :model do

  # Association tests
  # ensure has 1:1 relationship with game by its color 
  it { should have_one(:game).dependent(:destroy) }

  # Validation tests
  # ensure has name, either white or black
  it { should validate_presence_of(:name) }
end
