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

  def set_status(game)
    game.status = "playing"
    game.save!
    set_turn(game.white, game.black)
    game
  end

  def set_turn(white, black) 
    if white.is_playing
      white.is_playing = false
      black.is_playing = true
      white.save!
      black.save!
    elsif black.is_playing
      white.is_playing = true
      black.is_playing = false
      white.save!
      black.save!
    else 
      white.is_playing = true
      black.is_playing = false
      white.save!
      black.save!
    end
  end

end