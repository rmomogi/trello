# frozen_string_literal: true

FactoryBot.define do
  factory :history do
    name { "History" }
    points { 1 }
    description { "Description" }
    association :owner, factory: :person
    association :requester, factory: :person
  end
end
