require 'rails_helper'

RSpec.describe Person, type: :model do
	describe '#associations' do
		it { is_expected.to have_many(:projects).dependent(:destroy) }
		it { is_expected.to have_many(:histories).dependent(:destroy) }
	end

	describe '#validations' do
		it { is_expected.to validate_presence_of(:name) }
		it { is_expected.to validate_presence_of(:email) }
		it { is_expected.to validate_presence_of(:role) }
		it { is_expected.to allow_value('foo@bar.com').for(:email) }
    it { is_expected.not_to allow_value('foobar.com').for(:email) }

    context 'email uniqueness' do
    	subject { build(:person) }

      it { is_expected.to validate_uniqueness_of(:email) }
    end
	end
end
