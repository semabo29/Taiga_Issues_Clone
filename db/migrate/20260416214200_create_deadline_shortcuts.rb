class CreateDeadlineShortcuts < ActiveRecord::Migration[7.1]
  def change
    create_table :deadline_shortcuts do |t|
      t.string :name
      t.integer :offset_days

      t.timestamps
    end
  end
end
