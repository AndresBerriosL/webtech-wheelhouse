class Bike < ApplicationRecord
  belongs_to :customer

  has_many :repairs, dependent: :restrict_with_error

  validates :customer_id, :make, :model, :colour, :serial_number, presence: true
  validates :serial_number, uniqueness: true

  before_validation :normalize_serial_number

  scope :by_identity, -> { order(:make, :model, :serial_number) }

  private

  def normalize_serial_number
    self.serial_number = serial_number.strip.upcase if serial_number.present?
  end
end