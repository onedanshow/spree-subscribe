**This extension is not production ready.**

SpreeSubscribe
==============

A Spree extension for allowing customer to subscribe to a product(s), have it periodically sent to him/her, and manage that subscription.


Developer ToDo
-------

* Create Spree::Subscription model, with belongs_to product, belongs_to user, has_many orders, started_at, belongs_to interval
* Create Spree::SubscriptionInterval model, allowing admin to define time periods for subscription (i.e. one month, two months)
* Decorate Spree::Product to be subscribable (variant?), has_many subscriptions (variant?), has_many intervals, subscription_price
* Decorate Spree::Variant to be subscribable, has_many subscriptions
* Decorate Spree::User with has_many subscriptions
* Decorate Spree::Order to belong_to subscription, maybe clone method?
* Create cron job for creating orders each night
* Decorate "My Account" views to show index of subscriptions
* Create Spree::SubscriptionsController and views for edit, update, and destroy actions
* Deface "Add to cart" button with "Subscribe" and time period dropdown
* Deface admin product and variant forms with additional fields
* Create admin subscription view

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
