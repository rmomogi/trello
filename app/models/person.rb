class Person < ApplicationRecord
	validates :email, presence: true, email: true
end
