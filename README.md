# Wheelhouse

Wheelhouse is a bicycle repair shop application built with Ruby on Rails.

The application includes pages for:

- Home
- Customers
- Bikes
- Repairs
- Services
- Staff
- Visiting the workshop
- About

Customers, bikes, repairs, services and staff have list and detail pages. The information is read from a PostgreSQL database.

## Documentation

- [User stories](docs/user-stories.md)
- [Domain model](docs/domain-model.md)
- [Decisions](docs/decisions.md)
- [Wireframes](docs/wireframes.md)

## Requirements

- Ruby 4.0.4
- Rails 8
- PostgreSQL
- Node.js
- Yarn

The development database uses PostgreSQL.

The application uses PostgreSQL. On my Windows setup the PostgreSQL role is `postgres`.

Before running Rails in Windows CMD, set the PostgreSQL connection variables:

```bat
$env:POSTGRES_PASSWORD = Read-Host "Contraseña de PostgreSQL"
```

If PostgreSQL is running on a non-default port, also set `PGPORT`. For example, my local installation uses:

```bat
set PGPORT=5433
```

## Setup

Clone the repository:

```bash
git clone https://github.com/AndresBerriosL/webtech-wheelhouse.git
cd webtech-wheelhouse
```

Install Ruby dependencies:

```bash
bundle install
```

Install JavaScript dependencies:

```bash
yarn install
```

Build the CSS:

```bash
yarn build:css
```

Create the database, load the schema and seed the data:

```bat
ruby bin\rails db:setup
```

## Run the application

Start the Rails server:

```bat
ruby bin\rails server
```

Then open:

```text
http://localhost:3000
```

## Main pages

```text
http://localhost:3000/customers
http://localhost:3000/bikes
http://localhost:3000/repairs
http://localhost:3000/services
http://localhost:3000/staff_members
```


---

## Lab 10 — JSON API

Wheelhouse provides a versioned JSON API for
accessing services and repairs.

### Requirements

- Ruby and Bundler
- Ruby on Rails 8
- PostgreSQL
- Node.js and Yarn

### Installation

Clone the repository:

```bash
git clone https://github.com/AndresBerriosL/webtech-wheelhouse.git
cd webtech-wheelhouse
```

Install dependencies:

```bash
bundle install
yarn install
```

Configure PostgreSQL credentials and initialize
the database:

```bash
ruby bin/rails db:prepare
```

Build the CSS:

```bash
yarn build:css
```

Start the Rails server:

```bash
ruby bin/rails server
```

The application will be available at:

http://localhost:3000

### API Authentication

Protected endpoints use Bearer Token authentication.

Generate a secure token:

```bash
ruby -rsecurerandom -e "puts SecureRandom.hex(32)"
```

Store it in Rails encrypted credentials:

```bash
ruby bin/rails credentials:edit
```

Add the following structure:

```yaml
api:
  token: "YOUR_GENERATED_TOKEN"
```

Never commit the master key or share the API token.

### API Endpoints

Public:

- `GET /api/v1/services`
- `GET /api/v1/services/:id`

Authenticated:

- `POST /api/v1/services`
- `GET /api/v1/repairs`
- `GET /api/v1/repairs/:id`

Example:

```bash
curl http://localhost:3000/api/v1/services
```

For protected endpoints, include:

`Authorization: Bearer YOUR_TOKEN`

Full documentation: [docs/api.md](docs/api.md)

### Personal Website Integration

Repository:
https://github.com/AndresBerriosL/webtech-lab-01

Published website:
https://andresberriosl.github.io/webtech-lab-01/

The personal website uses JavaScript fetch requests
to retrieve services and prices from Wheelhouse.

For local testing, run Rails on port 3000 and
serve the personal website on port 5500.

The current localhost API URL is intended for
local development. Public deployment requires
a reachable HTTPS API endpoint.
```


---

## Lab 11 — Authentication and Workshop Accounts

Wheelhouse uses the native Rails 8 authentication system.

### Authentication

The application supports:

- Signing in and signing out
- Account registration
- Password recovery
- Welcome emails
- User roles
- Repair attribution

Passwords are stored securely using bcrypt password digests.

### Roles

Users have one of three roles:

- `owner`
- `mechanic`
- `counter`

New accounts receive the `counter` role automatically.

Accounts may optionally be linked to staff members.

### Development Accounts

The following accounts are created by `db/seeds.rb`.

These credentials are intended **only for local development**.

| Email | Role | Password |
|---|---|---|
| carlos@wheelhouse.cl | owner | CarlosOwner2026! |
| diego@wheelhouse.cl | mechanic | DiegoMechanic2026! |
| valentina@wheelhouse.cl | mechanic | ValentinaMechanic2026! |
| matias@wheelhouse.cl | mechanic | MatiasMechanic2026! |
| fernanda@wheelhouse.cl | counter | FernandaCounter2026! |
| visitor@wheelhouse.cl | counter | VisitorCounter2026! |

The visitor account has no associated staff member.

### Starting the Application

After installing dependencies and configuring PostgreSQL, run:

```bash
ruby bin/rails db:prepare
ruby bin/rails db:seed
ruby bin/rails server
```

Open the application:

http://localhost:3000

Sign in at:

http://localhost:3000/session/new

Create an account at:

http://localhost:3000/registration/new

### Development Emails

The application does not send real emails.

Welcome emails and password reset emails are written to:

`tmp/sent_emails/`

No SMTP credentials or external email provider are required.

To preview mailers in the browser, visit:

http://localhost:3000/rails/mailers

### Access Control

Public pages:

- Service list
- Individual service page
- Sign in
- Registration
- Password recovery

All other application pages require an authenticated session.

The JSON API continues to use Bearer Token authentication independently of browser sessions.

### Repair Attribution

Every newly created repair records the currently authenticated account as the person who received the bicycle.

Existing repairs may have no receiving account.

