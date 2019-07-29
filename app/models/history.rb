# frozen_string_literal: true

class History < ApplicationRecord
  include AASM

  has_paper_trail

  belongs_to :owner, class_name: 'Person'
  belongs_to :requester, class_name: 'Person'
  has_many :tasks

  validates :name, presence: true
  validates :status, presence: true
  validates :points, inclusion: { in: [1, 2, 3, 5, 8, 13],
                                  message: "%{value} is not a valid point" }

  validate :done_tasks
  validate :started_after_finished

  aasm column: 'status' do
    state :pending, initial: true
    state :started
    state :delivered
    state :done

    event :starting, after: :start_history do
      transitions from: :pending, to: :started
    end

    event :delivering do
      transitions from: :started, to: :delivered
    end

    event :doning, after: :finish_history do
      transitions from: :delivered, to: :done
    end

    event :rollback, after: :rollback_pending do
      transitions from: [:started, :delivered, :done], to: :pending
    end
  end

  private

  def done_tasks
    if tasks.map(&:done).uniq.include? false
      errors.add(:tasks, 'not done')
    end
  end

  def started_after_finished
    return if finished_at.blank? || started_at.blank?

    if finished_at < started_at
      errors.add(:finished_at, "must be after the start date")
    end
  end

  def rollback_pending
    self.finished_at = nil
    self.started_at = nil
  end

  def start_history
    self.started_at = DateTime.current
  end

  def finish_history
    self.finished_at = DateTime.current
  end
end
