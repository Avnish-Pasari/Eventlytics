# 🎟️ Eventlytics – Ticket Intelligence Platform  

Eventlytics is a data analytics platform built entirely with **SQL and PostgreSQL** to analyze and visualize ticket sales, venue utilization, and accessibility insights across major event venues in Toronto.  
It showcases advanced **data modeling**, **query optimization**, and **business analysis** techniques applied to real-world ticketing data.  

---

## 🧠 Overview  

Eventlytics simulates a complete **concert ticketing ecosystem**, tracking ownership, venues, seats, concerts, and ticket purchases.  
The project was designed to uncover **data-driven insights** such as:  
- Total revenue per concert and venue  
- Percentage of seats sold and occupancy trends  
- Accessibility ratios (mobility seating)  
- Customer purchasing behavior and high-demand events  

All logic is implemented through **relational schemas, joins, aggregations, and views**, emphasizing performance, correctness, and interpretability.  

---

## 🏗️ Schema Design  

The database schema follows **3rd Normal Form (3NF)** and enforces referential integrity between seven key entities:  

| Table | Description |
|--------|-------------|
| `Owner` | Stores venue ownership details |
| `Venue` | Contains venue metadata and address |
| `Seats` | Seat-level data including section and mobility access |
| `Concert` | Event name, venue, and date/time |
| `Price` | Ticket pricing per concert and section |
| `Users` | Registered users |
| `Purchase` | Ticket purchase records with quantity and timestamps |

Each layer builds toward analytical queries that produce interpretable, business-relevant results.

---

## ⚙️ Features & Analysis  

### 1️⃣ **Venue Revenue and Utilization**  
- Calculated total ticket value sold per concert using aggregation views (`sum_concert`, `unioned_total`).  
- Computed seat occupancy percentages per venue to identify underperforming events.  

### 2️⃣ **Ownership Insights**  
- Linked ownership data to venue activity, identifying organizations managing the highest-performing venues.  

### 3️⃣ **Accessibility Analytics**  
- Measured the percentage of accessible (mobility) seating across all venues, promoting inclusion insights.  

### 4️⃣ **Customer Purchase Trends**  
- Ranked users by total ticket quantity purchased to detect top customers and engagement patterns.  

---

## 🧩 Technologies Used  

- **PostgreSQL** – core database engine  
- **SQL** – queries, joins, set operations, aggregations, and view creation  
- **psql** – execution environment for running schema and data scripts  
- **Linux Shell Scripts** – automated dataset loading and query execution  

---

## 📊 Example Output  

| Concert Name | Venue | Total Value | % Sold |
|---------------|--------|--------------|--------|
| Mariah Carey – Merry Christmas to All | Scotiabank Arena | \$986 | 3.3% |
| Ron Sexsmith | Massey Hall | \$130 | 4.0% |
| TSO – Elf in Concert | Roy Thomson Hall | \$159 | 4.8% |

---

## 🧱 Files  

| File | Purpose |
|------|----------|
| `schema.ddl` | Database schema definitions |
| `data.sql` | Dataset insertion for venues, concerts, and users |
| `q1.sql` – `q4.sql` | Analytical SQL queries (revenue, ownership, accessibility, customers) |
| `runner.txt` | Automation script to execute schema, data, and queries in sequence |
| `demo.txt` | Sample outputs from PostgreSQL console |

