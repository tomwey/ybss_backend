class AddDeleteReasonAndDeleteMemoToPropertyInfos < ActiveRecord::Migration
  def change
    add_column :property_infos, :delete_reason, :string
    add_column :property_infos, :delete_memo, :string
  end
end
