namespace :call_rail do
  desc "Fetch and save call data for all companies"
  task fetch_and_save_all: :environment do
    COMPANY_MAPPING.each do |company_id, company_name|
      Rails.logger.info "Processing company: #{company_name} with ID: #{company_id}"

      # Assign services based on company_id
      primary_service = CallRailService.new(ENV['CALLRAIL_API_KEY_PRIMARY'], ENV['CALLRAIL_COMPANY_ID_PRIMARY'], company_id)
      secondary_service = company_id == '176449112' ? GgtCallRailService.new : nil

      # Fetch data from primary source
      primary_response = primary_service.fetch_calls
      Rails.logger.info "Primary service response for #{company_name}: #{primary_response.message}"

      if primary_response.success?
        Rails.logger.info "Successful primary response for #{company_name}"

        # Process and save each call from the primary response
        primary_response.parsed_response["calls"].each do |call|
          Rails.logger.info "Processing call with ID: #{call['id']} for Company ID: #{company_id}"
          save_call_data(call, company_id)
        end
      else
        Rails.logger.error "Primary service error for #{company_name}: #{primary_response.message}"
      end

      # Fetch data from secondary (GGT) service if applicable
      if secondary_service
        secondary_response = secondary_service.fetch_calls
        Rails.logger.info "Secondary (GGT) service response for #{company_name}: #{secondary_response.message}"

        if secondary_response.success?
          Rails.logger.info "Successful secondary response for #{company_name}"

          # Process and save each call from the secondary response
          secondary_response.parsed_response["calls"].each do |call|
            Rails.logger.info "Processing secondary call with ID: #{call['id']} for Company ID: #{company_id}"
            save_call_data(call, company_id)
          end
        else
          Rails.logger.error "Secondary (GGT) service error for #{company_name}: #{secondary_response.message}"
        end
      end
    end
  end

  # Helper method to save call data
  def save_call_data(call, company_id)
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
end
