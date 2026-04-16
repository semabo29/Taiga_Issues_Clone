class AddAssignedToToIssues < ActiveRecord::Migration[7.1]
  def change
    add_column :issues, :assigned_to_id, :integer
    add_index :issues, :assigned_to_id
    add_foreign_key :issues, :users, column: :assigned_to_id
  end
end