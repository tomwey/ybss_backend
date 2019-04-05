class AddDeleteReasonAndDeleteMemoToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :delete_reason, :string
    add_column :companies, :delete_memo, :string
  end
end
