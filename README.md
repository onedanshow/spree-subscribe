**This extension is not production ready.**

SpreeSubscribe
==============

A Spree extension for allowing customer to subscribe to a product(s), have it periodically sent to him/her, and manage that subscription.


Developer ToDo
-------

* Create Spree::Subscription model, with has_many periods, belongs_to product, belongs_to user, has_many orders
* Create Spree::SubscriptionPeriod model, allowing admin to define time periods for subscription (i.e. one month, two months)
* Decorate Spree::Product to be subscribable (variant?), has_many subscriptions (variant?), has_many periods
* Decorate Spree::Variant to be subscribable, has_many subscriptions
* Decorate Spree::User with has_many subscriptions
* Decorate Spree::Order to belong_to subscription, maybe clone method?
* Create cron job for creating orders each night
* Decorate "My Account" views to show index of subscriptions
* Create Spree::SubscriptionsController and views for edit, update, and destroy actions


Example
-------

Example goes here.

Testing
-------

Be sure to bundle your dependencies and then create a dummy test app for the specs to run against.

    $ bundle
    $ bundle exec rake test_app
    $ bundle exec rspec spec

Copyright (c) 2013 Daniel Dixon, released under the New BSD License
