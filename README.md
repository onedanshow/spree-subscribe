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


Version 0.2 To-Do
-------

* Create Spree::Admin::SubscriptionsController and views for edit, update, and destroy actions

Future To-Do
-------

* Update Product#show javascript to show subscription price when subscription interval is selected
* Create Spree::SubscriptionsController and views for edit and update actions for the customer
* Email customers when a re-order is shipped?
* Extend Spree API to handle subscriptions?
* Move Intervalable#time_title to a helper so can use time_unit_symbol to pull from localization
* Extend Spree::Admin::SubscriptionsController to include filtering and sorting
* For a reorder, if a shipping method is no longer available, select the cheapest.

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test_app
    $ bundle exec rspec spec

Copyright (c) 2013 Daniel Dixon, released under the New BSD License
