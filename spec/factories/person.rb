FactoryBot.define do
  factory :person do
    name  { Faker::Name.name }
    email { Faker::Internet.email }
    role  { 'admin' }
  end

  trait :project_default do

  end
end
