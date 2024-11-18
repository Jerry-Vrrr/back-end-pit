module Api
  module V1
    class KeywordRankingsController < ApplicationController
      def index
        keyword_rankings = KeywordRanking.all
        render json: keyword_rankings
      end
    end
  end
end
