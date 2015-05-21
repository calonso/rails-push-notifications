
FactoryGirl.define do
  factory :apns_notification, class: 'RailsPushNotifications::Notification' do
    association   :app, factory: :apns_app, strategy: :create
    data          a: 1
    destinations  ['1']
  end

  factory :gcm_notification, class: 'RailsPushNotifications::Notification' do
    association   :app, factory: :gcm_app, strategy: :create
    data          a: 1
    destinations  ['1']
  end

  factory :mpns_notification, class: 'RailsPushNotifications::Notification' do
    association   :app, factory: :mpns_app, strategy: :create
    data          message: { value1: 'hello' }
    destinations  ['http://s.notify.live.net/1']
  end
end
