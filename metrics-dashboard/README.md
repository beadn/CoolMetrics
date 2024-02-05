# Metrics Dashboard

`metrics-dashboard` is a small react application designed to show metrics in a timeline. The project uses `metrics-api` to be fetch the metrics data.


![plot](./public/dashboard.png)


## Requirements

- **node:** v21.6.1
- **npm:** v10.2.4
- **metrics-api:** v1:0 

## Getting Started

This project was bootstrapped with [Create React App](https://github.com/facebook/create-react-app).

### Setup

1. **Clone the repository**

    ```bash
    git clone https://github.com/beadn/CoolMetrics.git
    cd CoolMetrics/metrics-dashboard
    ```

1. **Installation**
    ```bash
    npm install
    ```



### Running the Application

1. **Start server**

    See instructions in: `../metrics-api/README.md` 

    **NOTE:** The server should be running in: http://localhost:3000/. It is recommended to seed the database with `rails db:seed`  to have initial mock data in the database.



2. **Start the application**

    ```bash
    npm start 
    ```
3. **Visit App**

    `http://localhost:3005/` 

### Test APP
1. **Start Unit Tests**

    ```bash
    npm test
    ```
