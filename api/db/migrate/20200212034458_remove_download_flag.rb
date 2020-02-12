class RemoveDownloadFlag < ActiveRecord::Migration[6.0]
  def change
    remove_column :videos, :downloaded
  end
end
