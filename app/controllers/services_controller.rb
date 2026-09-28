class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  def index
    @services = Service.by_name
  end

  def show
    @repair_services =
      @service.repair_services.includes(:repair).newest_repair_first
  end

  def new
    @service = Service.new
  end

  def edit
  end

  def create
    @service = Service.new(service_params)

    if @service.save
      redirect_to @service,
                  notice: "#{@service.name} was created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @service.update(service_params)
      redirect_to @service,
                  notice: "#{@service.name} was updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @service.destroy
      redirect_to services_path,
                  status: :see_other,
                  notice: "#{@service.name} was deleted."
    else
      redirect_to @service,
                  status: :see_other,
                  alert: @service.errors.full_messages.to_sentence
    end
  end

  private

  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.expect(service: [:name, :current_price])
  end
end