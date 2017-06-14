class GamesController < ApplicationController
  include GameHelpers
  before_action :set_game, only: [:show]

  def create
    # Determine if Player vs. Player, Player vs. Guest, or Guest vs. Guest
    if params[:player1_id] && params[:player2_id]
      ## Player vs. Player (2 users via socket connection)
    elsif params[:player1_id] && params[:guest1]
      ## Player vs. Guest (hotseat as user)
    else
      ## Guest vs. Guest (hotseat as guest)
      white, black = create_guests(params[:guest1], params[:guest2])
    end

    # Create game and respond
    @game, @white, @black = Game.start(white, black)
    set_status(@game)
    response = {
      game: @game,
      white: serialize(@white, "pieces"),
      black: serialize(@black, "pieces")
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

    def games_params
      params.permit(:guest1, :guest2, :player1_id, :player2_id)
    end

    def set_game
      @game = Game.find(params[:id])
    end
end