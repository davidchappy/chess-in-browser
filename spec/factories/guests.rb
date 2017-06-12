FactoryGirl.define do
  factory :guest do
    name { Faker::Name.name }
  end
end