module Chess

  class Game
    include PieceMethods

    # Returns a player's pieces with initial positions set
    def self.place_pieces(pieces)
      color = pieces.first.color
      positions = starting_positions(pieces, color)
      pieces.each do |piece|
        piece.position = positions[piece.id] if positions.keys.include?(piece.id)
      end
      pieces
    end

    # Generate game.board (coord hash) & fill w pieces
    def self.init_board(game)
      game.board = generate_board
      pieces = game.white.pieces + game.black.pieces
      add_pieces_to_board(game.board, pieces)
      game 
    end

    # Return hash of all moves given current state of game board 
    def self.get_moves(game)
      # keys: piece names; 
      # values: array of available moves
      all_moves = {}
      [game.white, game.black].each do |player|
        player.pieces.each do |piece|
          all_moves[piece.name] = []
          game.board.each do |tile, content|
            if Chess::Piece.possible_move?(tile, game.board, piece)
              all_moves[piece.name] << tile.to_s  
            end
          end
        end
      end
      all_moves      
    end

    # Accept move and update board and pieces accordingly
    def self.process_move(game, move)
      start, destination = move.split(",")
      
      # Select piece and empty starting position
      piece = game.board[start.to_sym]
      game.board[start.to_sym] = ""

      process_castling(game, start, destination)
      process_en_passant(game, start, destination)
      process_capturing(game, start, destination)
      process_move(game, start, destination)
      process_promotion(game, start, destination)

      # game, white, and black must be saved (autosaving in place)
      game
    end

    # Private
    
    class << self
    
      # Startup helpers
      def starting_positions(pieces, color)
        positions = Piece.positions[color.to_sym]
        return map_piece_positions(pieces, positions)
      end   

      def map_piece_positions(pieces, positions)
        mapped_positions = {}
        pieces.map do |piece|
          position = ""
          case piece.type
          when "Rook"
            position = positions[:rooks].delete_at(0)
          when "Knight"
            position = positions[:knights].delete_at(0)
          when "Bishop"
            position = positions[:bishops].delete_at(0)
          when "King"
            position = positions[:king].delete_at(0)
          when "Queen"
            position = positions[:queen].delete_at(0)
          when "Pawn"
            position = positions[:pawns].delete_at(0)
          end
          mapped_positions[piece.id] = position
        end
        mapped_positions
      end

      def generate_board
        board = {}
        8.downto(1).each do |number|
          fill_row(number, board)
        end
        board
      end

      def fill_row(num, board)
        letters=("a".."h")
        letters.to_a.each do |letter|
          board[(letter + num.to_s).to_sym] = ""
        end
      end

      def add_pieces_to_board(board, pieces)
        pieces.each do |piece|
        position = piece.position.to_sym
        if board.keys.include?(position) 
            board[position] = piece
          end
        end
      end

      # Move helpers
      def process_castling(game, start, destination)
        
      end

      def process_en_passant(game, start, destination)
      end

      def process_capturing(game, start, destination)
      end

      def process_move(game, start, destination)
      end

      def process_promotion(game, start, destination)
      end


      # Helper helpers
      
      # Return false or array of left/right castelable opportunities
      def castleable?(game)
        castleable = []
        king = current_player(game).pieces.where(type: "King").take
        rooks = current_player(game).pieces.where(type: "Rook").to_a
        left_rook = rooks.select{ |r| r if r.position == "a8" || r.position == "a1" }[0]
        right_rook = rooks.select{ |r| r if r.position == "h8" || r.position == "h1" }[0]
        rooks.each { |rook| rooks.delete(rook) if rook.has_moved }

        if current_player(game) == game.white
          left_side = game.board.keys.select{ |t| game.board[t] if t == :d1 || t == :c1 || t == :b1 }
          right_side = game.board.keys.select{ |t| game.board[t] if t == :f1 || t == :g1 }     
        else 
          left_side = game.board.keys.select{ |t| game.board[t] if t == :d8 || t == :c8 || t == :b8 }
          right_side = game.board.keys.select{ |t| game.board[t] if t == :f8 || t == :g8 }  
        end

        case
        when king.has_moved || rooks.length == 0
          return false
        when left_side.any?{ |t| game.board[t] != "" } && right_side.any?{ |t| game.board[t] != "" }
          return false
        when rooks.length == 1
          if left_side.all?{ |t| game.board[t] != "" } && left_rook.has_moved == false
            castleable[0] = true
            castleable[1] = false 
          end
          if right_side.all?{ |t| game.board[t] != "" } && right_rook.has_moved == false
            castleable[0] ||= false 
            castleable[1] = true 
          end
        when rooks.length == 2
          castleable[0] = left_side.all?{ |t| game.board[t] != "" } ? true : false
          castleable[1] = right_side.all?{ |t| game.board[t] != "" } ? true : false
        else
          return false
        end

        if castleable == [] || castleable.nil?
          return false
        else
          return castleable
        end
      end # End castleable?

      # General helpers
      def current_player(game)
        return [game.white, game.black].select { |p| p if p.is_playing }[0]
      end

    end
  end

end