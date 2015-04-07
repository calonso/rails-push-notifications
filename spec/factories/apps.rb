
FactoryGirl.define do
  factory :apns_app, class: 'RailsPushNotifications::APNSApp' do
    apns_dev_cert   'abc'
    apns_prod_cert  'def'
    sandbox_mode    true
  end
end
