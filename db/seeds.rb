ApplicationRecord.transaction do
  # Keep the seed idempotent: every run starts from the same empty set.
  RepairService.delete_all
  Repair.delete_all
  Bike.delete_all
  Service.delete_all
  StaffMember.delete_all
  Customer.delete_all

  today = Date.current

  at = ->(date, hour) do
    Time.zone.local(date.year, date.month, date.day, hour, 0, 0)
  end

  # ---------------------------------------------------------------------------
  # Services
  # ---------------------------------------------------------------------------

  services = {}

  [
    ["Tune-up", 40],
    ["Wheel true", 30],
    ["Brake bleed", 30],
    ["Chain replacement", 35],
    ["Flat tyre repair", 20],
    ["Brake adjustment", 25],
    ["Gear adjustment", 25],
    ["Tire replacement", 30],
    ["Cable replacement", 20],
    ["Fork service", 60],
    ["Bearing service", 35],
    ["Bike inspection", 25],
    ["Bottom bracket service", 45],
    ["Headset adjustment", 20],
    ["Tubeless setup", 35],
    ["Cassette replacement", 30],
    ["Drivetrain cleaning", 40],
    ["Suspension inspection", 30],
    ["Wheel bearing service", 45],
    ["Hydraulic hose replacement", 50]
  ].each do |name, price|
    services[name] = Service.create!(
      name: name,
      current_price: price
    )
  end

  # ---------------------------------------------------------------------------
  # Staff
  # ---------------------------------------------------------------------------

  diego = StaffMember.create!(name: "Diego Soto", role: "mechanic")
  valentina = StaffMember.create!(name: "Valentina Rojas", role: "mechanic")
  matias = StaffMember.create!(name: "Matias Fuentes", role: "mechanic")
  StaffMember.create!(name: "Fernanda Silva", role: "counter")

  # ---------------------------------------------------------------------------
  # Customers
  # ---------------------------------------------------------------------------

  sofia = Customer.create!(name: "Sofia Martinez", phone: "+56 9 6123 4501")
  nicolas = Customer.create!(name: "Nicolas Perez", phone: "+56 9 6234 5012")
  camila = Customer.create!(name: "Camila Torres", phone: "+56 9 6345 0123")
  josefa = Customer.create!(name: "Josefa Herrera", phone: "+56 9 6450 1234")
  tomas = Customer.create!(name: "Tomas Araya", phone: "+56 9 6501 2345")
  antonia = Customer.create!(name: "Antonia Reyes", phone: "+56 9 7012 3456")
  benjamin = Customer.create!(name: "Benjamin Castro", phone: "+56 9 7123 4567")
  isidora = Customer.create!(name: "Isidora Morales", phone: "+56 9 7234 5678")
  vicente = Customer.create!(name: "Vicente Sepulveda", phone: "+56 9 7345 6789")
  florencia = Customer.create!(name: "Florencia Navarro", phone: "+56 9 7456 7890")

  # ---------------------------------------------------------------------------
  # Bikes
  # ---------------------------------------------------------------------------

  # These two are intentionally identical except for serial_number.
  bike1 = Bike.create!(
    customer_id: sofia.id,
    make: "Trek",
    model: "Marlin 7",
    colour: "Black",
    serial_number: "TRK-M7-001"
  )

  Bike.create!(
    customer_id: sofia.id,
    make: "Trek",
    model: "Marlin 7",
    colour: "Black",
    serial_number: "TRK-M7-002"
  )

  bike3 = Bike.create!(
    customer_id: nicolas.id,
    make: "Specialized",
    model: "Allez",
    colour: "Red",
    serial_number: "SPZ-ALZ-114"
  )

  bike4 = Bike.create!(
    customer_id: josefa.id,
    make: "Giant",
    model: "Talon 2",
    colour: "Blue",
    serial_number: "GNT-T2-804"
  )

  bike5 = Bike.create!(
    customer_id: tomas.id,
    make: "Cannondale",
    model: "Trail 5",
    colour: "Green",
    serial_number: "CND-T5-338"
  )

  bike6 = Bike.create!(
    customer_id: antonia.id,
    make: "Scott",
    model: "Aspect 950",
    colour: "Grey",
    serial_number: "SCT-A950-541"
  )

  bike7 = Bike.create!(
    customer_id: benjamin.id,
    make: "Bianchi",
    model: "Via Nirone",
    colour: "Blue",
    serial_number: "BIA-VN-729"
  )

  bike8 = Bike.create!(
    customer_id: isidora.id,
    make: "Oxford",
    model: "Orion",
    colour: "White",
    serial_number: "OXF-ORI-215"
  )

  bike9 = Bike.create!(
    customer_id: vicente.id,
    make: "Trek",
    model: "Domane AL 2",
    colour: "Black",
    serial_number: "TRK-DAL2-991"
  )

  bike10 = Bike.create!(
    customer_id: florencia.id,
    make: "Specialized",
    model: "Rockhopper",
    colour: "Red",
    serial_number: "SPZ-RKH-673"
  )

  # Camila deliberately has a bike but no repairs.
  Bike.create!(
    customer_id: camila.id,
    make: "Giant",
    model: "Escape 3",
    colour: "Silver",
    serial_number: "GNT-ESC3-187"
  )

  bike12 = Bike.create!(
    customer_id: nicolas.id,
    make: "Cannondale",
    model: "Quick 4",
    colour: "Black",
    serial_number: "CND-Q4-426"
  )

  # ---------------------------------------------------------------------------
  # Repairs
  # ---------------------------------------------------------------------------

  repair1 = Repair.create!(
    bike_id: bike1.id,
    customer_id: sofia.id,
    staff_member_id: nil,
    received_at: at.call(today, 9),
    promised_on: today + 5.days,
    status: "received",
    quoted_at: nil,
    customer_decision: nil,
    picked_up_at: nil
  )

  repair2 = Repair.create!(
    bike_id: bike3.id,
    customer_id: nicolas.id,
    staff_member_id: diego.id,
    received_at: at.call(today - 1.day, 10),
    promised_on: today + 4.days,
    status: "diagnosed",
    quoted_at: nil,
    customer_decision: nil,
    picked_up_at: nil
  )

  repair3 = Repair.create!(
    bike_id: bike4.id,
    customer_id: josefa.id,
    staff_member_id: valentina.id,
    received_at: at.call(today - 2.days, 11),
    promised_on: today + 2.days,
    status: "awaiting_approval",
    quoted_at: at.call(today - 1.day, 15),
    customer_decision: nil,
    picked_up_at: nil
  )

  repair4 = Repair.create!(
    bike_id: bike5.id,
    customer_id: tomas.id,
    staff_member_id: matias.id,
    received_at: at.call(today - 3.days, 9),
    promised_on: today + 3.days,
    status: "approved",
    quoted_at: at.call(today - 2.days, 14),
    customer_decision: "accepted",
    picked_up_at: nil
  )

  # Overdue today and not handed back.
  repair5 = Repair.create!(
    bike_id: bike6.id,
    customer_id: antonia.id,
    staff_member_id: diego.id,
    received_at: at.call(today - 7.days, 8),
    promised_on: today - 2.days,
    status: "in_progress",
    quoted_at: at.call(today - 6.days, 13),
    customer_decision: "accepted",
    picked_up_at: nil
  )

  repair6 = Repair.create!(
    bike_id: bike7.id,
    customer_id: benjamin.id,
    staff_member_id: valentina.id,
    received_at: at.call(today - 5.days, 9),
    promised_on: today,
    status: "ready_for_pickup",
    quoted_at: at.call(today - 4.days, 12),
    customer_decision: "accepted",
    picked_up_at: nil
  )

  # Customer heard the price and rejected the repair.
  repair7 = Repair.create!(
    bike_id: bike8.id,
    customer_id: isidora.id,
    staff_member_id: matias.id,
    received_at: at.call(today - 3.days, 10),
    promised_on: today + 1.day,
    status: "rejected",
    quoted_at: at.call(today - 2.days, 16),
    customer_decision: "rejected",
    picked_up_at: nil
  )

  # Came in and went out on the same day.
  same_day = today - 10.days

  repair8 = Repair.create!(
    bike_id: bike9.id,
    customer_id: vicente.id,
    staff_member_id: diego.id,
    received_at: at.call(same_day, 9),
    promised_on: same_day,
    status: "picked_up",
    quoted_at: at.call(same_day, 10),
    customer_decision: "accepted",
    picked_up_at: at.call(same_day, 17)
  )

  # Historical repair from before last January.
  historical_day = Date.new(today.year - 1, 12, 15)

  repair9 = Repair.create!(
    bike_id: bike1.id,
    customer_id: sofia.id,
    staff_member_id: valentina.id,
    received_at: at.call(historical_day, 9),
    promised_on: historical_day + 3.days,
    status: "picked_up",
    quoted_at: at.call(historical_day, 11),
    customer_decision: "accepted",
    picked_up_at: at.call(historical_day + 2.days, 17)
  )

  repair10 = Repair.create!(
    bike_id: bike10.id,
    customer_id: florencia.id,
    staff_member_id: matias.id,
    received_at: at.call(today - 40.days, 10),
    promised_on: today - 35.days,
    status: "picked_up",
    quoted_at: at.call(today - 39.days, 12),
    customer_decision: "accepted",
    picked_up_at: at.call(today - 34.days, 18)
  )

  repair11 = Repair.create!(
    bike_id: bike12.id,
    customer_id: nicolas.id,
    staff_member_id: valentina.id,
    received_at: at.call(today - 4.days, 11),
    promised_on: today + 2.days,
    status: "in_progress",
    quoted_at: at.call(today - 3.days, 14),
    customer_decision: "accepted",
    picked_up_at: nil
  )

  repair12 = Repair.create!(
    bike_id: bike3.id,
    customer_id: nicolas.id,
    staff_member_id: diego.id,
    received_at: at.call(today - 20.days, 9),
    promised_on: today - 15.days,
    status: "ready_for_pickup",
    quoted_at: at.call(today - 19.days, 15),
    customer_decision: "accepted",
    picked_up_at: nil
  )

  repair13 = Repair.create!(
    bike_id: bike4.id,
    customer_id: josefa.id,
    staff_member_id: matias.id,
    received_at: at.call(today - 1.day, 13),
    promised_on: today + 5.days,
    status: "awaiting_approval",
    quoted_at: at.call(today, 9),
    customer_decision: nil,
    picked_up_at: nil
  )

  repair14 = Repair.create!(
    bike_id: bike5.id,
    customer_id: tomas.id,
    staff_member_id: diego.id,
    received_at: at.call(today - 2.days, 12),
    promised_on: today + 6.days,
    status: "diagnosed",
    quoted_at: nil,
    customer_decision: nil,
    picked_up_at: nil
  )

  repair15 = Repair.create!(
    bike_id: bike6.id,
    customer_id: antonia.id,
    staff_member_id: valentina.id,
    received_at: at.call(today - 60.days, 9),
    promised_on: today - 55.days,
    status: "picked_up",
    quoted_at: at.call(today - 59.days, 13),
    customer_decision: "accepted",
    picked_up_at: at.call(today - 54.days, 16)
  )

  # ---------------------------------------------------------------------------
  # Services charged on repairs
  # ---------------------------------------------------------------------------

  RepairService.create!(
    repair_id: repair1.id,
    service_id: services["Bike inspection"].id,
    charged_price: 25
  )

  RepairService.create!(
    repair_id: repair2.id,
    service_id: services["Wheel true"].id,
    charged_price: 30
  )

  RepairService.create!(
    repair_id: repair3.id,
    service_id: services["Fork service"].id,
    charged_price: 60
  )

  RepairService.create!(
    repair_id: repair3.id,
    service_id: services["Bike inspection"].id,
    charged_price: 25
  )

  RepairService.create!(
    repair_id: repair4.id,
    service_id: services["Chain replacement"].id,
    charged_price: 35
  )

  RepairService.create!(
    repair_id: repair4.id,
    service_id: services["Drivetrain cleaning"].id,
    charged_price: 40
  )

  RepairService.create!(
    repair_id: repair5.id,
    service_id: services["Brake bleed"].id,
    charged_price: 30
  )

  RepairService.create!(
    repair_id: repair5.id,
    service_id: services["Brake adjustment"].id,
    charged_price: 25
  )

  RepairService.create!(
    repair_id: repair6.id,
    service_id: services["Tire replacement"].id,
    charged_price: 30
  )

  RepairService.create!(
    repair_id: repair6.id,
    service_id: services["Tubeless setup"].id,
    charged_price: 35
  )

  RepairService.create!(
    repair_id: repair7.id,
    service_id: services["Bottom bracket service"].id,
    charged_price: 45
  )

  RepairService.create!(
    repair_id: repair8.id,
    service_id: services["Flat tyre repair"].id,
    charged_price: 20
  )

  # Historical prices intentionally differ from today's list prices.
  RepairService.create!(
    repair_id: repair9.id,
    service_id: services["Tune-up"].id,
    charged_price: 32
  )

  RepairService.create!(
    repair_id: repair9.id,
    service_id: services["Brake adjustment"].id,
    charged_price: 18
  )

  RepairService.create!(
    repair_id: repair10.id,
    service_id: services["Gear adjustment"].id,
    charged_price: 20
  )

  RepairService.create!(
    repair_id: repair10.id,
    service_id: services["Cable replacement"].id,
    charged_price: 20
  )

  RepairService.create!(
    repair_id: repair11.id,
    service_id: services["Cassette replacement"].id,
    charged_price: 30
  )

  RepairService.create!(
    repair_id: repair11.id,
    service_id: services["Chain replacement"].id,
    charged_price: 35
  )

  RepairService.create!(
    repair_id: repair11.id,
    service_id: services["Drivetrain cleaning"].id,
    charged_price: 40
  )

  RepairService.create!(
    repair_id: repair12.id,
    service_id: services["Bearing service"].id,
    charged_price: 35
  )

  RepairService.create!(
    repair_id: repair12.id,
    service_id: services["Wheel bearing service"].id,
    charged_price: 45
  )

  RepairService.create!(
    repair_id: repair13.id,
    service_id: services["Hydraulic hose replacement"].id,
    charged_price: 50
  )

  RepairService.create!(
    repair_id: repair13.id,
    service_id: services["Brake bleed"].id,
    charged_price: 30
  )

  RepairService.create!(
    repair_id: repair14.id,
    service_id: services["Headset adjustment"].id,
    charged_price: 20
  )

  RepairService.create!(
    repair_id: repair14.id,
    service_id: services["Bike inspection"].id,
    charged_price: 25
  )

  RepairService.create!(
    repair_id: repair15.id,
    service_id: services["Fork service"].id,
    charged_price: 55
  )

  RepairService.create!(
    repair_id: repair15.id,
    service_id: services["Suspension inspection"].id,
    charged_price: 30
  )

  RepairService.create!(
    repair_id: repair15.id,
    service_id: services["Tune-up"].id,
    charged_price: 40
  )
end

puts "Seed completed."
puts "Services: #{Service.count}"
puts "Staff members: #{StaffMember.count}"
puts "Customers: #{Customer.count}"
puts "Bikes: #{Bike.count}"
puts "Repairs: #{Repair.count}"
puts "Repair services: #{RepairService.count}"