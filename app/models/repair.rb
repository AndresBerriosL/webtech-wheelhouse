class Repair < ApplicationRecord
    belongs_to :bike
    belongs_to :customer
    belongs_to :staff_member, optional: true

    has_many :repair_services
end