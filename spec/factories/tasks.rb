# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    description { "Description" }
    association :history, factory: :history
    done { false }
  end

  trait :done do
    done { true }
  end
end
