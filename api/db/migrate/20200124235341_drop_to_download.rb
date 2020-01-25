class DropToDownload < ActiveRecord::Migration[6.0]
  def change
    remove_column :videos, :to_download
    remove_column :subscriptions, :look_back_count
  end
end
