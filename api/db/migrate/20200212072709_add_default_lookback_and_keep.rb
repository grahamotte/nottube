class AddDefaultLookbackAndKeep < ActiveRecord::Migration[6.0]
  def change
    add_column :settings, :keep_count, :integer, default: 2, null: false
    add_column :settings, :look_back_count, :integer, default: 16, null: false
    remove_column :subscriptions, :keep_count
  end
end
