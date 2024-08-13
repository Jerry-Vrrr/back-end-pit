namespace :db do
  desc "Clear all records from call_rail_data table"
  task clear_call_rail_data: :environment do
    puts "Clearing all records from call_rail_data table..."
    CallRailData.delete_all
    puts "All records cleared."
  end
end
