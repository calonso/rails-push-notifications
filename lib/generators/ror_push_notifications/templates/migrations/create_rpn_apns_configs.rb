class CreateRpnApnsConfigs < ActiveRecord::Migration
  def change
    create_table :rpn_apns_configs do |t|
      t.text :apns_dev_cert
      t.text :apns_prod_cert

      t.timestamps
    end
  end
end
