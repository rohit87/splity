class CreateUserActivitiesMapping < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.integer :user_id
      t.integer :activity_id
      t.float :amount_paid
      t.float :amount_owed
      t.integer :amount_owed_to
      t.timestamps
    end
    add_index :participations, :user_id
    add_index :participations, :activity_id
    add_index :participations, [:user_id, :activity_id], unique: true
    end
end
