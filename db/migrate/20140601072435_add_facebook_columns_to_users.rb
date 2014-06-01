class AddFacebookColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string, default: "organic"
    add_column :users, :auth_token, :string
    add_column :users, :external_user_id, :string
    add_column :users, :image_url, :string
  end
end
