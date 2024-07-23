set :output, "log/cron.log"

every 1.hour do
  rake "call_rail:fetch_and_save_all"
end
