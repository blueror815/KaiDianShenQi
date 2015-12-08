# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "/opt/nginx/logs/cron_log.log"
#
every 3.minutes do
  rake "send_sms:first_visit"
  rake "send_sms:growth_visit"
  rake "send_sms:lapse_visit"

  rake "append_member_type_tag:for_vip"
end
