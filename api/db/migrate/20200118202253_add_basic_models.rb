class AddBasicModels < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.string :channel_id
      t.string :url, null: false
      t.string :title
      t.string :thumbnail_url
      t.text :description
      t.integer :video_count
      t.integer :keep
      t.timestamps
    end

    create_table :videos do |t|
      t.integer :subscription_id
      t.string :video_id
      t.timestamp :published_at
      t.string :title
      t.string :thumbnail_url
      t.string :file_name
      t.text :description
      t.integer :duration
      t.boolean :to_download, null: false, default: false
      t.boolean :downloaded, null: false, default: false
      t.timestamps
    end
  end
end
