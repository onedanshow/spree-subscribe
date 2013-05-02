namespace :spree_subscribe do
  namespace :reorders do

    desc "Find all subscriptions that are due today and reorder their products"
    task :create => :environment do
      puts Spree::Subscription.where(:reships_on => Date.today).count
    end

  end

  namespace :db do
    desc "Seed database with basic subscription data"
    task :seed => :environment do
      #SpreeSubscribe::Engine.load_seed
    end
  end
end