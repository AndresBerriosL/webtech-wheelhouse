class BikesController < ApplicationController
  def index
    @bikes = Bike.includes(:customer).by_identity
  end

  def show
    @bike = Bike.includes(:customer).find(params[:id])
    @repairs = @bike.repairs.includes(:bike, :customer).by_promised_date
  end
end