class SwitchNebulaToUserAndPass < ActiveRecord::Migration[6.0]
  def change
    remove_column :settings, :nebula_api_key
    add_column :settings, :nebula_user, :string
    add_column :settings, :nebula_pass, :string
    add_column :settings, :nebula_cache, :text
  end
end
