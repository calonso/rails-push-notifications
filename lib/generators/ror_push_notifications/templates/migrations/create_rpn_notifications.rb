class CreateRpnNotifications < ActiveRecord::Migration
  def change
    create_table :rpn_notifications do |t|
      t.string :type
      t.string :device_token
      t.integer :config_id
      t.string :config_type
      t.text :data
      t.string :error
      t.datetime :sent_at

      t.timestamps
    end
    add_index :rpn_notifications, :type
    add_index :rpn_notifications, [:config_id, :config_type]

    create_table :rpn_bulk_notifications do |t|
      t.string :type
      t.text :device_tokens
      t.integer :config_id
      t.string :config_type
      t.text :data
      t.integer :failed
      t.integer :succeeded
      t.datetime :sent_at

      t.timestamps
    end
    add_index :rpn_bulk_notifications, :type
    add_index :rpn_bulk_notifications, [:config_id, :config_type]

  end
end
