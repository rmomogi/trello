# frozen_string_literal: true

class Project < ApplicationRecord
  belongs_to :manager, class_name: 'Person'
  has_many :histories
  validates :name, presence: true
end
