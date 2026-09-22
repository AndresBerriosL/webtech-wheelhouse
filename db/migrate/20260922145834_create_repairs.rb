class CreateRepairs < ActiveRecord::Migration[8.0]
  def change
    create_table :repairs do |t|
      t.bigint :bike_id, null: false
      t.bigint :customer_id, null: false
      t.bigint :staff_member_id

      t.datetime :received_at, null: false
      t.date :promised_on, null: false

      t.string :status, null: false, default: "received"

      t.datetime :quoted_at
      t.string :customer_decision
      t.datetime :picked_up_at

      t.timestamps null: false
    end
  end
end