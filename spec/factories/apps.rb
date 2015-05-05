
FactoryGirl.define do
  factory :apns_app, class: 'RailsPushNotifications::APNSApp' do
    apns_dev_cert   'abc'
    apns_prod_cert  'def'
    sandbox_mode    true
  end

  factory :gcm_app, class: 'RailsPushNotifications::GCMApp' do
    gcm_key   'abc123def456'
  end
end
