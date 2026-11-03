# Decisions

## 1. Do we need to keep the previous owners of a bike?

**Question:** If a bike is sold, should the system keep a history of its previous owners?

**Assumption:** For now, the bike only stores its current owner. Its repair history stays linked to the bike itself.

**If the answer is yes:** We would need another table to store the ownership history of each bike.


## 2. Does every repair need customer approval?

**Question:** Does the shop need approval before every repair, or only for some repairs?

**Assumption:** Simple repairs can be done directly, while bigger repairs may need a diagnosis and customer approval first.

**If the answer is that every repair needs approval:** Every repair would have to go through the approval states before work can begin.


## 3. Do we need to know which mechanic worked on a repair?

**Question:** Should the system record which mechanic worked on each repair?

**Assumption:** For now, repairs are not assigned to a specific mechanic.

**If the answer is yes:** We would need to store mechanics and connect them to repairs.


## Lab 11 — Authentication and roles

Wheelhouse uses the native Rails 8 authentication generator.

Accounts authenticate with an email address and a password.
Passwords are stored using bcrypt digests rather than plaintext.

### Account roles

Each user has one of three roles:

- `owner`: the workshop owner, with the highest level of responsibility.
- `mechanic`: a worker responsible for diagnosing and repairing bicycles.
- `counter`: a worker responsible for receiving bicycles and interacting with customers.

The default role is `counter` because it represents the least privileged account in our role hierarchy. A public registration must never grant owner or mechanic privileges automatically.

Roles are defined in the User model using an Active Record enum.

### Staff associations

A user may optionally belong to a staff member.

Each staff member can have at most one account. This is enforced with a unique database index and a foreign key.

A staff member cannot be deleted while an account belongs to them.

### Repair attribution

A repair records the user who originally received it.

The account comes from the authenticated session, never from submitted form parameters. Existing repairs may have no receiving account.

### Email delivery

In development, password reset and welcome emails are written to files in `tmp/sent_emails`.

No external SMTP provider or email credentials are required.


## Lab 12 — Authorization with Pundit

### Authorization strategy

Wheelhouse uses Pundit to control access to customers, bikes, repairs, services, and staff members.

Each resource has its own policy. ApplicationPolicy denies access by default.

Policies receive the authenticated user through the ApplicationController's pundit_user method. Policies never access the session directly.

In development, ApplicationController verifies that controller actions perform authorization and that indexes use policy scopes.

### Public actions and verification exceptions

The following actions are excluded from the global Pundit verification:

| Controller | Actions | Reason |
|---|---|---|
| PagesController | home, visit, about | Informational pages without resource-specific operations |
| SessionsController | new, create, destroy | Signing in and signing out must work independently of resource policies |
| RegistrationsController | new, create | Visitors must be able to create an account |
| PasswordsController | new, create, edit, update | Visitors must be able to recover their passwords |

These exceptions do not disable authentication requirements. The informational pages still require an authenticated session.

ServicesController#index and ServicesController#show remain accessible without signing in, but explicitly use Pundit authorization. The services index uses a policy scope.

### Repair visibility

Owners and counter staff can read all repairs.

Mechanics can read only repairs assigned to the staff member linked to their account.

Repair lists are filtered using RepairPolicy::Scope.

### Repair editing

Owners can edit every repair, including repairs that have been picked up.

Counter staff can edit repairs that have not been picked up.

Mechanics can edit only their own repairs that have not been picked up.

Mechanics may change the state, diagnosis, and intake photos. Other submitted attributes are discarded using the policy's permitted_attributes method.

### Denied requests

Unauthorized actions return HTTP 403 using the application's custom forbidden page.

Unauthenticated visitors attempting to open protected pages are redirected to sign in.

### JSON API

The existing /api/v1 endpoints retain their Bearer Token authentication.

The API inherits from ActionController::API rather than ApplicationController, so the browser authorization callbacks do not change its behavior.
