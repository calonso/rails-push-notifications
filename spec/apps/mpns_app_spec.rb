module RailsPushNotifications
  describe MPNSApp, type: :model do

    it 'creates an instance given valid attributes' do
      MPNSApp.create! attributes_for :mpns_app
    end

    describe 'validations' do

      let(:app) { build :mpns_app }

      it 'requires the certificate' do
        app.cert = nil
        expect(app).to_not be_valid
      end
    end

    describe 'notifications relationship' do

      let(:app) { create :mpns_app }

      it 'can create new notifications' do
        expect do
          app.notifications.create attributes_for :mpns_notification
        end.to change { app.reload.notifications.count }.from(0).to 1
      end
    end

    describe '#push_notifications' do

      let(:app) { create :mpns_app }
      let(:notifications) {
        (1..10).map { create :mpns_notification, app: app }
      }
      let(:single_notification) { create :mpns_notification, app: app }

      let(:headers) {
          {
            'x-notificationstatus' => 'Received',
            'x-deviceconnectionstatus' => 'Connected',
            'x-subscriptionstatus' => 'Active'
          }
        }
      let(:response) { [ { device_url: 'http://s.notify.live.net/1', headers: headers, code: 200 } ]}

      before do
        stub_request(:post, %r{s.notify.live.net}).
            to_return status: [200, 'OK'], headers: headers
      end

      it 'assigns results' do
        expect do
          app.push_notifications
        end.to change { notifications.map { |n| n.reload.results } }.from([nil] * 10).to([RubyPushNotifications::MPNS::MPNSResponse.new(response)] * 10)
      end

      it 'marks as sent' do
        expect do
          app.push_notifications
        end.to change { single_notification.reload.sent }.from(false).to true
      end

      context 'with an already sent notification' do
        let!(:sent_notification) { create :mpns_notification, app: app }

        before { app.push_notifications }

        it "doesn't send already sent notifications" do
          expect(RubyPushNotifications::MPNS::MPNSConnection).to_not receive(:post)
          app.push_notifications
        end
      end
    end
  end
end
