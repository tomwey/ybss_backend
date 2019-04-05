class AddDeleteReasonAndDeleteMemoToDailyChecks < ActiveRecord::Migration
  def change
    add_column :daily_checks, :delete_reason, :string
    add_column :daily_checks, :delete_memo, :string
  end
end
