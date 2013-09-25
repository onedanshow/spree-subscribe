Deface::Override.new(:virtual_path => "spree/admin/orders/index",
                     :name => "subscriptions_admin_menu",
                     :insert_after => "[data-hook='admin_orders_index_search']",
                     :partial => "spree/admin/shared/orders_sub_menu")

Deface::Override.new(:virtual_path => "spree/admin/orders/new",
                     :name => "subscriptions_admin_menu",
                     :insert_after => "[data-hook='admin_order_new_header']",
                     :partial => "spree/admin/shared/orders_sub_menu")

Deface::Override.new(:virtual_path => "spree/admin/orders/edit",
                     :name => "subscriptions_admin_menu",
                     :insert_after => "[data-hook='admin_order_edit_form']",
                     :partial => "spree/admin/shared/orders_sub_menu")
