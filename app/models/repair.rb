class Repair < ApplicationRecord
  belongs_to :bike
  belongs_to :customer
  belongs_to :staff_member, optional: true

  has_many :repair_services, dependent: :destroy

  has_many :services,
           through: :repair_services,
           dependent: :destroy

  enum :state, {
    received: "received",
    diagnosed: "diagnosed",
    awaiting_approval: "awaiting_approval",
    approved: "approved",
    in_progress: "in_progress",
    ready_for_pickup: "ready_for_pickup",
    rejected: "rejected",
    picked_up: "picked_up"
  }

  validates :bike_id, :customer_id, :received_at, :promised_on, :state, presence: true

  validate :dates_make_sense
  validate :state_information_is_consistent

  scope :by_promised_date, -> {
    order(:promised_on, :received_at)
  }

  scope :open_repairs, -> {
    where(picked_up_at: nil)
  }

  scope :overdue, -> {
    open_repairs.where("promised_on < ?", Date.current)
  }

  def overdue?
    picked_up_at.nil? && promised_on.present? && promised_on < Date.current
  end

  def total
    repair_services.sum(&:charged_price)
  end

  private

  def dates_make_sense
    return if received_at.blank?

    if promised_on.present? && promised_on < received_at.to_date
      errors.add(
        :promised_on,
        "cannot be before the day the bike was received"
      )
    end

    if picked_up_at.present? && picked_up_at.to_date < received_at.to_date
      errors.add(
        :picked_up_at,
        "cannot be before the day the bike was received"
      )
    end
  end

  def state_information_is_consistent
    if picked_up?
      if picked_up_at.blank?
        errors.add(
          :picked_up_at,
          "must be recorded when the bike has been handed back"
        )
      end
    elsif picked_up_at.present?
      errors.add(
        :picked_up_at,
        "must be empty until the bike has been handed back"
      )
    end

    answered_state =
      approved? ||
      in_progress? ||
      ready_for_pickup? ||
      rejected? ||
      picked_up?

    if answered_state && customer_decision.blank?
      errors.add(
        :customer_decision,
        "must be recorded before the repair can be in this state"
      )
    end
  end
end