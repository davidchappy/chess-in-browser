class GameSerializer < ActiveModel::Serializer
  attributes :id, :status, :created_at, :updated_at, :time_elapsed

  has_one :black
  has_one :white
end
