
module RailsPushNotifications
  describe Notification, type: :model do

    class FakeResults
      attr_reader :value1, :success, :failed

      def initialize(value1, success, failed)
        @value1 = value1
        @success = success
        @failed = failed
      end

      def ==(other)
        other != nil && other.is_a?(FakeResults) &&
        @value1 == other.value1 && @success == other.success &&
        @failed == failed || super(other)
      end
    end

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
          notification.save
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
          notification.save
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
          notification.results = FakeResults.new(1, 2, 3)
          notification.save
        end.to change { notification.reload.sent }.from(false).to true
      end
    end

    describe 'results' do

      let(:success) { 1 }
      let(:failed) { 3 }
      let(:results) { FakeResults.new 'abc', success, failed }

      it 'serializes any object' do
        notification.results = results
        notification.save
        notification.reload
        expect(notification.results).to eq results
        expect(notification.success).to eq success
        expect(notification.failed).to eq failed
      end
    end
  end
end
