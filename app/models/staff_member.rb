class StaffMember < ApplicationRecord
  has_many :repairs, dependent: :nullify

  validates :name, :role, presence: true

  scope :by_name, -> { order(:name) }
end