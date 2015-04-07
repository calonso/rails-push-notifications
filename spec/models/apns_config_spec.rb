
describe Rpn::ApnsConfig do

  def failing_response_for_index(i)
    [8, 8, i].pack 'ccN'
  end

  let(:ssl_socket) { double write: 1, flush: 1, close: 1 }

  before(:each) do
    allow(Rpn::ApnsConnection).to receive(:open).and_return ([ssl_socket, double(:close => 1)])
  end

  let(:app) { FactoryGirl.create :apns_config }

  describe 'managing single notifications' do
    let(:device) { FactoryGirl.create :apns_device, config: app }
    let!(:notification) { Rpn::ApnsNotification.create_from_params! device, 'alert', 1, 'true', {} }

    context 'successful push' do
      it 'pushes the notification' do
        IO.should_receive(:select).once
        ssl_socket.should_receive(:write).once
        ssl_socket.should_receive(:flush).once
        app.send_notifications
      end

      it 'marks the notification as sent' do
        IO.should_receive(:select).once
        expect do
          app.send_notifications
        end.to change { notification.reload.sent_at }.from(nil)
      end

      it 'saves the result code' do
        IO.should_receive(:select).once
        expect do
          app.send_notifications
        end.to change { notification.reload.error }.from(nil).to Rpn::ApnsNotification::NO_ERROR_STATUS_CODE.to_s
      end
    end
  end

  describe 'managing bulk notifications' do
    let(:tokens) { %w(a b c d e) }
    let(:notification) { Rpn::ApnsBulkNotification.create_from_params! tokens, app.id, 'alert', 1, 'true', {} }

    context 'successful push' do

      it 'works as expected' do
        IO.should_receive(:select).exactly(tokens.length).times
        ssl_socket.should_receive(:write).exactly(tokens.length).times
        ssl_socket.should_receive(:flush).once
        ssl_socket.should_receive(:close).once

        binaries = notification.binary_strings(0)
        result = app.send(:do_send_notifications, binaries)
        result.should == [Rpn::ApnsNotification::NO_ERROR_STATUS_CODE] * tokens.length
      end

    end

    context 'some failing pushes' do

      it 'works as expected' do
        allow(ssl_socket).to receive(:read).and_return(failing_response_for_index(1), failing_response_for_index(3))
        IO.should_receive(:select).exactly(tokens.length).times.and_return(nil, true, nil, true, nil)
        ssl_socket.should_receive(:write).exactly(tokens.length).times
        ssl_socket.should_receive(:flush).once
        ssl_socket.should_receive(:close).exactly(3).times
        Rpn::ApnsConnection.should_receive(:open).exactly(3).times

        binaries = notification.binary_strings(0)
        results = app.send(:do_send_notifications, binaries)
        results.should == [0, 8, 0, 8, 0]
      end

      it 'works successfully if first and last fail' do
        allow(ssl_socket).to receive(:read).and_return(failing_response_for_index(0), failing_response_for_index(4))
        IO.should_receive(:select).exactly(tokens.length).times.and_return(true, nil, nil, nil, true)
        ssl_socket.should_receive(:write).exactly(tokens.length).times
        ssl_socket.should_receive(:flush).once
        ssl_socket.should_receive(:close).exactly(2).times
        Rpn::ApnsConnection.should_receive(:open).exactly(2).times

        binaries = notification.binary_strings(0)
        results = app.send(:do_send_notifications, binaries)
        results.should == [8, 0, 0, 0, 8]
      end

    end
  end
end
