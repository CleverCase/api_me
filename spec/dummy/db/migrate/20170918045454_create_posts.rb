class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :name
      t.belongs_to :user, foreign_key: true
      t.timestamps null: false
    end
  end
end
