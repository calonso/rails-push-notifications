
FactoryGirl.define do
  factory :apns_notification, class: 'RailsPushNotifications::Notification' do
    association   :app, factory: :apns_app, strategy: :create
    data          a: 1
    destinations  ['1']
  end
end
