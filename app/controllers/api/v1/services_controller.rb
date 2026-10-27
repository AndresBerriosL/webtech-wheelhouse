
module Api
  module V1
    class ServicesController < BaseController
      def index
        services = Service.by_name.includes(:repair_services)

        render json: services.map { |service| service_document(service) }
      end

      def show
        service = Service.find(params[:id])

        render json: service_document(service)
      end

      def create
        service = Service.new(service_params)

        if service.save
          render json: service_document(service),
                 status: :created,
                 location: api_v1_service_url(service)
        else
          render json: {
            errors: service.errors.full_messages
          }, status: :unprocessable_content
        end
      end

      private

      def service_params
        params.expect(service: [:name, :current_price])
      end

      def service_document(service)
        {
          id: service.id,
          name: service.name,
          price: service.current_price.to_s,
          repairs_count: service.repair_services.size
        }
      end
    end
  end
end
