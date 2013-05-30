class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :user_id
      t.string :title
      t.text :content
      t.integer :rating, :default => 0

      t.timestamps
    end
  end
end
