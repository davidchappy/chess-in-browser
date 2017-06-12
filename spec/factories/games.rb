FactoryGirl.define do
  factory :game do
    black { Guest.create(name: Faker::Name.name) }
    white { Guest.create(name: Faker::Name.name) }
    black_type "Guest"
    white_type "Guest"
    status "starting"
  end
end