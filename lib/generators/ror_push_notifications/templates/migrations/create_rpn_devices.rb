class CreateRpnDevices < ActiveRecord::Migration
  def change
    create_table :rpn_devices do |t|
      t.string :guid
      t.integer :config_id
      t.string :config_type

      t.timestamps
    end

    add_index :rpn_devices, [:config_id, :config_type]
  end
end
