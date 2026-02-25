class Crew < ApplicationRecord
  belongs_to :leader, class_name: 'User'
  has_many :registrations
  has_many :members, through: :registrations, source: :user

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true

  before_validation :generate_unique_code, on: :create

  private

  def generate_unique_code
    self.code ||= SecureRandom.alphanumeric(8).upcase
  end
end
