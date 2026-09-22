class RenameRepairStatusToState < ActiveRecord::Migration[8.0]
  def change
    rename_column :repairs, :status, :state
  end
end