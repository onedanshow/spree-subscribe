[![Build Status](https://travis-ci.org/onedanshow/spree-subscribe.png)](https://travis-ci.org/onedanshow/spree-subscribe)
[![Code Climate](https://codeclimate.com/github/onedanshow/spree-subscribe.png)](https://codeclimate.com/github/onedanshow/spree-subscribe)

**This extension is not production ready.**

SpreeSubscribe
==============

A Spree extension for allowing customer to subscribe to a product(s), have it periodically sent to him/her, and manage that subscription.


Installation
-------

Add this to your Gemfile

    gem "spree_subscribe", github: "onedanshow/spree_subscribe"

Setup a cron job to run this rake task every night

    rake spree_subscribe:reorders:create


Developer To-Do
-------

* Allow subscriptions to be suspended / resumed using Spree::SubscriptionsController and views using destroy action
* Add subscription price to variants so that customes save money
* Create Spree::Admin::SubscriptionsController and views for edit, update, and destroy actions
* Deface admin product and variant forms with additional fields

Future To-Do
-------

* Create Spree::SubscriptionsController and views for edit and update actions

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test_app
    $ bundle exec rspec spec

Copyright (c) 2013 Daniel Dixon, released under the New BSD License
