
class StaffMembersController < ApplicationController
  before_action :set_staff_member, only: [:show, :edit, :update, :destroy]

  def index
    authorize StaffMember

    @staff_members = policy_scope(StaffMember).by_name
  end

  def show
    authorize @staff_member

    @repairs = policy_scope(Repair)
                 .where(staff_member_id: @staff_member.id)
                 .includes(:bike, :customer)
                 .by_promised_date
  end

  def new
    @staff_member = StaffMember.new
    authorize @staff_member
  end

  def edit
    authorize @staff_member
  end

  def create
    @staff_member = StaffMember.new
    authorize @staff_member

    @staff_member.assign_attributes(staff_member_params)

    if @staff_member.save
      redirect_to @staff_member,
                  notice: "Staff member was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @staff_member

    if @staff_member.update(staff_member_params)
      redirect_to @staff_member,
                  notice: "Staff member was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @staff_member

    if @staff_member.destroy
      redirect_to staff_members_path,
                  status: :see_other,
                  notice: "Staff member was successfully deleted."
    else
      redirect_to @staff_member,
                  status: :see_other,
                  alert: @staff_member.errors.full_messages.to_sentence
    end
  end

  private

  def set_staff_member
    @staff_member = StaffMember.find(params[:id])
  end

  def staff_member_params
    params.expect(staff_member: [:name, :role])
  end
end
