class AddSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.string :yt_api_key
      t.string :videos_path
      t.timestamps
    end
  end
end
