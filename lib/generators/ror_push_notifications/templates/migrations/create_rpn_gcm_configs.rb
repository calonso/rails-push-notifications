class CreateRpnGcmConfigs < ActiveRecord::Migration
  def change
    create_table :rpn_gcm_configs do |t|
      t.string :api_key

      t.timestamps
    end
  end
end
