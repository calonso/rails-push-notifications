
module RailsPushNotifications
  describe Notification, type: :model do

    let(:notification) { build :notification }

    describe 'app relationship' do
      it 'requires an app' do
        notification.app = nil
        expect(notification).to_not be_valid
      end

      it 'belongs to an app' do
        expect(notification.app).to be_a APNSApp
      end
    end

    describe 'data' do
      it 'requires data' do
        notification.data = nil
        expect(notification).to_not be_valid
      end

      it 'has to be a Hash' do
        expect do
          notification.data = 'dummy text'
        end.to raise_error ActiveRecord::SerializationTypeMismatch
      end
    end

    describe 'destinations' do
      it 'requires destinations' do
        notification.destinations = nil
        expect(notification).to_not be_valid
      end

      it 'has to be an array' do
        expect do
          notification.destinations = 'dummy destinations'
        end.to raise_error ActiveRecord::SerializationTypeMismatch
      end

      it 'has to contain at least one destination' do
        notification.destinations = []
        expect(notification).to_not be_valid
      end
    end

    describe 'sent' do
      it 'is false by default' do
        notification.save
        expect(notification.sent).to eq false
      end
    end
  end
end
