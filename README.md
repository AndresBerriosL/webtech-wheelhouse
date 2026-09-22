# Wheelhouse

Wheelhouse is a neighbourhood bicycle repair shop application built with Ruby on Rails.

The application includes public pages for:

- Home
- Services
- Visiting the workshop
- About

The original project specification from Lab 3 is available in the `docs/` directory.

## Documentation

- [User stories](docs/user-stories.md)
- [Domain model](docs/domain-model.md)
- [Decisions](docs/decisions.md)
- [Wireframes](docs/wireframes.md)

## Requirements

- Ruby 4.0.4
- Rails 8
- Node.js 26.1.0
- npm
- PostgreSQL
- Yarn

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

Create the development and test databases:

```bash
bin/rails db:create
```

## Run the application

Start the application with:

```bash
bin/dev
```

Then open:

```text
http://localhost:3000
```