# Rails Push Notifications
[![Build Status](https://travis-ci.org/calonso/rails-push-notifications.svg)](https://travis-ci.org/calonso/rails-push-notifications) [![Code Climate](https://codeclimate.com/github/calonso/rails-push-notifications/badges/gpa.svg)](https://codeclimate.com/github/calonso/rails-push-notifications) [![Test Coverage](https://codeclimate.com/github/calonso/rails-push-notifications/badges/coverage.svg)](https://codeclimate.com/github/calonso/rails-push-notifications/coverage)
## Professional iOS, Android and Windows Phone push notifications for Ruby on Rails

RailsPushNotifications is an intuitive and easy to use gem that will allow you to easily add Push Notifications to your project.

RailsPushNotifications key features:

* Multiple Apple/Android/WinPhone applications/configurations
* Single and Bulk notifications
* Fully customizable notification's contents
* Detailed feedback on each individual notification's push results.

## Live example

Want to try this gem live?

Browse [https://rails-push-notifications-test.herokuapp.com](https://rails-push-notifications-test.herokuapp.com) and play with it!
The source code for that project is here: [https://github.com/calonso/rails_push_notifications_test](https://github.com/calonso/rails_push_notifications_test)

## Installation
To install the gem simply add this line to your Gemfile

    gem 'rails-push-notifications', '~> 0.2.0'

and then install it by running

    $ bundle install

Once you have it installed, you need to generate the database migrations in order to build the required database structure and then run the newly generated migrations. So do it by executing:

    $ rails generate rails_push_notifications:migrations
    $ rake db:migrate

## Applications setup

First step when using RailsPushNotifications is to setup Apple/Android/WinPhone applications to which the notifications will be associated to. Each platform has it's own details and process.

### Apple Applications setup

Once you have configured your app as Apple Push Notifications Service enabled and you have requested and downloaded both the development and production certificates, it's time to convert them to a readable format (.pem) to import them into Rpn afterwards.

To convert the certificates the first thing you need to do is to export them as .p12 files. To do this:

1. Open Keychain Application of your Macintosh computer
2. Find the recently generated certificates. Click the disclosure button on the left of your certificate and select both the certificate and the contained key
3. Right click and select 'Export 2 items...'. Then select the desired .p12 format and save it to your disk

Once exported, to convert it to the readable .pem format simply run:

    $ openssl pkcs12 -in <your .p12 filename> -out <your output .pem filename>.pem -nodes -clcerts

Now it's time to create our applications

    app = RailsPushNotifications::APNSApp.new
    app.apns_dev_cert = File.read('path/to/your/development/certificate.pem')
    app.apns_prod_cert = File.read('path/to/your/production/certificate.pem')
    app.sandbox_mode = true
    app.save

And that's it!! You can create as many different applications as you want. RailsPushNotifications gem allows it.

### Android Applications setup

The only thing you need is the API_KEY that you will get from the Google APIS Console > API Access

    app = RailsPushNotifications::GCMApp.new
    app.gcm_key = '<your app api key>'
    app.save

That's all. You have your applications' configurations stored in RailsPushNotification.

### WindowsPhone Applications setup

This case is similar but even simpler than APNS Apps

    app = RailsPushNotifications::MPNSApp.new
    app.cert = File.read('path/to/your/certificate.pem')
    app.save

## Creating notifications

The notifications interface is common to all kind of apps, but depending on the type of underlying app
the destinations and the data format will vary, so for example

### Apple notifications

    app = <Your Apple app>
    notification = app.notifications.create(
      destinations: [
        'Your first destination token',
        'Your second destination token'
      ],
      data: { aps: { alert: 'Hello APNS World!', sound: 'true', badge: 1 } }
    )

### GCM Notifications

    app = <Your GCM app>
    notification = app.notifications.create(
      destinations: [
        'Your first destination token',
        'Your second destination token'
      ],
      data: { message: 'Hello GCM World!' }
    )

### WindowsPhone Notifications

    app = <Your WindowsPhone app>
    notification = app.notifications.create(
      destinations: [
        'Your first destination url',
        'Your second destination url'
      ],
      data: { title: 'Title', message: 'Hello MPNS World!', type: :toast }
    )

## Pushing notifications

Eventually we want to actually push our notifications. For that task all the different apps
have a `push_notifications` method which will find the associated and not yet pushed notifications
and actually push them.

    app = <Your app>
    # Create several notifications for your app
    app.push_notifications

As this task can be potentially very time consuming you will probably want to invoke it in
a background worker

And that's all!! I hope you find this gem useful and please, feel free to contribute with
any improvement/bug you may find.

## Pending tasks

Please, feel free to contribute in building any of those or adding more stuff to this list!

* Better generation of the data for each kind of notification. Hiding the particulars
to avoid bugs.
* Rake task to push all notifications from all applications.

## Contributing

1. Fork it ( https://github.com/calonso/rails-push-notifications/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Released under the MIT-LICENSE.

