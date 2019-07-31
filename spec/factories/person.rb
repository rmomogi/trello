# frozen_string_literal: true

FactoryBot.define do
  factory :person do
    name  { Faker::Name.name }
    email { Faker::Internet.email }
    role  { 'admin' }
    password { '123456789' }
  end

  trait :project_default do
  end
end
