module Serializer
  extend ActiveSupport::Concern

  included do
    helper_method :serialize
  end

  # Convenience methods for serializing models:
  def serialize(model, includes)
    response = []
    if model.methods.include?(:length)
      model.each do |instance|
        model_class = instance.class
        response << JSON.parse(model_class.find(instance.id).to_json(include: includes))
      end
    else
      model_class = model.class
      response = JSON.parse(model_class.find(model.id).to_json(include: includes))
    end
    response
  end
end