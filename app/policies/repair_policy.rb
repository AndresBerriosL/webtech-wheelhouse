
class RepairPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    return false unless user
    return true if user.owner? || user.counter?

    user.mechanic? &&
      user.staff_member_id.present? &&
      record.staff_member_id == user.staff_member_id
  end

  def create?
    user&.owner? || user&.counter? || false
  end

  def update?
    return false unless user
    return true if user.owner?
    return false if record.picked_up?

    return true if user.counter?

    user.mechanic? &&
      user.staff_member_id.present? &&
      record.staff_member_id == user.staff_member_id
  end

  def destroy?
    user&.owner? || false
  end


  def permitted_attributes
    return [] unless user

    if user.mechanic?
      return [
        :state,
        :diagnosis,
        { intake_photos: [] }
      ]
    end

    [
      :bike_id,
      :customer_id,
      :staff_member_id,
      :received_at,
      :promised_on,
      :state,
      :diagnosis,
      :quoted_at,
      :customer_decision,
      :picked_up_at,
      { intake_photos: [] },
      {
        repair_services_attributes: [[
          :id,
          :service_id,
          :charged_price,
          :_destroy
        ]]
      }
    ]
  end


  class Scope < ApplicationPolicy::Scope
    def resolve
      return scope.none unless user
      return scope.all if user.owner? || user.counter?

      if user.mechanic? && user.staff_member_id.present?
        scope.where(staff_member_id: user.staff_member_id)
      else
        scope.none
      end
    end
  end
end
