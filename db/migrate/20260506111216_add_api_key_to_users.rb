class AddApiKeyToUsers < ActiveRecord::Migration[7.1]
  def change
    unless column_exists?(:users, :api_key)
      add_column :users, :api_key, :string
    end
  end
end