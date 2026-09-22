class RepairsController < ApplicationController
  def index
    @repairs = Repair.includes(:bike, :customer).by_promised_date
  end

  def show
    @repair = Repair.includes(:bike, :customer, :staff_member).find(params[:id])

    @repair_services =
      @repair.repair_services.includes(:service).by_service_name
  end
end