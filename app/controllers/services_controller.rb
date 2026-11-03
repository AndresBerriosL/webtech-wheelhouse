
class ServicesController < ApplicationController
  allow_unauthenticated_access only: [:index, :show]

  before_action :resume_session, only: [:index, :show]
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  def index
    authorize Service
    @services = policy_scope(Service).by_name
  end


  def show
    authorize @service

    @repair_services = @service.repair_services
                              .joins(:repair)
                              .merge(policy_scope(Repair))
                              .includes(:repair)
                              .newest_repair_first
  end


  def new
    @service = Service.new
    authorize @service
  end

  def edit
    authorize @service
  end

  def create
    authorize Service, :create?

    @service = Service.new(service_params)

    if @service.save
      redirect_to @service,
                  notice: "#{@service.name} was created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @service

    if @service.update(service_params)
      redirect_to @service,
                  notice: "#{@service.name} was updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @service

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