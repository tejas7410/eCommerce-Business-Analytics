# eCommerce Business Analysis

This project is an **end-to-end data analysis** of an eCommerce platform using **MySQL** and **Power BI**.  
It includes data cleaning, SQL-based KPI calculations, and a Power BI dashboard for interactive insights.

---

## **Project Overview**

- **Database:** MySQL (8 relational tables – customers, orders, order_items, payments, products, sellers, reviews, geolocation).
- **Dashboard Tool:** Power BI.
- **Objective:** Analyze customer behavior, product performance, revenue trends, and operational KPIs.

---

## **Key Features**

- **SQL-based KPIs:**
  - Total revenue, average order value (AOV), top categories, top states, review analysis.
- **Power BI Dashboard:**
  - Monthly revenue trend.
  - Top-performing products and categories.
  - Customer retention and growth visualization.
  - Review score vs delivery performance.
- **Data Insights:**
  - 80% of revenue comes from 5 product categories.
  - Late deliveries are strongly correlated with low review scores.
  - Payment type preference shows 65% of customers prefer credit card.

---

## **Dashboard Preview**

Below are screenshots of the interactive Power BI dashboard:

### **1. Business Overview**

![Business Overview](/DashBoard.png)

### **2. Review & Delivery Analysis**

![ERD](/ERD.png)

---

## **Repository Structure**

---

ecommerce-business-analysis/
│
├── README.md # Project documentation
│ ├── Myqlsetup.sql # Database schema & data loading
│ ├── kPI.sql # KPI queries
│ └── Analysis_queries.sql # Business analysis queries
└── images/ # Dashboard screenshots
├── ERD.png

---

## **Setup Instructions**

### **1. Database Setup**

- Import all CSV files into MySQL using `schema_setup.sql`.
- Verify data by running sample queries.

### **2. Power BI Setup**

- Connect Power BI to MySQL using **ODBC** or **MySQL connector**.
- Import all tables and create relationships.
- Use `kpi_queries.sql` as the source for creating DAX measures and visuals.

### **3. Dashboard**

- Open **eCommerce_Analysis.pbix** to view the complete dashboard.
- Export as PDF for sharing: **File → Export → Export to PDF**.

---

## **Tech Stack**

- **Database:** MySQL 8.0
- **Visualization:** Power BI
- **Languages:** SQL, DAX
- **Tools:** MySQL Workbench, Power BI Desktop

---

## **Author**

**Tejas Kangule**  
[GitHub](https://github.com/tejas7410)

---
