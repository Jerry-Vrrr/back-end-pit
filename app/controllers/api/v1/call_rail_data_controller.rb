module Api
  module V1
    class CallRailDataController < ApplicationController
      def fetch_and_store
        service = CallRailService.new("YOUR_API_KEY", params[:company_id])
        response = service.fetch_calls

        if response.success?
          response.parsed_response["calls"].each do |call|
            CallRailDatum.create(
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
          render json: { message: "Data fetched and stored successfully" }, status: :ok
        else
          render json: { error: response.message }, status: :unprocessable_entity
        end
      end

      def index
        if params[:company_id]
          calls = CallRailDatum.where(company_id: params[:company_id])
        else
          calls = CallRailDatum.all
        end

        enriched_calls = calls.map do |call|
          call.attributes.merge(company_name: COMPANY_MAPPING[call.company_id])
        end

        render json: enriched_calls
      end
    end
  end
end
