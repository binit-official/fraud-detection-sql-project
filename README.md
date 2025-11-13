# 🛡️ Fraud Detection SQL System

![PostgreSQL](https://img.shields.io/badge/Database-PostgreSQL-336791?style=for-the-badge&logo=postgresql)
![SQL](https://img.shields.io/badge/Language-PL%2FpgSQL-blue?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Active-success?style=for-the-badge)
---

## ⭐ Project Overview

This project detects fraudulent transactions based on **simple, powerful, explainable rules**.  
Whenever a transaction is inserted, the system automatically checks multiple fraud-detection rules and creates alerts instantly.

This project is ideal for:
- SQL beginners who want a strong project
- Interview preparation
- Demonstrating backend logic & data design
- Showing ability to design real-world systems

---

## 📌 Features
- Strong rule-based fraud detection  
- Automatic alert generation  
- Clean relational database design  
- Multiple types of fraud rules  
- Large sample dataset  
- Fully explainable logic  
- No external programming language required  
- Beginner-friendly structure  

---

# 🧩 ER Diagram (ASCII)

```
+-------------+         +--------------+         +-------------+
|  Customers  | 1     n |   Accounts   | 1     n | Transactions|
+-------------+---------+--------------+---------+-------------+
| customer_id |         | account_id   |         | txn_id      |
| name        |         | customer_id  |         | account_id  |
| region      |         | account_type |         | amount      |
| created_at  |         | created_at   |         | txn_time    |
+-------------+         +--------------+         | location    |
                                                  | device_id   |
                                                  +-------------+
                                                           |
                                                           n
                                                           |
                                                  +-------------+
                                                  |   Alerts    |
                                                  +-------------+
                                                  | alert_id    |
                                                  | txn_id      |
                                                  | rule_name   |
                                                  | score       |
                                                  | alert_time  |
                                                  +-------------+
```

---

# 🏗 Relational Schema (Human Description)

### **Customers**
- customer_id (PK)  
- name  
- region  
- created_at  

### **Accounts**
- account_id (PK)  
- customer_id (FK → Customers.customer_id)  
- account_type  
- created_at  

### **Transactions**
- txn_id (PK)  
- account_id (FK → Accounts.account_id)  
- amount  
- txn_time  
- location  
- device_id  

### **Alerts**
- alert_id (PK)  
- txn_id (FK → Transactions.txn_id)  
- rule_name  
- score  
- alert_time  

### **RiskRules**
- rule_id (PK)  
- rule_name  
- threshold  
- velocity_minutes  
- enabled  

---

# 🚨 Fraud Rules Implemented

### **1. High Amount Rule**
Triggers if:
- Amount > ₹50,000  
Meaning: Unusually high-value transfers are suspicious.

---

### **2. Velocity Rule**
Triggers if:
- More than 5 transactions occur within 10 minutes for the same account  
Meaning: Fraud often involves rapid, repeated transactions.

---

### **3. Region Mismatch Rule**
Triggers if:
- Transaction location ≠ customer’s home region  
Meaning: Sudden geographic changes indicate possible misuse.

---

### **4. Device Change Rule**
Triggers if:
- Two back-to-back transactions use different device IDs  
- Time difference < 2 minutes  
Meaning: Fraudsters often switch devices quickly.

---

### **5. Suspicious Location Rule**
Triggers if:
- Transaction originates from:  
  `Dubai, Nigeria, Russia, Unknown`  
Meaning: These locations have higher fraud risk.

---

### **6. Night High-Value Rule**
Triggers if:
- Transaction time: 12 AM – 4 AM  
- Amount > ₹10,000  
Meaning: Most fraud occurs late at night.

---

# 📊 Sample Data (Explanation)

To test the fraud system, the sample dataset includes:

- Normal small transactions  
- High-value suspicious transactions  
- Rapid-fire repeated transactions  
- Mismatched regions  
- Suspicious countries  
- Night-time payments  
- Device-switching scenarios  

These examples ensure that all rules trigger and can be easily demonstrated in interviews.

---

# 🧪 How Testing Works

### ✔️ Test High Amount
Insert any transaction > ₹50,000 → Alert is generated

### ✔️ Test Velocity Rule
Insert 6 transactions for same account within 10 minutes → Alert is generated

### ✔️ Test Region Mismatch
Set customer region = Odisha  
Insert transaction from Delhi → Alert is generated

### ✔️ Test Device Change
Two transactions:
- First from device A  
- Second from device B within 2 mins  
→ Alert triggered

### ✔️ Test Suspicious Location
Insert transaction from Dubai → Alert is generated

### ✔️ Test Night Rule
Insert transaction at 02:00 AM → Alert generated

---

# 🎯 Why This Project Is Useful

- Great SQL portfolio project  
- 100% explainable logic (no ML black box)  
- Strong for data analytics, backend, fraud, banking roles  
- Recruiters love rule-based fraud detection systems  
- Clean real-world schema  
- Demonstrates thinking like a banking system designer  

---

# 🔮 Future Enhancements
- Add ML-based anomaly scoring  
- Add dashboards  
- Add merchant categories  
- Add IP-based rules  
- Add geo-coordinates distance rule  
- Add user-feedback loop for confirmed fraud  

---

# ▶️ How To Run This Project

1. Install PostgreSQL  
2. Create a database (`frauddb`)  
3. Run the schema setup  
4. Add sample data  
5. Insert transactions  
6. Check alerts table  

Everything works automatically because triggers run the fraud rules instantly.

---

# ✔️ Project Complete

This SQL-only fraud detection system is:
- Clean  
- Professional  
- Interview friendly  
- Beginner friendly  
- Real-world applicable  

You can extend it easily or use it directly as your portfolio project.

