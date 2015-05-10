class CreateRailsPushNotificationsApps < ActiveRecord::Migration
  def self.up
    create_table :rails_push_notifications_apns_apps do |t|
      t.text :apns_dev_cert
      t.text :apns_prod_cert
      t.boolean :sandbox_mode, deafult: true

      t.timestamps null: false
    end

    create_table :rails_push_notifications_gcm_apps do |t|
      t.string :gcm_key

      t.timestamps null: false
    end

    create_table :rails_push_notifications_mpns_apps do |t|
      t.text :cert

      t.timestamps null: false
    end
  end
end
