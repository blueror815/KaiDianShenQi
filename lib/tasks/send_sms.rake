namespace :send_sms do

  desc 'send msg if a member visit a retailer for the first time'
  task :first_visit => :environment do
    Membership.where("created_at <= ?", 15.minutes.ago).each do |membership|
      membership.send_first_time_msg if membership.sms_first_visit.nil?
    end
  end

  desc 'send msg if a member visit a retailer more then configured times'
  task :growth_visit => :environment do
    Membership.all.each do |membership|
      membership.send_growth_msg
    end
  end

  desc 'sending laps'
  task :lapse_visit => :environment do
    Membership.all.each do |membership|
      membership.send_at_risk_msg
    end
  end

  desc 'compute revenue'
  task :compute_revenue => :environment do
    Retailer.all.each do |retailer|
      retailer.revenue_stat.compute_revenue
    end
  end
end
