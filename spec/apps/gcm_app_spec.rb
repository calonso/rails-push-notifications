module RailsPushNotifications
  describe GCMApp, type: :model do

    it 'creates an instance given valid attributes' do
      GCMApp.create! attributes_for :gcm_app
    end

    describe 'validations' do

      let(:app) { build :gcm_app }

      it 'requires a gcm key' do
        app.gcm_key = nil
        expect(app).to_not be_valid
      end
    end

    describe 'notifications relationship' do

      let(:app) { create :gcm_app }

      it 'can create new notifications' do
        expect do
          app.notifications.create attributes_for :gcm_notification
        end.to change { app.reload.notifications.count }.from(0).to 1
      end
    end

    describe '#push_notifications' do

      let(:app) { create :gcm_app }
      let(:notifications) {
        (1..10).map { create :gcm_notification, app: app }
      }
      let(:single_notification) { create :gcm_notification, app: app }

      let(:response) { JSON.dump a: 1 }

      before do
        stub_request(:post, 'https://android.googleapis.com/gcm/send').
          to_return status: [200, 'OK'], body: response
      end

      it 'assigns results' do
        expect do
          app.push_notifications
        end.to change { notifications.map { |n| n.reload.results } }.from([nil] * 10).to([RubyPushNotifications::GCM::GCMResponse.new(200, response)] * 10)
      end

      it 'marks as sent' do
        expect do
          app.push_notifications
        end.to change { single_notification.reload.sent }.from(false).to true
      end

      context 'with an already sent notification' do
        let!(:sent_notification) { create :apns_notification, app: app }

        before { app.push_notifications }

        it "doesn't send already sent notifications" do
          expect(RubyPushNotifications::GCM::GCMConnection).to_not receive(:post)
          app.push_notifications
        end
      end
    end
  end
end
