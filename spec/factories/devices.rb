
FactoryGirl.define do
  sequence :apns_token do |n|
    "#{n}-#{n}-#{n}-#{n}"
  end

  factory :apns_device, class: 'Rpn::Device' do
    guid { generate :apns_token }
    association :config, factory: :apns_config
  end
end
