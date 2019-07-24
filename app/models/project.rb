class Project < ApplicationRecord
	belongs_to :manager, class_name: 'Person'
	validates :name, presence: true
end
