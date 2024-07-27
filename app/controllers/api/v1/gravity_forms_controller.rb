module Api
  module V1
    class GravityFormsController < ApplicationController
      def index
        entries = GravityFormEntry.all
        render json: { entries: entries }
      end

      def fetch_and_save
        company_name = params[:company_name]
        service = GravityFormsService.new(company_name)
        entries = service.fetch_entries

        if entries.any?
          entries.each do |entry|
            GravityFormEntry.create(entry)
          end
          render json: { message: 'Entries fetched and saved successfully.' }, status: :ok
        else
          render json: { message: 'No entries found or an error occurred.' }, status: :unprocessable_entity
        end
      end

      def entries
        @entries = GravityFormEntry.all
        render json: @entries
      end
    end
  end
end
