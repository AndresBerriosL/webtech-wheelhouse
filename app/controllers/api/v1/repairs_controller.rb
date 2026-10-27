
module Api
  module V1
    class RepairsController < BaseController
      def index
        repairs = Repair.by_promised_date
                        .includes(:bike, :customer, repair_services: :service)

        if params[:state].present?
          unless Repair.states.key?(params[:state])
            return render json: {
              errors: ["Invalid state. Valid states: #{Repair.states.keys.join(', ')}"]
            }, status: :bad_request
          end

          repairs = repairs.where(state: params[:state])
        end

        render json: repairs.map { |repair| repair_document(repair) }
      end

      def show
        repair = Repair.includes(
          :bike,
          :customer,
          repair_services: :service
        ).find(params[:id])

        render json: repair_document(repair)
      end

      private

      def repair_document(repair)
        {
          id: repair.id,
          state: repair.state,
          received_at: repair.received_at,
          promised_on: repair.promised_on,
          picked_up_at: repair.picked_up_at,

          bike: {
            make: repair.bike.make,
            model: repair.bike.model,
            serial_number: repair.bike.serial_number
          },

          customer: {
            name: repair.customer.name
          },

          lines: repair.repair_services.map do |line|
            {
              service: line.service.name,
              charged_price: line.charged_price.to_s
            }
          end,

          total: repair.total.to_s,
          overdue: repair.overdue?,
          customer_decision: repair.customer_decision
        }
      end
    end
  end
end
