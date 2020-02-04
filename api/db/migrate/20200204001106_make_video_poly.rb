class MakeVideoPoly < ActiveRecord::Migration[6.0]
  def change
    add_column :videos, :type, :string, default: 'YtVideo'
  end
end
