class BikesController < ApplicationController
  before_action :set_bike, only: [:show, :edit, :update, :destroy]

  def index
    @bikes = Bike.includes(:customer).by_identity
  end

  def show
    @repairs = @bike.repairs.includes(:bike, :customer).by_promised_date
  end

  def new
    @bike = Bike.new
    @selected_customer_id = params[:customer_id]
  end

  def edit
  end

  def create
    @bike = Bike.new(bike_params)

    if @bike.save
      redirect_to @bike,
                  notice: "#{@bike.make} #{@bike.model} #{@bike.serial_number} was created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @bike.update(bike_params)
      redirect_to @bike,
                  notice: "#{@bike.make} #{@bike.model} #{@bike.serial_number} was updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
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