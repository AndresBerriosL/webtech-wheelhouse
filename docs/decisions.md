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
