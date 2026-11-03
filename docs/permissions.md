
# Wheelhouse — Permissions

## Overview

Wheelhouse uses Pundit for authorization.

There are three authenticated roles:

- Owner: manages the entire workshop.
- Counter: manages customers, bikes, and repairs.
- Mechanic: works only on repairs assigned to their staff member.

Newly registered accounts receive the Counter role by default.

Permissions are enforced in controllers through Pundit policies, not only by hiding buttons in the interface.

## 1. Customers

Policy: `CustomerPolicy`

| Action | Owner | Counter | Mechanic |
|---|---|---|---|
| index | Yes | Yes | No |
| show | Yes | Yes | No |
| new | Yes | Yes | No |
| create | Yes | Yes | No |
| edit | Yes | Yes | No |
| update | Yes | Yes | No |
| destroy | Yes | No | No |

Owners and counter staff can read, create, and update customers.

Only owners can delete customers.

Mechanics cannot access customer pages.

The index uses `CustomerPolicy::Scope`.

## 2. Bikes

Policy: `BikePolicy`

| Action | Owner | Counter | Mechanic |
|---|---|---|---|
| index | Yes | Yes | No |
| show | Yes | Yes | No |
| new | Yes | Yes | No |
| create | Yes | Yes | No |
| edit | Yes | Yes | No |
| update | Yes | Yes | No |
| destroy | Yes | No | No |

Owners and counter staff can read, create, and update bikes.

Only owners can delete bikes.

Mechanics cannot access bike pages.

The index uses `BikePolicy::Scope`.

Repair histories on bike pages are filtered through `RepairPolicy::Scope`.

## 3. Repairs

Policy: `RepairPolicy`

| Action | Owner | Counter | Mechanic |
|---|---|---|---|
| index | All repairs | All repairs | Assigned repairs only |
| show | All repairs | All repairs | Assigned repairs only |
| new | Yes | Yes | No |
| create | Yes | Yes | No |
| edit | All repairs | Not picked up | Assigned and not picked up |
| update | All repairs | Not picked up | Assigned and not picked up |
| destroy | Yes | No | No |

### Assigned repairs

A repair belongs to a mechanic when:

`repair.staff_member_id == user.staff_member_id`

The account must have the Mechanic role and a linked staff member.

A mechanic without an associated staff member cannot read or edit any repairs.

### Picked-up repairs

A repair in the `picked_up` state has been handed back.

Only the Owner can edit a picked-up repair.

Counter staff and mechanics cannot edit picked-up repairs.

### Repair visibility

`RepairPolicy::Scope` returns:

- Owner: all repairs.
- Counter: all repairs.
- Mechanic: only assigned repairs.
- Mechanic without staff association: no repairs.

The same visibility rules apply to repair details and repair lists on other pages.

### Editable attributes

| Attribute | Owner | Counter | Mechanic |
|---|---|---|---|
| bike_id | Yes | Yes | No |
| customer_id | Yes | Yes | No |
| staff_member_id | Yes | Yes | No |
| received_at | Yes | Yes | No |
| promised_on | Yes | Yes | No |
| state | Yes | Yes | Yes |
| diagnosis | Yes | Yes | Yes |
| intake_photos | Yes | Yes | Yes |
| quoted_at | Yes | Yes | No |
| customer_decision | Yes | Yes | No |
| picked_up_at | Yes | Yes | No |
| repair_services_attributes | Yes | Yes | No |

These attributes apply only when the user is authorized to create or update the repair.

The policy defines `permitted_attributes`.

Fields outside the permitted list are discarded by Rails strong parameters.

The `received_by` association is assigned from the authenticated session. It is never accepted from form parameters.

## 4. Services

Policy: `ServicePolicy`

| Action | Owner | Counter | Mechanic |
|---|---|---|---|
| index | Yes | Yes | Yes |
| show | Yes | Yes | Yes |
| new | Yes | No | No |
| create | Yes | No | No |
| edit | Yes | No | No |
| update | Yes | No | No |
| destroy | Yes | No | No |

The index and show pages are also public: visitors without accounts may access them.

Only the Owner can create, update, or delete services.

The index uses `ServicePolicy::Scope`.

Repair lists shown on service pages respect `RepairPolicy::Scope`. Visitors cannot see private repair histories.

## 5. Staff Members

Policy: `StaffMemberPolicy`

| Action | Owner | Counter | Mechanic |
|---|---|---|---|
| index | Yes | Yes | Yes |
| show | Yes | Yes | Yes |
| new | Yes | No | No |
| create | Yes | No | No |
| edit | Yes | No | No |
| update | Yes | No | No |
| destroy | Yes | No | No |

All authenticated roles may read staff information.

Only the Owner can create, update, or delete staff members.

The index uses `StaffMemberPolicy::Scope`.

Repair lists on staff pages respect `RepairPolicy::Scope`.

A mechanic cannot see repairs assigned to another mechanic.

## 6. Unauthenticated Visitors

Visitors without an authenticated session may access:

- Services index.
- Individual service pages.
- Sign-in pages.
- Registration pages.
- Password recovery pages.

Protected application pages redirect visitors to the sign-in page.

Visitors do not receive a 403 page merely because they are not signed in.

## 7. Denied Actions

An authenticated user attempting a forbidden action receives:

`403 Forbidden`

The response uses the application's custom forbidden page.

Denied create, update, and destroy actions do not modify records.

The interface also uses policy checks to hide unavailable links, buttons, and form fields.

Authorization is enforced by controllers even when a user manually enters a URL or submits modified parameters.

## 8. Global Verification

In development, ApplicationController verifies Pundit usage.

- Index actions must use `policy_scope`.
- Other protected actions must call `authorize`.
- Public exceptions are documented in `docs/decisions.md`.

The `/api/v1` JSON API retains its existing Bearer Token authentication and does not inherit the browser authorization callbacks.
