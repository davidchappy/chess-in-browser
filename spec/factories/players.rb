FactoryGirl.define do
  password = Faker::Internet.password
  factory :player do
    name { Faker::Name.name }
    email { Faker::Internet.unique + ((1..1000).to_a).sample.email }
    password { password }
    password_confirmation { password }
  end
end