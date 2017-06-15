require 'rails_helper'
include PieceMethods

RSpec.describe PieceMethods do
  let(:game) { create(:game) }
  let(:white) { game.white }
  let(:black) { game.black }

  describe '#rooks' do

    it "returns an array of Rooks" do
      expect(rooks(game).all? { |r| r.class == Rook  })
      expect(rooks(white).all? { |r| r.class == Rook })
      expect(rooks(black).all? { |r| r.class == Rook })
    end

  end

  describe '#knights' do

    it "returns an array of Knights" do
      expect(knights(game).all? { |r| r.class == Knight  })
      expect(knights(white).all? { |r| r.class == Knight })
      expect(knights(black).all? { |r| r.class == Knight })
    end

  end

  describe '#bishops' do

    it "returns an array of Bishops" do
      expect(bishops(game).all? { |r| r.class == Bishop  })
      expect(bishops(white).all? { |r| r.class == Bishop })
      expect(bishops(black).all? { |r| r.class == Bishop })
    end

  end

  describe '#kings' do

    it "returns an array of Kings" do
      expect(kings(game).all? { |r| r.class == King  })
      expect(kings(white).all? { |r| r.class == King })
      expect(kings(black).all? { |r| r.class == King })
    end

  end

  describe '#queens' do

    it "returns an array of Queens" do
      expect(queens(game).all? { |r| r.class == Queen  })
      expect(queens(white).all? { |r| r.class == Queen })
      expect(queens(black).all? { |r| r.class == Queen })
    end

  end

  describe '#pawns' do

    it "returns an array of Pawns" do
      expect(pawns(game).all? { |r| r.class == Pawn  })
      expect(pawns(white).all? { |r| r.class == Pawn })
      expect(pawns(black).all? { |r| r.class == Pawn })
    end

  end

end