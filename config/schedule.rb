set :output, "log/cron.log"

every 30.minutes, at: '0:06am', 06:30am', '07:00am', '07:30am', '08:00am', '08:30am', '09:00am', '09:30am', '10:00am', '10:30am', '11:00am', '11:30am', '12:00pm', '12:30pm', '01:00pm', '01:30pm', '02:00pm', '02:30pm', '03:00pm', '03:30pm', '04:00pm', '04:30pm', '05:00pm', '05:30pm', '06:00pm' do
  rake "call_rail:fetch_and_save_all"
  rake "gravity_forms:fetch_and_save"
end
