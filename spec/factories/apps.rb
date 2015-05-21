FactoryGirl.define do
  factory :apns_app, class: 'RailsPushNotifications::APNSApp' do
    apns_dev_cert  'abc'
    apns_prod_cert 'def'
    sandbox_mode   true
  end

  factory :gcm_app, class: 'RailsPushNotifications::GCMApp' do
    gcm_key 'abc123def456'
  end

  factory :mpns_app, class: 'RailsPushNotifications::MPNSApp' do
    cert 'abc'
  end
end
