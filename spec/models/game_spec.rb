require 'rails_helper'

RSpec.describe Game, type: :model do
  # using should syntax for Shoulda Matchers
  
  # Association test
  # ensure belongs_to relationship with each player
  it { should belong_to(:white) }
  it { should belong_to(:black) }
  it { should have_many(:pieces).dependent(:destroy) }

  # validation tests
  # ensure status is one of valid options
  it { should validate_inclusion_of(:status).in_array(["starting", "saved", "playing", "check", "check_mate"]) }
  # ensure player types are valid
  it { should validate_inclusion_of(:black_type).in_array(["Guest", "User"]) }
  it { should validate_inclusion_of(:white_type).in_array(["Guest", "User"]) }

end
