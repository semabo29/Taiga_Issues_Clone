class AddDueDateToIssues < ActiveRecord::Migration[7.1]
  def change
    add_column :issues, :due_date, :datetime
  end
end
