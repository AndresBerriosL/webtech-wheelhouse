class AddDiagnosisToRepairs < ActiveRecord::Migration[8.0]
  def change
    add_column :repairs, :diagnosis, :text
  end
end
