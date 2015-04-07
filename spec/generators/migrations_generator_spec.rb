require 'generators/ror_push_notifications/migrations_generator'

describe RorPushNotifications::Generators::MigrationsGenerator, type: :generator do
  destination File.expand_path("../tmp", __FILE__)

  before do
    prepare_destination
    run_generator
  end

  after do
    rm_rf destination_root
  end

  it 'creates the migrations' do
    expect(destination_root).to have_structure {
      directory 'db' do
        directory 'migrate' do
          migration 'create_rpn_configs'
          migration 'create_rpn_devices'
          migration 'create_rpn_notifications'
        end
      end
    }
  end
end
