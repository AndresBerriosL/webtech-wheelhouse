class RepairsController < ApplicationController
  def index
    @repairs = Repair.order(:promised_on, :received_at)
  end

  def show
    @repair = Repair.find(params[:id])
  end
end