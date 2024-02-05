# CoolMetrics: Frontend + Backend Metrics Application

- [CoolMetrics: Frontend + Backend Metrics Application](#coolmetrics-frontend--backend-metrics-application)
  - [Overview](#overview)
  - [Use Cases](#use-cases)
  - [Application Structure](#application-structure)
  - [Architecture](#architecture)
  - [Backend: metrics-api#](#backend-metrics-api)
      - [Technology Stack](#technology-stack)
      - [Structure](#structure)
        - [Database (Persistence)](#database-persistence)
        - [Models](#models)
        - [Controllers](#controllers)
      - [Technical Decisions and Trade-offs](#technical-decisions-and-trade-offs)
      - [Next Steps and Improvements](#next-steps-and-improvements)
    - [Frontend: metrics-dashboard](#frontend-metrics-dashboard)
      - [Technology Stack](#technology-stack-1)
      - [Key Components](#key-components)
      - [Technical Decisions and Trade-offs](#technical-decisions-and-trade-offs-1)
      - [Next Steps and Improvements](#next-steps-and-improvements-1)
  - [Quick Start](#quick-start)


 ## Overview
Welcome to CoolMetrics, an application designed to post and visualize metrics in real-time. This solution consists of two main components: metrics-api, a Ruby on Rails API backed by PostgreSQL for data persistence, and metrics-dashboard, a React application for the front-end visualization of metrics. This document outlines the technical decisions, architecture, and future enhancement plans for CoolMetrics.

 ## Use Cases
* **Real-time Metrics Submission:** New metrics data, including timestamps, names, and values, can be added to the application.
* **Metrics Visualization:** The application displays metrics in a timeline, offering insights into trends over selectable time frames.
* **Data Aggregation:** Users can view average metric values aggregated by minute, hour, or day to analyze patterns and performance over time.

 ## Application Structure
CoolMetrics is designed with a clear separation of concerns in mind, dividing the workload between a back-end service responsible for data management and a front-end service for data visualization.

* **Back-end (metrics-api):** A Ruby on Rails API that handles data persistence in a PostgreSQL database and provides endpoints for metric submission and retrieval.

* **Front-end (metrics-dashboard):** A React application that consumes the API to present metrics data in a user-friendly and interactive timeline.

* **metrics-generator (metrics-script):** A Bash script designed to simulate real-time metrics submission, aiding in testing and demonstration.


## Architecture

## Backend: metrics-api#
#### Technology Stack

* **Ruby on Rails:** Offers a convention-over-configuration approach that accelerates API development and includes built-in support for RESTful APIs.

* **PostgreSQL:**: Provides advanced data aggregation and manipulation capabilities essential for the metrics' time-based grouping.

#### Structure
An MVC pattern has been used (it does not need a view because it is an API) and it is the standard in rails.

##### Database (Persistence)
* **Tables:** The `metrics` table is central to the application, designed to store individual metrics with fields for name, value, and timestamp.
* **Indexes:** An index on the `name field` of the metrics table ensures quick lookup times for queries filtering by metric names, significantly improving query performance for data retrieval and aggregation.

##### Models 
* **Metric:** Responsible for storing and validating metric data. 

##### Controllers 
* **MetricController:** Provides RESTful endpoints for creating new metrics (POST /metrics) and retrieving aggregated metrics data (GET /metrics), with support for filtering by name and time frames. Also,it implements the logic to aggregate metrics based on the requested time frame (minute, hour, day)

#### Technical Decisions and Trade-offs

* **Authentication & Authorization:** While not implemented in the current scope, future enhancements could include token-based authentication to secure API endpoints. This approach would ensure that metric postings and retrievals are protected against unauthorized access.

* **Error Handling:** In the current implementation, specific error handling strategies beyond basic validation errors are not detailed. Future versions could enhance resilience by handling common errors such as database timeouts or connectivity issues, providing clear error responses to API consumers.

* **API Versioning Strategy:** To manage future API versions and maintain backward compatibility, the application adopt a versioning strategy within the URL path (e.g., /api/v1/metrics for the current version and /api/v2/metrics for future versions). This approach allows for parallel development of different API versions and smoother transition paths for API consumers. Version-specific changes can be managed through namespaced controllers and route configurations to ensure clear separation of logic between versions.
  
* **Testing Strategy:** The application adopts a Behavior-Driven Development (BDD) approach with Cucumber for defining application behavior in plain language (E2E tests), making tests understandable to non-technical stakeholders. Additionally, RSpec is used for unit and integration testing, ensuring robust coverage of models and controllers.

#### Next Steps and Improvements
* **Scalability Considerations:** 
  * **Database Optimization:** Continue to leverage indexes and evaluate query performance, possibly incorporating more complex strategies such as partitioning for large datasets.
  * **Caching:** Introduce caching layers with tools like Redis to reduce database load for frequently accessed data.
  * **Background Processing:** Utilize background job systems like Sidekiq to handle intensive data processing tasks, reducing response times for API requests.
* **Containerization:** Use Docker for easier deployment and scaling.
* **Continuous Integration/Continuous Deployment (CI/CD):** Setting up CI/CD pipelines for automated testing and deployment.


### Frontend: metrics-dashboard

#### Technology Stack

* **React:** Facilitates the creation of dynamic user interfaces, making it an ideal choice for real-time data visualization.
* **Material-UI (MUI):** Utilized for designing a sleek and responsive user interface, leveraging its comprehensive library of ready-to-use components that adhere to Material Design principles.
* **axios:** Employed for making HTTP requests to the backend, simplifying the process of fetching data from the API.
* **React Router:** Manages navigation within the application, enabling seamless routing between different views without reloading the page.

#### Key Components
* **App Component:** Serves as the entry point of the frontend application, integrating Material-UI's ThemeProvider for theme customization and managing the sidebar visibility state. It also sets up routing with React Router to navigate between different parts of the application, although the current implementation primarily focuses on the Dashboard.

* **Dashboard Component:** Acts as the core scene for metrics visualization. It dynamically fetches and displays metrics data based on user-selected time frames (minute, hour, day) using axios for API requests. The useEffect hook triggers data fetching on component mount and at a regular interval, ensuring the displayed data is regularly updated.

* **LineChart Component:** Utilizes the @nivo/line library to render responsive line charts based on the processed metrics data. It is designed to adapt to the current theme and provides a customizable user experience through props like data and xAxisFormat.

#### Technical Decisions and Trade-offs
* **Data Handling:** The application fetches metrics data from the backend using axios, processing this data to fit the structure expected by the LineChart component. State management is handled through React's useState hook, managing states for the time frame selection, metrics data, and fetch errors. The useCallback hook is used to memoize the fetchData function, preventing unnecessary re-creations of this function and optimizing performance during re-renders.

* **Theme and UI Customization:** The application leverages Material-UI's theming capabilities, providing a consistent and customizable design system. The useTheme hook and a custom ColorModeContext are used to toggle between light and dark modes, enhancing the user interface's adaptability.

* **Testing Strategy:**
The testing strategy for the frontend focuses on unit tests for the Dashboard component, verifying its functionality regarding data fetching, state management, and user interaction.

#### Next Steps and Improvements
* **Error Handling:** Implement robust error handling within the Dashboard component to manage and display informative error messages to the user when data fetching fails. This could involve retry mechanisms or more detailed error messages based on the type of error encountered.

* **Performance Optimization:** Introduce performance optimization strategies such as:

  * **Memoization:** Use React.memo for components and useMemo for expensive calculations to avoid unnecessary re-renders.
  * **Code Splitting:** Leverage React's lazy loading and dynamic import() syntax to split the code into smaller chunks, loading them on demand.
* **Testing Enhancements:** Expand the testing suite to cover more components and user interactions. Incorporating integration tests could also validate the application's behavior more comprehensively, especially the interaction between the Dashboard component and the LineChart component.

* **Accessibility and Responsive Design:** Conduct an accessibility audit and ensure the application is fully responsive, providing a seamless experience across all devices.

 ## Quick Start

 To get CoolMetrics up and running, follow these steps:

1. Clone the repository

```bash
  git clone <repository-url>
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
