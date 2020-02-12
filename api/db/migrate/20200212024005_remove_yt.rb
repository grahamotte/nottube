class RemoveYt < ActiveRecord::Migration[6.0]
  def change
    remove_column :settings, :yt_api_key_a
    remove_column :settings, :yt_api_key_b
    remove_column :settings, :yt_api_key_c
  end
end
