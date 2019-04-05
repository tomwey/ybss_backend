class CreatePersonChecks < ActiveRecord::Migration
  def change
    create_table :person_checks do |t|
      t.integer :person_id
      t.string :check_status
      t.text :memo

      t.timestamps null: false
    end
    add_index :person_checks, :person_id
  end
end
