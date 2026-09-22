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

On my Windows setup, PostgreSQL uses:

- Role: `postgres`
- Port: `5433`

Before running Rails in Windows CMD, set the PostgreSQL connection variables:

```bat
set PGPORT=5433
set PGUSER=postgres
set PGPASSWORD=YOUR_POSTGRES_PASSWORD
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