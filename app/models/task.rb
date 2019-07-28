class Task < ApplicationRecord
	belongs_to :history

	validates :description, presence: true
end
