class History < ApplicationRecord
	include AASM

	belongs_to :owner, class_name: 'Person'
	belongs_to :requester, class_name: 'Person'

	validates :name, presence: true
	validates :status, presence: true
	validates :points, inclusion: { in: [1, 2, 3, 5, 8, 13],
    message: "%{value} is not a valid point" }

	aasm column: 'status' do
		state :pending, initial: true
		state :started
		state :delivered
		state :accepted

		event :starting do
			transitions from: :pending, to: :started
		end

		event :delivering do
			transitions from: :started, to: :delivered
		end

		event :accepting do
			transitions from: :delivered, to: :accepted
		end

		event :rollback do
			transitions from: [:started, :delivered, :accepted], to: :pending
		end
	end
end
