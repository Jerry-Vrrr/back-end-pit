module Api
  module V1
    class CallRailDataController < ApplicationController
      def index
        if params[:company_id]
          Rails.logger.info "Fetching data for Company ID: #{params[:company_id]}"
          service = CallRailService.new('53962143e3bd0ab2989770ecbe94a75c', params[:company_id])
          response = service.fetch_calls

          if response.success?
            Rails.logger.info "Successful response: #{response.body}"
            
            # Assuming response.parsed_response["calls"] contains the call data
            response.parsed_response["calls"].each do |call|
              Rails.logger.info "Saving call with ID: #{call['id']} for Company ID: #{params[:company_id]}"
              CallRailData.create(
                answered: call["answered"],
                business_phone_number: call["business_phone_number"],
                customer_city: call["customer_city"],
                customer_country: call["customer_country"],
                customer_name: call["customer_name"],
                customer_phone_number: call["customer_phone_number"],
                customer_state: call["customer_state"],
                direction: call["direction"],
                duration: call["duration"],
                call_id: call["id"],
                recording: call["recording"],
                recording_duration: call["recording_duration"],
                recording_player: call["recording_player"],
                start_time: call["start_time"],
                tracking_phone_number: call["tracking_phone_number"],
                voicemail: call["voicemail"],
                company_id: params[:company_id]
              )
            end

            calls = CallRailData.where(company_id: params[:company_id])
          else
            Rails.logger.error "Error response: #{response.message}"
            calls = CallRailData.none
          end
        else
          calls = CallRailData.all
        end

        enriched_calls = calls.map do |call|
          call.attributes.merge(company_name: COMPANY_MAPPING[call.company_id])
        end

        render json: enriched_calls
      end
    end
  end
end
