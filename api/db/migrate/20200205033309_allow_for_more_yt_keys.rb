class AllowForMoreYtKeys < ActiveRecord::Migration[6.0]
  def change
    rename_column :settings, :yt_api_key, :yt_api_key_a
    add_column :settings, :yt_api_key_b, :string
    add_column :settings, :yt_api_key_c, :string
  end
end
