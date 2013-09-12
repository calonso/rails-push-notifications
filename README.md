# Rpn (Ruby on Rails Push Notifications)
## Professional iOS and Android push notifications for Ruby on Rails

Rpn is an intuitive and easy to use gem that will allow you to easily add both iOS and Android Push Notifications.

Rpn supports:

* Multiple Apple and Android applications/configurations
* Single and Bulk notifications
* Fully customizable notification's contents

## Installation
To install the gem simply add this line to your Gemfile

    gem 'ror_push_notifications', '= 1.0.0', git: 'git://github.com/calonso/ror-push-notifications'

and then install it by running

    $ bundle install

Once you have it installed, you need to generate the database migrations in order to build the required database structure and then run the newly generated migrations. So do it by executing:

    $ rails generate ror_push_notifications:migrations
    $ rake db:migrate

## Applications setup

First step when using Rpn is to setup Apple and/or Android applications to which the notifications will be associated to. Each platform has it's own details and process.

### Apple Applications setup

Once you have configured your app as Apple Push Notifications Service enabled and you have requested and downloaded both the development and production certificates, it's time to convert them to a readable format (.pem) to import them into Rpn afterwards.

To convert the certificates the first you need is to export them as .p12 files. To do this:

1. Open Keychain Application of your Macintosh computer
2. Find the recently generated certificates. Click the disclosure button on the left of your certificate and select both the certificate and the contained key
3. Right click and select 'Export 2 items...'. Then select the desired .p12 format and save it to your disk

Once exported, to convert it to the readable .pem format simply run:

    $ openssl pkcs12 -in <your .p12 filename> -out <your output .pem filename>.pem -nodes -clcerts

Now it's time to create our applications

    app = Rpn::ApnsConfig.new
    app.apns_dev_cert = File.read('path/to/your/development/certificate.pem')
    app.apns_prod_cert = File.read('path/to/your/production/certificate.pem')
    app.sandbox_mode = true
    app.save

And that's it!! You can create as many different applications as you want. Rpn gem supports it.

### Android Applications setup

The only thing you need is the API_KEY that you will get from the Google APIS Console > API Access

    app = Rpn::GcmConfig.new
    app.api_key = '<your app api key>'
    app.save

That's all. You have your applications' configurations stored in Rpn. Now it's time to start registering devices.

## Registering devices

Devices are associated to one single application.

    app = # Find your Apple or Android app
    app.devices.create guid: <iOS device token or Android registration id>

Simple, isnt't it?

## Creating notifications

### iOS Notifications

To create new iOS notifications is as simple as

    device = # Find your iOS device
    app = device.config
    alert = 'This is the alert message'
    badge = 1
    sound = 'true'
    payload = { a: 1, b: 2, c:3 }
    notification = Rpn::ApnsNotification.create_from_params! device, alert, badge, sound, payload
    # Then, send the notifications
    app.send_notifications

The generated notification will be something like this:

    { aps: {
        badge: 1,
        sound: 'true',
        alert: 'This is the alert message' },
      a: 1,
      b: 2,
      c: 3 }

### Android notifications

To create new Android notification the process is much the same as for the iOS ones:

    device = # Find your Android device
    app = device.config
    payload = { a: 1, b: 2, c: 3, message: 'This is the alert message' }
    notification = Rpn::GcmNotification.create_from_params! device, payload
    # Finally, send the notifications
    app.send_notifications

The generated Android notification will be something like this:

    { registration_ids: [<registration id of the device>],
      time_to_live: 2419200,
      data: {
        a: 1,
        b: 2,
        c: 3,
        message: 'This is the alert message'
      }
    }

### The Notifications Builder class

As you can see, much of the notification creation process is the same in both platforms, that's why I advice you to
create a builder like the one provided at libs/rpn/notifications_builder.rb. This is only a starting point, you can use
it as given or you may modify it to suit your needs.

Creating notifications with the builder is similar to the previous examples but you can abstract your code from the
notification type. Special iOS parameters such as badge and sound are assigned default 1 and 'true' values respectively.

    device = # Find your device
    app = device.config
    alert = 'This is the alert message'
    payload = { a: 1, b: 2, c:3 }
    notification = Rpn::NotificationsBuilder.create_notification! device, alert, payload
    # Then, send the notifications
    app.send_notifications

## Creating bulk notifications

Last but not least. Rpn gem is able to manage and send bulk notifications for both platforms in an easy way.

### iOS bulk notifications

    app = # Find your iOS application
    tokens = app.devices.collect(&:guid)
    alert = 'Alert message for bulk notification'
    badge = 1
    sound = 'true'
    payload = { a: 1, b: 2, c:3 }
    notification = Rpn::ApnsBulkNotification.create_from_params! tokens, app.id, alert, badge, sound, payload
    # Now send the notifications
    app.send_bulk_notifications

### Android bulk notifications

    app = # Find your iOS application
    tokens = app.devices.collect(&:guid)
    payload = { a: 1, b: 2, c: 3, message: 'Alert message for bulk notification' }
    notification = Rpn::GcmBulkNotification.create_from_params! tokens, app.id, payload
    # Now send the notifications
    app.send_bulk_notifications

### The Notifications Builder Class

Now again, to try to simplify even more the bulk notifications creation, a method is given in the Rpn::NotificationsBuilder class.
To create bulk notifications, regarding only at the devices where you want to push, simply do:

    devices = # Find your devices
    device_ids = devices.pluck(:id)
    alert = 'Alert message for bulk notification'
    payload = { a: 1, b: 2, c: 3 }
    Rpn::NotificationsBuilder.create_bulk_notification! device_ids, alert, payload

And that's all!! Of course, you should run the notifications delivery process in worker threads or something similar.

Released under the MIT-LICENSE.

