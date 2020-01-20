class AddRangesToSubs < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :keep_count, :integer, default: 8, null: false
    add_column :subscriptions, :look_back_count, :integer, default: 32, null: false
  end
end
