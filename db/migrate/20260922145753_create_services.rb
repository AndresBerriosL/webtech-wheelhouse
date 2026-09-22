class CreateServices < ActiveRecord::Migration[8.0]
  def change
    create_table :services do |t|
      t.string :name, null: false
      t.decimal :current_price, precision: 10, scale: 2, null: false

      t.timestamps null: false
    end

    add_index :services, :name, unique: true
  end
end