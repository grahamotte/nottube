class RenameVideoId < ActiveRecord::Migration[6.0]
  def change
    rename_column :videos, :video_id, :remote_id
  end
end
