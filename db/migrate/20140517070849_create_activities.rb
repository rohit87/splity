class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :event
      t.decimal :amount
      t.string :currency
      t.string :location

      t.timestamps
    end
  end
end
