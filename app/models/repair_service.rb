class RepairService < ApplicationRecord
  belongs_to :repair
  belongs_to :service

  validates :repair_id, :service_id, :charged_price, presence: true
  validates :charged_price, numericality: { greater_than: 0 }

  scope :by_service_name, -> {
    joins(:service).order("services.name ASC")
  }

  scope :newest_repair_first, -> {
    joins(:repair).order("repairs.received_at DESC")
  }
end