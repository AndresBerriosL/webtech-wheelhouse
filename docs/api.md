
# Wheelhouse API v1

Base URL: `http://localhost:3000/api/v1`

All endpoints return JSON.

## Endpoints

| Method | Route | Authentication |
|---|---|---|
| GET | /services | Public |
| GET | /services/:id | Public |
| POST | /services | Bearer token |
| GET | /repairs | Bearer token |
| GET | /repairs/:id | Bearer token |

## Authentication

Protected endpoints require the HTTP header:

`Authorization: Bearer YOUR_TOKEN`

The token is stored in encrypted Rails credentials
under `api.token`.

## Services

GET `/services` returns an alphabetically ordered
array of service documents.

GET `/services/:id` returns one service.

Example:

```json
{
  "id": 21,
  "name": "Lab 10 Test Service",
  "price": "42.5",
  "repairs_count": 0
}
```

POST `/services` requires:

```json
{
  "service": {
    "name": "New Service",
    "current_price": "42.50"
  }
}
```

Successful creation returns HTTP 201, the created
service document and a Location header.

## Repairs

GET `/repairs` returns repairs ordered by promised
date and received date.

An optional `state` filter is available:

`GET /repairs?state=picked_up`

GET `/repairs/:id` returns a single repair.

Example:

```json
{
  "id": 12,
  "state": "ready_for_pickup",
  "received_at": "2026-10-07T09:00:00.000Z",
  "promised_on": "2026-10-12",
  "picked_up_at": null,
  "bike": {
    "make": "Specialized",
    "model": "Allez",
    "serial_number": "SPZ-ALZ-114"
  },
  "customer": {
    "name": "Nicolas Perez"
  },
  "lines": [
    {
      "service": "Bearing service",
      "charged_price": "35.0"
    },
    {
      "service": "Wheel bearing service",
      "charged_price": "45.0"
    }
  ],
  "total": "80.0",
  "overdue": true,
  "customer_decision": "accepted"
}
```

## Error responses

Errors use the following format:

```json
{
  "errors": ["Error description"]
}
```

Status codes:

- 400: invalid parameters or state
- 401: missing or invalid authentication token
- 404: resource not found
- 422: validation failed

## Design decisions

Prices are represented as strings rather than
floating-point JSON numbers to preserve decimal
precision.

`repairs_count` is calculated from associated
repair-service records.

Customer phone numbers are not exposed.

Repair lines include service names and charged
prices rather than internal database IDs.

The API is versioned under `/api/v1`.

Collections use Active Record eager loading to avoid
N+1 queries.

## CORS

Public service GET endpoints allow requests from:

- https://andresberriosl.github.io
- http://localhost:5500

Protected endpoints do not allow cross-origin access.

## Personal website

Repository:
https://github.com/AndresBerriosL/webtech-lab-01

Published page:
https://andresberriosl.github.io/webtech-lab-01/

The website retrieves service data using fetch,
async/await and safe DOM manipulation with textContent.

The current API endpoint is localhost:3000, so the
integration requires a locally running Rails server
and is intended for local development testing.
```
