
class BikesController < ApplicationController
  before_action :set_bike, only: [:show, :edit, :update, :destroy]

  def index
    authorize Bike
    @bikes = policy_scope(Bike).includes(:customer).by_identity
  end


  def show
    authorize @bike

    @repairs = policy_scope(Repair)
                .where(bike_id: @bike.id)
                .includes(:bike, :customer)
                .by_promised_date
  end


  def new
    @bike = Bike.new
    authorize @bike

    @selected_customer_id = params[:customer_id]
  end

  def edit
    authorize @bike
  end

  def create
    @bike = Bike.new(bike_params)
    authorize @bike

    if @bike.save
      redirect_to @bike,
                  notice: "#{@bike.make} #{@bike.model} #{@bike.serial_number} was created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @bike

    if @bike.update(bike_params)
      redirect_to @bike,
                  notice: "#{@bike.make} #{@bike.model} #{@bike.serial_number} was updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @bike

    if @bike.destroy
      redirect_to bikes_path,
                  status: :see_other,
                  notice: "#{@bike.make} #{@bike.model} #{@bike.serial_number} was deleted."
    else
      redirect_to @bike,
                  status: :see_other,
                  alert: @bike.errors.full_messages.to_sentence
    end
  end

  private

  def set_bike
    @bike = Bike.includes(:customer).find(params[:id])
  end

  def bike_params
    params.expect(
      bike: [
        :customer_id,
        :make,
        :model,
        :colour,
        :serial_number
      ]
    )
  end
end
