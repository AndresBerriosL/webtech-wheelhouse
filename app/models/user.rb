
class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy

  belongs_to :staff_member, optional: true
  has_many :received_repairs,
           class_name: "Repair",
           foreign_key: :received_by_id,
           inverse_of: :received_by,
           dependent: :nullify

  enum :role, {
    counter: "counter",
    mechanic: "mechanic",
    owner: "owner"
  }, default: :counter

  normalizes :email_address,
             with: ->(email) { email.strip.downcase }

  validates :email_address,
            presence: true,
            format: {
              with: URI::MailTo::EMAIL_REGEXP
            },
            uniqueness: { case_sensitive: false }

  validates :password,
            length: {
              minimum: 10,
              message: "must contain at least 10 characters"
            },
            if: -> { password.present? }

  validates :role, presence: true

  def display_name
    staff_member&.name || email_address
  end
end
