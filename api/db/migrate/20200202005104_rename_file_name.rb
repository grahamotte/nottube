class RenameFileName < ActiveRecord::Migration[6.0]
  def change
    rename_column :videos, :file_name, :file_path
  end
end
