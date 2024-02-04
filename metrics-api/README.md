# Metrics API

`metrics-api` is a small Ruby on Rails application designed to record and consume metrics. It's built with flexibility in mind, allowing for various types of metrics to be stored, queried, and aggregated.

## Requirements

- **Ruby version:** 3.3.0
- **Rails version:** 7.1.3
- **Database:** PostgreSQL

## Getting Started

To get a local copy up and running, follow these simple steps.

### Setup

1. **Clone the repository**

    ```bash
    git clone https://github.com/beadn/CoolMetrics.git
    cd CoolMetrics/metrics-api
    ```

2. **Install Dependencies**

    ```bash
    bundle install
    ```

3. **Setup Database**

    ```bash
    rails db:create db:migrate
    ```

    Optionally, you can seed the database with initial data:

    ```bash
    rails db:seed
    ```

### Running the Application
To start the Rails server:

    ```bash
    rails s
    ```
### API Documentation
To see the documentation you can visit the next URL:
http://localhost:3000/api-docs/index.html

### Deployment

To deploy this application, you can follow the standard Rails deployment methods. If deploying to Heroku, the following steps are a general guideline:

1. **Create a Heroku app**

    ```bash
    heroku create metrics-api

2. **Deploy your application to Heroku**

    ```bash
    git push heroku main

3. **Migrate your database on Heroku**

    ```bash
    heroku run rails db:migrate


### License
Distributed under the MIT License. See LICENSE for more information.