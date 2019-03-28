class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :category_id
      t.string :cover
      t.string :title, null: false
      t.text :body
      t.string :body_url
      t.datetime :published_at
      t.datetime :deleted_at
      t.integer :sort, default: 0

      t.timestamps null: false
    end
    add_index :articles, :category_id
    add_index :articles, :sort
  end
end
