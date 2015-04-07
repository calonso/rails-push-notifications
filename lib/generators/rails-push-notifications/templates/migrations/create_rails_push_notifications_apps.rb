class CreateRailsPushNotificationsApps < ActiveRecord::Migration
  def self.up
    create_table :rails_push_notifications_apns_apps do |t|
      t.text :apns_dev_cert
      t.text :apns_prod_cert
      t.boolean :sandbox_mode

      t.timestamps
    end
  end
end
