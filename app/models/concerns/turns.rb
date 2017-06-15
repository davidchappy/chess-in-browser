module Turns
  extend ActiveSupport::Concern

  def set_status(game, status="playing")
    game.status = status
    game.save!
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