# frozen_string_literal: true

class Person < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :projects, dependent: :destroy, foreign_key: 'manager_id'
  has_many :histories, dependent: :destroy, foreign_key: 'requester_id'

  validates :email, presence: true, email_format: { message: 'is not looking good' }
  validates_uniqueness_of :email, case_insensitive: true
  validates :name, presence: true
  validates :role, presence: true
end
