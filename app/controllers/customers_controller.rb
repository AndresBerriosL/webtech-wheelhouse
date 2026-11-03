
class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  def index
    authorize Customer
    @customers = policy_scope(Customer).by_name
  end

  def show
    authorize @customer
    @bikes = @customer.bikes.includes(:customer).by_identity
  end

  def new
    @customer = Customer.new
    authorize @customer
  end

  def edit
    authorize @customer
  end

  def create
    @customer = Customer.new(customer_params)
    authorize @customer

    if @customer.save
      redirect_to @customer,
                  notice: "#{@customer.name} was created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @customer

    if @customer.update(customer_params)
      redirect_to @customer,
                  notice: "#{@customer.name} was updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @customer

    if @customer.destroy
      redirect_to customers_path,
                  status: :see_other,
                  notice: "#{@customer.name} was deleted."
    else
      redirect_to @customer,
                  status: :see_other,
                  alert: @customer.errors.full_messages.to_sentence
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.expect(customer: [:name, :phone])
  end
end
