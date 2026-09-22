class AddForeignKeys < ActiveRecord::Migration[8.0]
  def change
    add_index :bikes, :customer_id
    add_foreign_key :bikes, :customers

    add_index :repairs, :bike_id
    add_foreign_key :repairs, :bikes

    add_index :repairs, :customer_id
    add_foreign_key :repairs, :customers

    add_index :repairs, :staff_member_id
    add_foreign_key :repairs, :staff_members

    add_index :repair_services, :repair_id
    add_foreign_key :repair_services, :repairs

    add_index :repair_services, :service_id
    add_foreign_key :repair_services, :services
  end
end