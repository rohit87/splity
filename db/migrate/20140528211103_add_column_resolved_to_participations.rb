class AddColumnResolvedToParticipations < ActiveRecord::Migration
  def change
    add_column :participations, :resolved, :boolean, null: false, default: false
  end
end
