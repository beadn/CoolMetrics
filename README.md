# CoolMetrics: Frontend + Backend Metrics Application

- [CoolMetrics: Frontend + Backend Metrics Application](#coolmetrics-frontend--backend-metrics-application)
  - [Overview](#overview)
  - [Technical Decisions and Architecture](#technical-decisions-and-architecture)
    - [Backend: metrics-api](#backend-metrics-api)
      - [Technology Stack](#technology-stack)
      - [Structure](#structure)
        - [Database (Persistence)](#database-persistence)
        - [Models \& Controllers](#models--controllers)
      - [Technical Decisions and Trade-offs](#technical-decisions-and-trade-offs)
      - [Next Steps and Improvements](#next-steps-and-improvements)
    - [Frontend: metrics-dashboard](#frontend-metrics-dashboard)
      - [Technology Stack](#technology-stack-1)
      - [Key Components](#key-components)
      - [Technical Decisions and Trade-offs](#technical-decisions-and-trade-offs-1)
      - [Next Steps and Improvements](#next-steps-and-improvements-1)
  - [Quick Start](#quick-start)


 ## Overview
**Welcome to CoolMetrics!** 

CoolMetrics addresses the need for a generic metrics analysis tool that can be tailored to any sector.It is designed to collect, store, and analyze metrics. Aimed at users who need to monitor and analyze metrics data. This document outlines the technical decisions, architecture, and future enhancement plans for CoolMetrics.

 ## Technical Decisions and Architecture
At its core, CoolMetrics exemplifies a design philosophy anchored in clarity and scalability, eschewing unnecessary complexity to foster an environment conducive to adaptation and growth. The architecture is compartmentalized into distinct, focused components:

* `metrics-api:` A Ruby on Rails-based API that serves as the backbone for metrics collection and storage

* `metrics-dashboard:` A React-powered frontend that provides an intuitive interface for metrics visualization.

* `metrics-generator (metrics-script):`  A testing utility crafted as a Bash script to simulate the continuous submission of metrics, facilitating thorough testing and demonstration.


### Backend: metrics-api
#### Technology Stack

* `Ruby on Rails` offers rapid API development with its convention-over-configuration paradigm, perfectly complementing our need for a RESTful API framework.

* `PostgreSQL` brings to the table sophisticated data aggregation capabilities, crucial for the time-based analysis of metrics.

#### Structure
Leveraging the MVC pattern (sans views, given its API-centric nature), our backend architecture is a testament to the robustness and scalability inherent to Rails.

##### Database (Persistence)
* The `metrics` table is the backbone of our database schema, designed to store metrics with attributes for name, value, and timestamp.
* Indexing on the `name` field enhances query performance, facilitating efficient metric retrieval and aggregation.

##### Models & Controllers
* The `Metric` model encapsulates the essence of our data, ensuring integrity and validation.

* `MetricController` is the conduit through which metrics are both ingested (POST) and queried (GET), with aggregation logic finely tuned for minute, hour, and day breakdowns.

#### Technical Decisions and Trade-offs

* This version dispenses with `authentication and authorization strategy`; however, a system based on key API Or OAth2.0 could be implemented for the future.

* In the current implementation, specific `error handling strategies` beyond basic validation errors are not implemented. Future versions could enhance resilience by handling common errors such as database timeouts or connectivity issues, providing clear error responses to API consumers.

* The application adopt a `API versioning strategy` within the URL path (e.g., /api/v1/metrics for the current version and /api/v2/metrics for future versions). This approach allows for parallel development of different API versions and smoother transition paths for API consumers. Version-specific changes can be managed through namespaced controllers and route configurations to ensure clear separation of logic between versions.
  
* The application adopts a `Behavior-Driven Development (BDD)` approach with Cucumber for defining application behavior in plain language (**E2E tests**), making tests understandable to non-technical stakeholders. Additionally, **RSpec** is used for **unit and integration testing**.

#### Next Steps and Improvements
* **Scalability Considerations:** 
  * **Database Optimization:** Continue to leverage indexes and evaluate query performance, possibly incorporating more complex strategies such as partitioning for large datasets.
  * **Caching:** Introduce caching layers with tools like Redis to reduce database load for frequently accessed data.
  * **Background Processing:** Utilize background job systems like Sidekiq to handle intensive data processing tasks, reducing response times for API requests.
* **Containerization:** Use Docker for easier deployment and scaling.
* **Continuous Integration/Continuous Deployment (CI/CD):** Setting up CI/CD pipelines for automated testing and deployment.


### Frontend: metrics-dashboard

#### Technology Stack

* `React:` Facilitates the creation of dynamic user interfaces, making it an ideal choice for real-time data visualization.

#### Key Components
* `App:` Serves as the entry point of the frontend application, integrating Material-UI's ThemeProvider for theme customization and managing the sidebar visibility state. It also sets up routing with React Router to navigate between different parts of the application, although the current implementation primarily focuses on the Dashboard.

* `Dashboard:` Acts as the core scene for metrics visualization. It dynamically fetches and displays metrics data based on user-selected time frames (minute, hour, day) using axios for API requests. The useEffect hook triggers data fetching on component mount and at a regular interval, ensuring the displayed data is regularly updated.

* `LineChart:` Utilizes the @nivo/line library to render responsive line charts based on the processed metrics data. It is designed to adapt to the current theme and provides a customizable user experience through props like data and xAxisFormat.

#### Technical Decisions and Trade-offs
* `Data Handling`: The application fetches metrics data from the backend using axios, processing this data to fit the structure expected by the LineChart component. State management is handled through React's useState hook, managing states for the time frame selection, metrics data, and fetch errors. The useCallback hook is used to memoize the fetchData function, preventing unnecessary re-creations of this function and optimizing performance during re-renders.

* `UX\UI`:In the current version, enhancements to the interface and user experience have been minimal, adhering to a standard approach. Recognizing the critical importance of these elements it is an aspect that can be improved in the future.
  * **Theme and UI Customization:** The application leverages Material-UI's theming capabilities, providing a consistent and customizable design system. The useTheme hook and a custom ColorModeContext are used to toggle between light and dark modes, enhancing the user interface's adaptability.  
  
* The `testing strategy` focuses on unit tests for the Dashboard component, verifying its functionality regarding data fetching, state management, and user interaction. Other kind of test can be incorporated in the future.

#### Next Steps and Improvements
* **Error Handling:** Implement robust error handling within the Dashboard component to manage and display informative error messages to the user when data fetching fails. This could involve retry mechanisms or more detailed error messages based on the type of error encountered.

* **Performance Optimization:** Introduce performance optimization strategies such as:

  * **Memorization:** Use React.memo for components and useMemo for expensive calculations to avoid unnecessary re-renders.
  * **Code Splitting:** Leverage React's lazy loading and dynamic import() syntax to split the code into smaller chunks, loading them on demand.
* **Testing Enhancements:** Expand the testing suite to cover more components and user interactions. Incorporating integration tests could also validate the application's behavior more comprehensively, especially the interaction between the Dashboard component and the LineChart component.

* **Accessibility and Responsive Design:** Conduct an accessibility audit and ensure the application is fully responsive, providing a seamless experience across all devices.

 ## Quick Start

 To get CoolMetrics up and running, follow these steps:

1. Clone the repository

```bash
  git clone https://github.com/beadn/CoolMetrics.git
```
2. Backend setup

```bash
  cd metrics-api
  bundle install
  rails db:create db:migrate
  rails db:seed
  rails s
```
3. Frontend setup in a new terminal

```bash
  cd ../metrics-dashboard
  npm install
  npm start
```
4. Generate metrics in real-time

```bash
  ./metrics_script.sh
```
Detailed instructions for setting up and running both the **metrics-api** and **metrics-dashboard** are provided in their respective READMEs. This includes environment setup, database migrations, and server start-up procedures. 
