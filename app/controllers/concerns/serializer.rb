module Serializer
  extend ActiveSupport::Concern

  included do
    helper_method :serialize
  end

  # Convenience methods for serializing models:
  def serialize(model_instance, includes = [])
    model = model_instance.class
    JSON.parse(model.find(model_instance.id).to_json(include: includes))
  end
end