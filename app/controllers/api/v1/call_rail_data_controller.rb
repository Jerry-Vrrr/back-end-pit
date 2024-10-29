module Api
  module V1
    class CallRailDataController < ApplicationController
      def index
        if params[:company_id]
          Rails.logger.info "Fetching data for Company ID: #{params[:company_id]}"
          
          # Use GgtCallRailService if the request is for GGT
          if params[:company_id] == '176449112'
            service = GgtCallRailService.new
            response = service.fetch_calls
          else
            # Default to CallRailService for other companies
            service = CallRailService.new('53962143e3bd0ab2989770ecbe94a75c', params[:company_id])
            response = service.fetch_calls
          end

          if response.success?
            Rails.logger.info "Successful response for Company ID #{params[:company_id]}"

            response.parsed_response["calls"].each do |call|
              if CallRailData.exists?(call_id: call["id"])
                Rails.logger.info "Skipping duplicate call with ID: #{call['id']}"
              else
                begin
                  CallRailData.create!(
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
                  Rails.logger.info "Call with ID: #{call['id']} saved successfully"
                rescue => e
                  Rails.logger.error "Failed to save call with ID: #{call['id']} - Error: #{e.message}"
                end
              end
            end

            calls = CallRailData.where(company_id: params[:company_id])
          else
            Rails.logger.error "Error response from service: #{response.message}"
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
