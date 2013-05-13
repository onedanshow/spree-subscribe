namespace :spree_subscribe do

  namespace :reorders do
    desc "Find all subscriptions that are due today and reorder their products"
    task :create => :environment do
      Spree::Subscription.where(:reorder_on => Date.today).each{|s| s.reorder }
    end
  end

  namespace :db do
    desc "Seed database with basic subscription data"
    task :seed => :environment do
      SpreeSubscribe::Engine.load_seed
    end
  end
end