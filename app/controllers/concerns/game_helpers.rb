module GameHelpers
  extend ActiveSupport::Concern

  included do
    helper_method :create_guests
  end

  def create_guests(name1, name2)
    # Create Guest players and randomize order
    player1 = Guest.create!(name: name1)
    player2 = Guest.create!(name: name2)
    [player1, player2].shuffle
  end

end