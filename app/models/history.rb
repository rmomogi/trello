# frozen_string_literal: true

class History < ApplicationRecord
  include AASM

  has_paper_trail

  belongs_to :owner, class_name: 'Person'
  belongs_to :requester, class_name: 'Person'
  belongs_to :project

  has_many :tasks

  validates :name, presence: true
  validates :status, presence: true
  validates :points, inclusion: { in: [1, 2, 3, 5, 8, 13],
                                  message: "%{value} is not a valid point" }

  validate :done_tasks
  validate :started_after_finished

  scope :pending, -> { where(status: 'pending').order(id: :desc) }
  scope :started, -> { where(status: 'started').order(id: :desc) }
  scope :delivered, -> { where(status: 'delivered').order(id: :desc) }
  scope :done, -> { where(status: 'done').order(id: :desc) }

  scope :by_project, ->(project_id) { where("project_id = ?", project_id) }

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

    event :donning, after: :finish_history do
      transitions from: :delivered, to: :done
    end

    event :rollback, after: :rollback_pending do
      transitions from: [:started, :delivered, :done], to: :pending
    end
  end

  def select_points
    [1, 2, 3, 5, 8, 13]
  end

  def next_state
    case status
    when 'pending'
      ['starting']
    when 'started'
      ['rollback', 'delivering']
    when 'delivered'
      ['rollback', 'donning']
    else
      ['rollback']
    end
  end

  private

  def done_tasks
    validate_tasks if status == 'done'
  end

  def validate_tasks
    if tasks.map(&:done).uniq.include? false
      errors.add(:tasks, 'não finalizadas')
    end
  end

  def started_after_finished
    return if finished_at.blank? || started_at.blank?
    errors.add(:finished_at, 'must be after the start date') if finished_at < started_at
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
