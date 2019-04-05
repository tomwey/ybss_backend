class AddDeleteColumnsToHouses < ActiveRecord::Migration
  def change
    add_column :houses, :delete_reason, :string
    add_column :houses, :delete_memo, :string
    add_column :houses, :state, :integer, default: 0
  end
end
