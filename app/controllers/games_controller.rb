class GamesController < ApplicationController

  def create
    # Determine if Player vs. Player, Player vs. Guest, or Guest vs. Guest
    if false
      ## Player vs. Player (2 users via socket connection)
    elsif false
      ## Player vs. Guest (hotseat as user)
    else
      ## Guest vs. Guest (hotseat as guest)
      players = create_guests(params[:guest1], params[:guest2])
      @white, @black = players
    end

    # Create game and respond
    @game = Game.create( white: @white,  black: @black, status: "starting" )
    generate_pieces(@game)
    json_response(Chess::Game.new(@game))
  end

  private

    def games_params
      params.permit(:guest1, :guest2, :player1_id)
    end
end