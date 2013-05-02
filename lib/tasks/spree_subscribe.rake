namespace :spree_subscribe do
  namespace :reorders do

    desc "Find all subscriptions that are due today and reorder their products"
    task :create => :environment do
      puts Spree::Subscription.where(:reships_on => Date.today).count
    end

  end
end