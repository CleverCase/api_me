# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :label

      t.timestamps null: false
    end
  end
end
