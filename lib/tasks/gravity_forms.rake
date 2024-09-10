namespace :gravity_forms do
  desc "Clear all records from gravity_form_entries table"
  task clear_data: :environment do
    puts "Clearing all records from gravity_form_entries table..."
    GravityFormEntry.delete_all
    puts "All records cleared."
  end
end
