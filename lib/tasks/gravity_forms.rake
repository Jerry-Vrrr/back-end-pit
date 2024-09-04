namespace :gravity_forms do
  desc "Clear all records from gravity_form_entries table"
  task clear_data: :environment do
    puts "Clearing all records from gravity_form_entries table..."
    GravityFormEntry.delete_all
    puts "All records cleared."
  end

  desc "Fetch and save Gravity Forms data for all companies"
  task fetch_and_save: :environment do
    company_names = GravityFormsService::COMPANY_MAPPING.keys

    company_names.each do |company_name|
      Rails.logger.info "Processing company: #{company_name}"
      service = GravityFormsService.new(company_name)

      entries = service.fetch_entries
      Rails.logger.info "Fetched entries for #{company_name}: #{entries.inspect}"

      entries.each do |entry|
        form_entry = GravityFormEntry.new(
          entry_id: entry[:id],
          form_id: entry[:form_id],
          date_created: entry[:date_created],
          name: entry[:name],
          phone: entry[:phone],
          email: entry[:email],
          message: entry[:message],
          source_url: entry[:source_url],
          company_id: entry[:company_id]
        )

        if form_entry.save
          Rails.logger.info "Entry with ID: #{entry[:id]} for #{company_name} saved successfully"
        else
          Rails.logger.error "Error saving entry with ID: #{entry[:id]} for #{company_name}: #{form_entry.errors.full_messages.join(', ')}"
        end
      end
    end
  end
end
