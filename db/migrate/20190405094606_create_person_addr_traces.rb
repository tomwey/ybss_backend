class CreatePersonAddrTraces < ActiveRecord::Migration
  def change
    create_table :person_addr_traces do |t|
      t.integer :person_id
      t.string :address
      t.string :mgr_level
      t.string :cj_type
      t.string :cj_reason
      t.string :man_status
      t.text :memo

      t.timestamps null: false
    end
    add_index :person_addr_traces, :person_id
  end
end
