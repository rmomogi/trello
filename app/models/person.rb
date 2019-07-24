class Person < ApplicationRecord
	has_many :projects, dependent: :destroy
	has_many :histories, dependent: :destroy

	validates :email, presence: true, uniqueness: true, email_format: { :message => 'is not looking good' }
	validates :name, presence: true
	validates :role, presence: true
end
