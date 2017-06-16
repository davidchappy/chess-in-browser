module GameSpecHelpers

  include Warden::Test::Helpers

  def parse(serialized_field)
    YAML.load(serialized_field)
  end

end