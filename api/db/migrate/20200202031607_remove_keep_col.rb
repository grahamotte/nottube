class RemoveKeepCol < ActiveRecord::Migration[6.0]
  def change
    remove_column :subscriptions, :keep
  end
end
