require 'rails_helper'

RSpec.describe Piece, type: :model do
  # Association test
  # ensure M:1 relationship with both game and player
  it { should belong_to(:game) }
  it { should belong_to(:player) }

  # Validation tests
  it { should validate_presence_of(:position) }
  it { should validate_inclusion_of(:type).in_array(["King", "Queen", "Bishop", "Knight", "Rook", "Pawn"]) }
end
