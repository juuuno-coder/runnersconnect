module Api
  module V1
    class RacesController < Api::BaseController
      # GET /api/v1/races
      def index
        @races = Race.where(status: ['open', 'draft']).order(start_at: :asc)
        
        render json: @races, include: :race_editions
      end

      # GET /api/v1/races/:id
      def show
        @race = Race.find(params[:id])
        
        render json: @race, include: :race_editions
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Race not found' }, status: :not_found
      end
    end
  end
end
