class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, null: false, default: ''
      t.boolean :opened, default: true
      t.integer :sort, default: 0
      t.integer :pid, index: true

      t.timestamps null: false
    end
    add_index :categories, :sort
  end
end
