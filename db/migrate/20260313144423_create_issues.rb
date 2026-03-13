class CreateIssues < ActiveRecord::Migration[7.1]
  def change
    create_table :issues do |t|
      t.string :subject
      t.text :description
      t.string :status
      t.string :priority
      t.string :severity
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
