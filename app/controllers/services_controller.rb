class ServicesController < ApplicationController
  def index
    @services = Service.by_name
  end

  def show
    @service = Service.find(params[:id])

    @repair_services =
      @service.repair_services.includes(:repair).newest_repair_first
  end
end