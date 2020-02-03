class MakeSubPolymorphic < ActiveRecord::Migration[6.0]
  def change
    rename_column :subscriptions, :channel_id, :remote_id
    add_column :subscriptions, :type, :string
  end
end
