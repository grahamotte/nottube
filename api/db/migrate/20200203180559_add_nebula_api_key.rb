class AddNebulaApiKey < ActiveRecord::Migration[6.0]
  def change
    add_column :settings, :nebula_api_key, :string
  end
end
