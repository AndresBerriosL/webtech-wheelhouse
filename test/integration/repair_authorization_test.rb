
require "test_helper"

class RepairAuthorizationTest < ActionDispatch::IntegrationTest
  setup do
    @password = "TestPassword123!"

    diego_staff = StaffMember.create!(
      name: "Diego Test",
      role: "mechanic"
    )

    valentina_staff = StaffMember.create!(
      name: "Valentina Test",
      role: "mechanic"
    )

    @diego = User.create!(
      email_address: "diego-test@example.com",
      password: @password,
      role: :mechanic,
      staff_member: diego_staff
    )

    @valentina = User.create!(
      email_address: "valentina-test@example.com",
      password: @password,
      role: :mechanic,
      staff_member: valentina_staff
    )

    @counter = User.create!(
      email_address: "counter-test@example.com",
      password: @password,
      role: :counter
    )

    @owner = User.create!(
      email_address: "owner-test@example.com",
      password: @password,
      role: :owner
    )

    customer = Customer.create!(
      name: "Test Customer",
      phone: "123456789"
    )

    bike = Bike.create!(
      customer: customer,
      make: "Trek",
      model: "Marlin",
      colour: "Blue",
      serial_number: "TEST-AUTH-001"
    )

    common_attributes = {
      bike: bike,
      customer: customer,
      received_at: Time.current,
      promised_on: Date.current + 3.days,
      state: :received
    }

    @own_repair = Repair.create!(
      **common_attributes,
      staff_member: diego_staff
    )

    @other_repair = Repair.create!(
      **common_attributes,
      staff_member: valentina_staff
    )

    @picked_up_repair = Repair.create!(
      **common_attributes,
      staff_member: diego_staff,
      state: :picked_up,
      customer_decision: "approved",
      picked_up_at: Time.current
    )

    service = Service.create!(
      name: "Test Service",
      current_price: 10000
    )

    @line = RepairService.create!(
      repair: @own_repair,
      service: service,
      charged_price: 10000
    )
  end

  test "mechanic sees only assigned repairs" do
    sign_in(@diego)

    get repairs_path

    assert_response :success

    assert_select "a[href='#{repair_path(@own_repair)}']"
    assert_select "a[href='#{repair_path(@other_repair)}']", count: 0
  end

  test "mechanic cannot see another mechanic repair" do
    sign_in(@diego)

    get repair_path(@other_repair)

    assert_response :forbidden
  end

  test "mechanic cannot edit another mechanic repair" do
    sign_in(@diego)

    get edit_repair_path(@other_repair)

    assert_response :forbidden
  end

  test "mechanic cannot update another mechanic repair" do
    sign_in(@diego)

    patch repair_path(@other_repair),
          params: {
            repair: { diagnosis: "Unauthorized change" }
          }

    assert_response :forbidden
    assert_nil @other_repair.reload.diagnosis
  end

  test "mechanic cannot edit picked up repair" do
    sign_in(@diego)

    get edit_repair_path(@picked_up_repair)

    assert_response :forbidden
  end

  test "mechanic cannot change assignment or price" do
    sign_in(@diego)

    original_staff = @own_repair.staff_member_id
    original_price = @line.charged_price

    patch repair_path(@own_repair),
          params: {
            repair: {
              diagnosis: "Authorized diagnosis",
              staff_member_id: @valentina.staff_member_id,
              repair_services_attributes: {
                "0" => {
                  id: @line.id,
                  charged_price: 1
                }
              }
            }
          }

    assert_redirected_to repair_path(@own_repair)

    assert_equal "Authorized diagnosis",
                 @own_repair.reload.diagnosis

    assert_equal original_staff,
                 @own_repair.staff_member_id

    assert_equal original_price,
                 @line.reload.charged_price
  end

  test "counter cannot delete repairs" do
    sign_in(@counter)

    assert_no_difference "Repair.count" do
      delete repair_path(@own_repair)
    end

    assert_response :forbidden
  end

  test "owner can see every repair" do
    sign_in(@owner)

    get repairs_path

    assert_response :success

    assert_select "a[href='#{repair_path(@own_repair)}']"
    assert_select "a[href='#{repair_path(@other_repair)}']"
  end

  test "visitor is redirected to sign in" do
    get repairs_path

    assert_redirected_to new_session_path
  end

  private

  def sign_in(user)
    post session_path,
         params: {
           email_address: user.email_address,
           password: @password
         }

    assert_redirected_to root_path
  end
end
