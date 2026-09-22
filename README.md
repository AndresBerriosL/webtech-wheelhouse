# Wheelhouse

Wheelhouse is a bicycle repair shop application built with Ruby on Rails.

The application currently includes public pages for:

- Home
- Services
- Visiting the workshop
- About

The services page reads its information from the PostgreSQL database.

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

Before running Rails in Windows CMD:

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

Create the database, load the schema and seed the data:

```bat
ruby bin\rails db:setup
```

## Run the application

Start the application:

```bat
ruby bin\rails server
```

Then open:

```text
http://localhost:3000
```

The services page is available at:

```text
http://localhost:3000/services
```