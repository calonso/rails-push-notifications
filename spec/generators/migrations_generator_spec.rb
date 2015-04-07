require 'generators/rails-push-notifications/migrations_generator'

describe RailsPushNotifications::Generators::MigrationsGenerator, type: :generator do
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
          migration 'create_rails_push_notifications_apps'
        end
      end
    }
  end
end
