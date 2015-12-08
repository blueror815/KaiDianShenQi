namespace :append_member_type_tag do
  desc 'search and attach vip tag'
  task :for_vip => :environment do
    Membership.all.each do |membership|
      membership.decide_type
    end
  end
end
