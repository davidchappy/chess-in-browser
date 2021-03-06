require 'rails_helper'

RSpec.describe Piece, type: :model do
  # Association test
  # ensure M:1 relationship with player
  it { should belong_to(:game) }

  # Validation tests
  it { should validate_presence_of(:position) }
  it { should validate_inclusion_of(:type).in_array(["King", "Queen", "Bishop", "Knight", "Rook", "Pawn"]) }
end
