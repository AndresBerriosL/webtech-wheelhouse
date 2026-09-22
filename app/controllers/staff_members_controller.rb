class StaffMembersController < ApplicationController
  def index
    @staff_members = StaffMember.by_name
  end

  def show
    @staff_member = StaffMember.find(params[:id])

    @repairs =
      @staff_member.repairs.includes(:bike, :customer).by_promised_date
  end
end