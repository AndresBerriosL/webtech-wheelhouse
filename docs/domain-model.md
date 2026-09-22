# Domain Model

## Diagram

![Wheelhouse domain model](domain-model.png)

## DBML

```dbml
Table customers {
  id bigint [pk, increment]
  name varchar [not null]
  phone varchar [not null]
  created_at datetime [not null]
  updated_at datetime [not null]
}

Table staff_members {
  id bigint [pk, increment]
  name varchar [not null]
  role varchar [not null]
  created_at datetime [not null]
  updated_at datetime [not null]
}

Table bikes {
  id bigint [pk, increment]
  customer_id bigint [not null]
  make varchar [not null]
  model varchar [not null]
  colour varchar [not null]
  serial_number varchar [not null, unique]
  created_at datetime [not null]
  updated_at datetime [not null]
}

Table repairs {
  id bigint [pk, increment]
  bike_id bigint [not null]
  customer_id bigint [not null]
  staff_member_id bigint
  received_at datetime [not null]
  promised_on date [not null]
  status varchar [not null, default: 'received']
  quoted_at datetime
  customer_decision varchar
  picked_up_at datetime
  created_at datetime [not null]
  updated_at datetime [not null]
}

Table services {
  id bigint [pk, increment]
  name varchar [not null, unique]
  current_price decimal(10,2) [not null]
  created_at datetime [not null]
  updated_at datetime [not null]
}

Table repair_services {
  id bigint [pk, increment]
  repair_id bigint [not null]
  service_id bigint [not null]
  charged_price decimal(10,2) [not null]
  created_at datetime [not null]
  updated_at datetime [not null]
}

Ref: customers.id < bikes.customer_id
Ref: bikes.id < repairs.bike_id
Ref: customers.id < repairs.customer_id
Ref: staff_members.id < repairs.staff_member_id
Ref: repairs.id < repair_services.repair_id
Ref: services.id < repair_services.service_id
```

## Repair lifecycle

A repair can move through these states:

- `received`: the bike has arrived at the shop.
- `diagnosed`: a mechanic has identified the problem.
- `awaiting_approval`: the shop is waiting for the customer's decision.
- `approved`: the customer accepted the proposed repair.
- `in_progress`: the bike is being repaired.
- `ready_for_pickup`: the bike can be collected by the customer.
- `rejected`: the customer did not approve the proposed repair.
- `picked_up`: the bike has left the shop.

### Allowed transitions

For a simple repair:

`received` → `in_progress` → `ready_for_pickup` → `picked_up`

For a repair that needs approval:

`received` → `diagnosed` → `awaiting_approval` → `approved` → `in_progress` → `ready_for_pickup` → `picked_up`

If the customer rejects it:

`received` → `diagnosed` → `awaiting_approval` → `rejected` → `ready_for_pickup` → `picked_up`

### Transitions that are not allowed

- `awaiting_approval` → `in_progress` is not allowed because the customer has not approved the repair yet.
- `rejected` → `in_progress` is not allowed because the customer rejected the repair.
- `picked_up` is the final state.

## Entity traceability

| Entity | User story |
|---|---|
| `customers` | US1 — Register a bike |
| `staff_members` | US6 — Add the needed services, US7c — Finish a repair |
| `bikes` | US2 — Identify a bike, US10 — See a bike's repair history, US13 — Receive the correct bike |
| `repairs` | US4 — Set a promised date, US7b — Record the customer's decision, US8 — Check repair status, US9 — See late repairs |
| `services` | US6 — Add the needed services, US12 — See service prices online |
| `repair_services` | US7a — Prepare the repair cost, US11 — Keep old repair prices |

## Changes since Lab 3

- Added `staff_members` to store the mechanics and counter staff.
- Changed `bikes.current_owner_id` to `bikes.customer_id` to follow Rails naming conventions.
- Added `colour` to bikes.
- Removed `repair_photos` because photos will be implemented in a later lab.
- Removed `diagnosis` because diagnosis text will be implemented later.
- Changed `promised_date` to `promised_on`.
- Added `staff_member_id` to repairs. It can be null because a mechanic may not be assigned yet.
- Added `quoted_at`, `customer_decision` and `picked_up_at`. They can be null when those events have not happened yet.
- Added the default value `received` to the repair status.
- Added a unique index to service names.
- Added `created_at` and `updated_at` to all tables.

## The thing and the copy of the thing

Each physical bike has its own record. Two bikes can have the same make, model and colour, but their serial numbers are different.

This lets the shop identify each bike separately and keep its own repair history.

## Derived, or stored?

The total price of a repair is not stored. It can be calculated by adding the `charged_price` values from its services.

`charged_price` is stored separately from `current_price` because prices can change over time. This way an old repair keeps the price that was actually charged.