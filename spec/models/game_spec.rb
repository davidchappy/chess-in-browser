require 'rails_helper'

RSpec.describe Game, type: :model do
  # should syntax for Shoulda Matchers
  
  # Association test
  # ensure belongs_to relationship with each player
  it { should belong_to(:white_player) }
  it { should belong_to(:black_player) }
  it { should have_many(:pieces).dependent(:destroy) }
  # validation tests
  # ensure presence of name 
  it { should validate_inclusion_of(:status).in_array(["starting", "saved", "playing", "check", "check_mate"]) }
end
