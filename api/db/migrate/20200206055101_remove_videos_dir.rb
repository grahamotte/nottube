class RemoveVideosDir < ActiveRecord::Migration[6.0]
  def change
    remove_column :settings, :videos_path
  end
end
