namespace :call_rail do
  desc "Fetch and save call data for all companies"
  task fetch_and_save_all: :environment do
    COMPANY_MAPPING.each do |company_id, company_name|
      Rails.logger.info "Processing company: #{company_name} with ID: #{company_id}"

      # Use GgtCallRailService for GGT company ID
      service = company_id == '176449112' ? GgtCallRailService.new : CallRailService.new(ENV['CALLRAIL_API_KEY_PRIMARY'], ENV['CALLRAIL_COMPANY_ID_PRIMARY'], company_id)

      # Fetch data
      response = service.fetch_calls

      if response.success?
        Rails.logger.info "Successful response for #{company_name}"

        # Process and save each call
        response.parsed_response["calls"].each do |call|
          Rails.logger.info "Processing call with ID: #{call['id']} for Company ID: #{company_id}"
          call_rail_data = CallRailData.find_or_initialize_by(call_id: call["id"])

          call_rail_data.assign_attributes(
            answered: call["answered"],
            business_phone_number: call["business_phone_number"],
            customer_city: call["customer_city"],
            customer_country: call["customer_country"],
            customer_name: call["customer_name"],
            customer_phone_number: call["customer_phone_number"],
            customer_state: call["customer_state"],
            direction: call["direction"],
            duration: call["duration"],
            recording: call["recording"],
            recording_duration: call["recording_duration"],
            recording_player: call["recording_player"],
            start_time: call["start_time"],
            tracking_phone_number: call["tracking_phone_number"],
            voicemail: call["voicemail"],
            company_id: company_id
          )

          if call_rail_data.save
            Rails.logger.info "Call with ID: #{call['id']} saved successfully for Company ID: #{company_id}"
          else
            Rails.logger.error "Error saving call with ID: #{call['id']} for Company ID: #{company_id}: #{call_rail_data.errors.full_messages.join(', ')}"
          end
        end
      else
        Rails.logger.error "Error response for #{company_name}: #{response.message}"
      end
    end
  end
end
