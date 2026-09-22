class Service < ApplicationRecord
  has_many :repair_services, dependent: :restrict_with_error

  has_many :repairs,
           through: :repair_services,
           dependent: :restrict_with_error

  validates :name, :current_price, presence: true
  validates :name, uniqueness: true
  validates :current_price, numericality: { greater_than: 0 }

  scope :by_name, -> { order(:name) }
end