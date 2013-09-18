
FactoryGirl.define do
  factory :apns_config, class: 'Rpn::ApnsConfig' do
    apns_dev_cert 'Cert dummy text'
    apns_prod_cert 'Cert dummy text'
  end
end
