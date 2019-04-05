class AddDeleteReasonAndDeleteMemoToPeople < ActiveRecord::Migration
  def change
    add_column :people, :delete_reason, :string
    add_column :people, :delete_memo, :string
  end
end
