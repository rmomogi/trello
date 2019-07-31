# frozen_string_literal: true

require 'rails_helper'

RSpec.describe History, type: :model do
  let(:project) { build(:project) }
  let(:history) { build(:history, project: project) }

  describe '#associations' do
    it { is_expected.to belong_to :owner }
    it { is_expected.to belong_to :requester }
    it { is_expected.to have_many :tasks }
  end

  describe '#validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :status }
    it do
      [1, 2, 3, 5, 8, 13].each do |number|
        history.points = number
        expect(history.valid?).to be_truthy
      end
    end

    context 'validate finished_at' do
      before do
        history.starting
        history.finished_at = DateTime.now - 3.days
      end

      it { expect(history.valid?).to be_falsey }
    end

    context '#done_tasks' do
      context 'does when tasks done' do
        before { history.tasks << build_list(:task, 3, :done) }
        it { expect(history.valid?).to be_truthy }
      end

      context 'does when tasks not done' do
        before do
          history.status = 'done'
          history.tasks << build_list(:task, 3)
        end
        it { expect(history.valid?).to be_falsey }
      end
    end
  end

  describe '#status' do
    it { expect(history).to have_state(:pending) }
    it { expect(history).to transition_from(:pending).to(:started).on_event(:starting) }
    it { expect(history).to transition_from(:started).to(:delivered).on_event(:delivering) }
    it { expect(history).to transition_from(:delivered).to(:done).on_event(:donning) }

    it { expect(history).to transition_from(:delivered).to(:pending).on_event(:rollback) }
    it { expect(history).to transition_from(:started).to(:pending).on_event(:rollback) }
    it { expect(history).to transition_from(:done).to(:pending).on_event(:rollback) }

    context '#starting' do
      before { history.starting }

      it { expect(history).to have_state(:started) }
    end

    context '#delivering' do
      before do
        history.starting
        history.delivering
      end

      it { expect(history).to have_state(:delivered) }
    end

    context '#done' do
      before do
        history.starting
        history.delivering
        history.donning
      end

      it { expect(history).to have_state(:done) }
    end
  end
end
