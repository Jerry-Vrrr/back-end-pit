set :output, "log/cron.log"

every 30.minutes, at: ('06:00'..'18:00') do
  rake "call_rail:fetch_and_save_all"
  rake "gravity_forms:fetch_and_save"
end
