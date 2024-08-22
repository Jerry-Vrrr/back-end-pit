set :output, "log/cron.log"

every 30.minutes do
  if Time.now.hour >= 6 && Time.now.hour <= 18
    rake "call_rail:fetch_and_save_all"
    rake "gravity_forms:fetch_and_save"
  end
end
