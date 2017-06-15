class GamesController < ApplicationController
  include GameHelpers
  before_action :set_game, only: [:show, :update]

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
    render json: game_response
  end

  def show
    @white = @game.white
    @black = @game.black
    render json: game_response
  end

  def update
    @game, @white, @black = Game.update(@game, params[:move])
    render json: game_response
    # render json: params
  end

  private

    def games_params
      params.permit(:guest1, :guest2, :player1_id, :player2_id, :move)
    end

    def set_game
      @game = Game.find(params[:id])
    end

    def game_response
      response = {
        game: @game,
        white: serialize(@white, "pieces"),
        black: serialize(@black, "pieces")
      }
    end
end