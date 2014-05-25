class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.string :text
      t.string :link
      t.integer :type
      t.timestamps
    end
  end
end
