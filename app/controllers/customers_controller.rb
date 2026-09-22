class CustomersController < ApplicationController
  def index
    @customers = Customer.by_name
  end

  def show
    @customer = Customer.find(params[:id])
    @bikes = @customer.bikes.includes(:customer).by_identity
  end
end