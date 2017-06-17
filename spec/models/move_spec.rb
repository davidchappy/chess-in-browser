require 'rails_helper'

RSpec.describe Move, type: :model do
  # Association tests
  # ensure M:1 relationship with piece
  it { should belong_to(:piece) }

  # Validation test
  it { should validate_presence_of(:to) }
end