class Person < ApplicationRecord
	has_many :projects, dependent: :destroy, foreign_key: 'manager_id'
	has_many :histories, dependent: :destroy, foreign_key: 'requester_id'

	validates :email, presence: true, uniqueness: true, email_format: { :message => 'is not looking good' }
	validates :name, presence: true
	validates :role, presence: true
end
