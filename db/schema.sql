DROP TABLE IF EXISTS alerts;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE transactions (
    txn_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    amount NUMERIC(12,2),
    device TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE alerts (
    alert_id SERIAL PRIMARY KEY,
    user_id INT,
    txn_id INT,
    rule_triggered TEXT,
    risk_level TEXT,
    details TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
