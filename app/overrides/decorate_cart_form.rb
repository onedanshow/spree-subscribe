Deface::Override.new(:virtual_path => "spree/products/_cart_form",
                     :name => "client_new_subscriptions_form",
                     :insert_after => "[data-hook='inside_product_cart_form']",
                     :text => "<div id='new_subscription_form'></div>")

Deface::Override.new(:virtual_path => "spree/products/_cart_form",
                     :name => "client_new_subscriptions_link",
                     :insert_after => "[data-hook='inside_product_cart_form']",
                     :text => "<%= button_link_to t(:new_subscription_interval), '#' ,  :icon => 'icon-plus', :id => 'client_new_subscription_interval_link' %>")
