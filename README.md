
# 🧠 Brain-Tumor-Healthcare-Research-Analytics-using-Advanced-SQL

This project applies advanced SQL analytics to a healthcare case study on brain tumour diagnosis, treatment, and research outcomes. Using simulated real-world clinical data, it leverages relational models, complex JOINs, and window functions to generate insights, making it suitable for technical interviews and GitHub portfolios.

---

## 1️⃣ Project Title
**Brain Tumour Healthcare & Research Analytics using Advanced SQL**

---

## 2️⃣ Project Description
This project demonstrates the application of advanced SQL-based data analysis in the healthcare domain, with a focused case study on brain tumour diagnosis, treatment, and clinical research outcomes.  

The dataset simulates real-world clinical data commonly used in neuro-oncology research and hospital analytics. The primary aim is to extract meaningful insights from structured medical data using relational database concepts, complex JOINs, and window functions. The project is designed to be presented in technical interviews and showcased on GitHub as a complete data analytics case study.

---

## 3️⃣ Problem Statement
Brain tumour management involves integrating multiple data sources such as patient demographics, imaging findings, molecular biomarkers, treatment protocols, and survival outcomes. Traditional reporting methods are insufficient to capture complex trends across these dimensions.  

This project addresses the need for structured data analysis by using SQL to:

- Analyze survival outcomes across tumor types  
- Compare treatment effectiveness  
- Evaluate the impact of imaging and genomic biomarkers  
- Assess clinical trial participation and research outcomes  

---

## 4️⃣ Dataset Overview
The dataset consists of five interrelated CSV files representing different aspects of brain tumour healthcare:

- **Patients**: Demographics, tumor type, diagnosis date, hospital, country  
- **Imaging**: MRI-based tumor volume, radiomic score, contrast enhancement  
- **Genomics**: MGMT, EGFR, IDH status, TMB, immune biomarker score  
- **Treatments**: Treatment type, response, survival duration  
- **Clinical Trials**: Trial enrollment, phase, and outcomes  

Each table contains 1000 records, enabling realistic analytical scenarios.

---

## 5️⃣ Database Schema
- **Patients (PK: patient_id)**  
  - One-to-Many → Imaging  
  - One-to-One → Genomics  
  - One-to-Many → Treatments  
  - One-to-Many → Clinical_Trials  

All tables are linked using `patient_id` as the foreign key.

---

## 6️⃣ Analytical Objectives
- Ranking patients by survival within tumor types  
- Identifying top-performing treatments  
- Segmenting patients into risk groups  
- Comparing trial-enrolled vs non-enrolled patient outcomes  
- Hospital-level and population-level performance analysis  

---

## 7️⃣ SQL Concepts Demonstrated
- Multi-table JOINs  
- Window functions: `RANK()`, `DENSE_RANK()`, `ROW_NUMBER()`, `NTILE()`  
- `GROUP BY` vs `PARTITION BY`  
- Aggregate functions with ordering  
- Creation and management of database VIEWS  

---

## 8️⃣ SQL Queries and Analysis
Below are a few key analytical queries included in the project:

1. Rank patients by survival months within each tumor type  
2. Identify the top 3 patients per tumor type using `DENSE_RANK()`  
3. Assign sequential patient numbers per hospital using `ROW_NUMBER()`  
4. Divide patients into quartiles based on radiomic score using `NTILE(4)`  
5. Compare individual survival against tumor-type averages using `AVG() OVER()`
   
## 9️⃣ Execution and Output
All queries were executed successfully in MySQL Workbench. Query output snapshots are included in the repository to visualize results.

📌 **Complete SQL Query Script:**  
👉 **[Advanced_SQL_Project.sql](Advanced_SQL_Project.sql)**

### 📊 Query Output Snapshots

# Query 1 - Output Screenshot
![Query Output - 1](/Images/Output_1.jpg)
# Query 2 - Output Screenshot
![Query Output - 2](/Images/Output_2.jpg)
# Query 3 - Output Screenshot
![Query Output - 3](/Images/Output_3.jpg)
# Query 4 - Output Screenshot
![Query Output - 4](/Images/Output_4.jpg)
# Query 5 - Output Screenshot
![Query Output - 5](/Images/Output_5.jpg)

---

## 🔑 10️⃣ Key Insights Derived from Analysis
- **Tumor-wise Survival Patterns**: Glioblastoma (GBM) shows significantly lower survival than low-grade tumors  
- **Treatment Effectiveness**: Targeted and combination therapies improve survival outcomes  
- **Biomarker Impact**: Favorable genomic and immune biomarkers correlate with better prognosis  
- **Imaging-Based Prognosis**: Lower tumor volume and higher radiomic scores indicate better outcomes  
- **Clinical Trial Participation**: Trial-enrolled patients show measurable survival differences  
- **Hospital-Level Variations**: Survival outcomes vary across hospitals  

These insights demonstrate how structured healthcare data can be transformed into meaningful clinical and research intelligence using SQL.

---

## 11️⃣ Technology Stack
- **Database**: MySQL  
- **Language**: SQL (Advanced SQL)  
- **Data Format**: CSV  
- **Tools**: MySQL Workbench  
- **Version Control**: Git & GitHub  
- **Domain**: Healthcare & Biomedical Analytics  

---

## 12️⃣ Project Usage
This project can be used for:

- Technical interviews (SQL & Data Analytics)  
- Academic evaluation and lab assessments  
- Healthcare analytics demonstrations  
- GitHub portfolio presentation  

---

## 13️⃣ How to Run the Project
1. Create the database schema in MySQL  
2. Import the CSV files into corresponding tables  
3. Execute queries from **Advanced_SQL_Project.sql**  
4. Review query outputs and insights  

---

## 14️⃣ Disclaimer
This dataset is synthetically generated for educational and demonstration purposes only. It does not contain real patient data.
