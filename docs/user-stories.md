# User Stories

## Roles

- Counter staff
- Mechanic
- Shop owner
- Customer

## Stories

### US1 — Register a bike

As counter staff, I want to register a customer and their bike when they arrive, so that I know who the bike belongs to.

### US2 — Identify a bike

As counter staff, I want to save the bike's make, model and serial number, so that I do not confuse it with another similar bike.

### US3 — Take arrival photos

As counter staff, I want to save photos of the bike when it arrives, so that we know what condition it was in.

### US4 — Set a promised date

As counter staff, I want to record the day we promised the bike would be ready, so that we can tell when a repair is late.

#### Acceptance criteria

- The promised date is shown for the repair.
- Each repair shows its own promised date.
- A repair can be identified as late when the promised date has passed.

### US5 — Write a diagnosis

As a mechanic, I want to write what is wrong with the bike, so that there is a clear record of the problem.

### US6 — Add the needed services

As a mechanic, I want to record the services a bike needs, so that we know what work has to be done.

### US7 — BIG STORY: Manage a repair

As shop owner, I want to manage a repair from diagnosis until it is finished, so that I can keep track of the whole repair.

**This story is deliberately too big and is split into the following stories:**

#### US7a — Prepare the repair cost

As a mechanic, I want to record the services needed and their prices, so that the customer can be told how much the repair will cost.

#### US7b — Record the customer's decision

As counter staff, I want to record if the customer accepts or rejects the repair, so that the mechanics know if they can start working.

#### US7c — Finish a repair

As a mechanic, I want to mark a repair as completed, so that the counter staff knows the bike is ready.

### US8 — Check repair status

As counter staff, I want to see if a bike is ready, so that I can answer customers when they call.

#### Acceptance criteria

- The current repair status is visible.
- The screen makes it clear when the bike is ready for pickup.
- Counter staff can see the status without needing information from a mechanic.

### US9 — See late repairs

As shop owner, I want to see repairs that are past their promised date, so that I can notice delays before the customer calls.

#### Acceptance criteria

- Repairs past their promised date are shown as late.
- The promised date is visible for each late repair.
- Repairs that are not late are not shown in the late repairs list.
- If there are no late repairs, the screen says that there are no late repairs.

### US10 — See a bike's repair history

As a mechanic, I want to see a bike's previous repairs, so that I know what has been done to it before.

### US11 — Keep old repair prices

As shop owner, I want old repairs to keep the price that was charged at the time, so that changing the price list does not change past repairs.

### US12 — See service prices online

As a customer, I want to see the service prices online, so that I do not have to call the shop just to ask for a price.

#### Acceptance criteria

- Each public service shows its name and price.
- The price list can be viewed without seeing customer or repair information.
- The services shown use the shop's current price list.

### US13 — Receive the correct bike

As a customer, I want the shop to identify my bike correctly when I pick it up, so that I do not receive someone else's bike.