class AddDeleteReasonAndDeleteMemoToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :delete_reason, :string
    add_column :employees, :delete_memo, :string
  end
end
