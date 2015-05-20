
module RailsPushNotifications
  describe Notification, type: :model do

    let(:notification) { build :apns_notification }

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

      it 'is sent if results assigned' do
        notification.save
        expect do
          notification.results = 'abc'
          notification.save
        end.to change { notification.reload.sent }.from(false).to true
      end
    end

    describe 'results' do
      it 'serializes any object' do
        class Test
          attr_reader :value1, :value2, :success, :failed

          def initialize(value1, value2)
            @value1 = value1
            @value2 = value2
            @success = 10
            @failed = 2
          end

          def ==(other)
            other != nil && other.is_a?(Test) &&
            @value1 == other.value1 && @value2 == other.value2 || super(other)
          end
        end

        notification.results = Test.new('abc', 123)
        notification.save
        notification.reload
        expect(notification.results).to eq Test.new('abc', 123)
        expect(notification.success).to eq 10
        expect(notification.failed).to eq 2
      end
    end
  end
end
