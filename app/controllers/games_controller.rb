class GamesController < ApplicationController
  include GameHelpers
  before_action :set_game, only: [:show]

  def create
    # Determine if Player vs. Player, Player vs. Guest, or Guest vs. Guest
    if params[:player1_id] && params[:player2_id]
      ## Player vs. Player (2 users via socket connection)
      # player1 = Player.find(params[:player1_id])
      # player2 = Player.find(params[:player2_id])
      # @white, @black = [player1, player2].shuffle
    elsif params[:player1_id] && params[:guest1]
      ## Player vs. Guest (hotseat as user)
      # player1 = Player.find(params[:player1_id])
      # player2 = Guest.create(name: params[:guest2])
      # @white, @black = [player1, player2].shuffle
    else
      ## Guest vs. Guest (hotseat as guest)
      @white, @black = create_guests(params[:guest1], params[:guest2])
    end

    # Create game and respond
    raw_game = Game.create!( white: @white,  black: @black, status: "starting" )
    @game = set_status(Chess::Game.start(raw_game))
    response = {
      game: @game,
      white: serialize(@white, :pieces),
      black: serialize(@black, :pieces)
    }
    render json: response
  end

  def show
    @game = Chess::Game.update(@game, params[:position_changes])
    @white = @game.white
    @black = @game.black
    response = {
      game: @game,
      white: serialize(@white, :pieces),
      black: serialize(@black, :pieces)
    }
    render json: response
  end

  private

    def set_status(game)
      game.status = "playing"
      game.save!
      game.white.is_playing = true
      game.white.save!
      game
    end

    def games_params
      params.permit(:guest1, :guest2, :player1_id, :player2_id)
    end

    def set_game
      @game = Game.find(params[:id])
    end
end