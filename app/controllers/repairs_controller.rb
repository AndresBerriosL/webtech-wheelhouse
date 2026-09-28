class RepairsController < ApplicationController
  before_action :set_repair, only: [:show, :edit, :update, :destroy]

  def index
    @repairs = Repair.includes(:bike, :customer).by_promised_date
  end

  def show
    @repair_services =
      @repair.repair_services.includes(:service).by_service_name
  end

  def new
    @repair = Repair.new

    if params[:bike_id].present?
      bike = Bike.find_by(id: params[:bike_id])

      @selected_bike_id = bike&.id
      @selected_customer_id = bike&.customer_id
    end

    3.times { @repair.repair_services.build }
  end

  def edit
    3.times { @repair.repair_services.build }
  end

  def create
    @repair = Repair.new(repair_params)

    if @repair.save
      redirect_to @repair,
                  notice: "Repair ##{@repair.id} was created."
    else
      ensure_empty_lines
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @repair.update(repair_params)
      redirect_to @repair,
                  notice: "Repair ##{@repair.id} was updated."
    else
      ensure_empty_lines
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @repair.destroy
      redirect_to repairs_path,
                  status: :see_other,
                  notice: "Repair ##{@repair.id} was deleted."
    else
      redirect_to @repair,
                  status: :see_other,
                  alert: @repair.errors.full_messages.to_sentence
    end
  end

  private

  def set_repair
    @repair =
      Repair.includes(
        :bike,
        :customer,
        :staff_member,
        repair_services: :service
      ).find(params[:id])
  end

  def repair_params
    params.expect(
      repair: [
        :bike_id,
        :customer_id,
        :staff_member_id,
        :received_at,
        :promised_on,
        :state,
        :quoted_at,
        :customer_decision,
        :picked_up_at,
        repair_services_attributes: [[
          :id,
          :service_id,
          :charged_price,
          :_destroy
        ]]
      ]
    )
  end

  def ensure_empty_lines
    missing =
      3 - @repair.repair_services.reject(&:marked_for_destruction?).count

    missing.times { @repair.repair_services.build } if missing.positive?
  end
end