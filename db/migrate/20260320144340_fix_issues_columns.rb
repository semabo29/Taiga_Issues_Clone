class FixIssuesColumns < ActiveRecord::Migration[7.1]
  def change
    # Eliminamos las columnas de texto antiguas
    remove_column :issues, :status, :string
    remove_column :issues, :priority, :string
    remove_column :issues, :severity, :string

    # Añadimos las nuevas columnas de relación (IDs)
    add_reference :issues, :status, foreign_key: true
    add_reference :issues, :priority, foreign_key: true
    add_reference :issues, :severity, foreign_key: true
    add_reference :issues, :issue_type, foreign_key: true
  end
end