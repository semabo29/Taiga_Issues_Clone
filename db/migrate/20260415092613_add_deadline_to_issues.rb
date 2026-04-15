class AddDeadlineToIssues < ActiveRecord::Migration[7.1]
  def change
    add_column :issues, :deadline, :date
  end
end
