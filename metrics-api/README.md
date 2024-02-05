# Metrics API

`metrics-api` is a small Ruby on Rails application designed to record and consume metrics. It's built with flexibility in mind, allowing for various types of metrics to be stored, queried, and aggregated.

## Requirements

- **Ruby version:** 3.3.0
- **Rails version:** 7.1.3
- **PostgreSQL:** 14.10 (Homebrew)

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
1. **Start the application**

    ```bash
    rails server
    ```


### Test APP
1. **Start Feature Tests**

    ```bash
    bundle exec cucumber
    ```
1. **Start Unit Tests**

    ```bash
    bundle exec rspec
    ```
### API Documentation
To see the documentation you can visit the next URL:
http://localhost:3000/api-docs/index.html

#### Some Examples

1. **GET**
    ```bash
        curl --request GET \
        --url 'http://localhost:3000/api/v1/metrics?time_frame=day' \
        --header 'Content-Type: application/json' \
        --header 'User-Agent: insomnia/8.6.0'
      ```

2. **POST**
    ```bash
        curl --request POST \
        --url http://localhost:3000/api/v1/metrics \
        --header 'Content-Type: application/json' \
        --header 'User-Agent: insomnia/8.6.0' \
        --data '{
	        "name": "cpu-load",
	        "value": "61.0"
            }'
      ```
