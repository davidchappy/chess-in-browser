module Chess

  class Game
    include PieceMethods

    def self.describe_pieces
      chess_piece.generate_pieces_definitions
    end

    # Generate and return a board hash
    def self.describe_board
      chess_board.generate_board_definition
    end

    # Return hash of all moves for a player given current state of game board 
    def self.get_moves(game, last_move=nil)
      # keys: piece names
      # values: nested hash of available moves
      all_moves = {}

      if game.status == 'check'
        all_moves = chess_piece.get_check_moves(game, last_move)
      else 
        all_moves = chess_piece.get_piece_moves(game)
      end 

      get_castle_moves(game, all_moves)
      all_moves      
    end

    # Accept move and update board and pieces accordingly
    def self.update_board(game, move)
      new_board = game.board.clone
      # move is a hash ( from => from_tile, to => to_tile, flags => flags )
      from  = move["from"]
      to    = move["to"]
      flags = move["flags"].flatten if move["flags"]     
      piece = game.find_on_board(from)

      # evaluate scenarios
      case 
      when flags.nil? || flags.empty? || flags == "" || flags == [""]
      when flags.include?("check")
        game.status = ("check")
      when flags.include?("castling")
        castle(to, piece, new_board)
      when flags.include?("en_passant")
        en_passant(to, piece, new_board, game)
      when flags.include?("promotion")
        game.status = "promoting"
      end

      # always move piece 
      move(new_board, piece, to)

      game.board = new_board
      game
    end

    # Assign board's piece positions to player's pieces and return pieces
    def self.update_pieces(game)
      board  = game.board

      game.pieces.each do |piece|
        if !board.values.include?(piece.id)
          piece.position = 'captured'
        else 
          board_position = game.position_by_id(piece.id)
          if(board_position && piece.position != board_position)
            piece.has_moved = true
            piece.position = board_position
          end
        end
      end
      game.pieces
    end

    # Private
    
    class << self
      def get_castle_moves(game, all_moves)
        castle_moves = chess_board.castle_moves(game)
        if castle_moves != {}
          king_name = castle_moves.first[0]
          all_moves[king_name].merge!(castle_moves.first[1])
        end
        all_moves
      end 

      # Move helpers
      def castle(to, piece, board)
        king = piece
        case king.color
        when 'white'
          board[:e1] = ""
          if to == 'g1'
            rook_id = board[:h1]
            board[:h1] = ""
            board[:f1] = rook_id
            board[:g1] = king.id
          elsif to == 'c1'
            rook_id = board[:a1]
            board[:a1] = ""
            board[:d1] = rook_id
            board[:c1] = king.id
          end
        when 'black'
          board[:e8] = ""
          if to == 'g8'
            rook_id = board[:h8]
            board[:h8] = ""
            board[:f8] = rook_id
            board[:g8] = king.id
          elsif to == 'c8'
            rook_id = board[:a8]
            board[:a8] = ""
            board[:d8] = rook_id
            board[:c8] = king.id
          end
        end
      end

      def en_passant(to, piece, board, game)
        board[to.to_sym] = piece.id
        board[piece.position.to_sym] = ""
        target = chess_board.check_en_passant(piece, game)
        board[target.to_sym] = "" 
      end

      def move(board, piece, to)
        board[piece.position.to_sym] = ""
        board[to.to_sym] = piece.id
        # piece position is not changed here but in .update_pieces
      end

      def chess_piece
        Chess::Piece.new
      end

      def chess_board
        Chess::Board.new
      end

      def current_player(game)
        return [game.white, game.black].select { |p| p if p.is_playing }[0]
      end

    end
  end

end # end Chess module