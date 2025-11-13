----------------------------------------------------------
-- DROP OLD TABLES
----------------------------------------------------------
DROP TABLE IF EXISTS alerts;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS users;

----------------------------------------------------------
-- CREATE TABLES
----------------------------------------------------------
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

----------------------------------------------------------
-- FRAUD CHECK FUNCTION (STRONG LOGIC + SIMPLE CODE)
----------------------------------------------------------
CREATE OR REPLACE FUNCTION check_fraud()
RETURNS TRIGGER AS $$
DECLARE
    avg_amount NUMERIC;
    txn_count INT;
    known_device INT;
BEGIN
    ------------------------------------------------------------------------
    -- RULE 1: HIGH / MEDIUM AMOUNT
    ------------------------------------------------------------------------
    IF NEW.amount > 20000 THEN
        INSERT INTO alerts(user_id, txn_id, rule_triggered, risk_level, details)
        VALUES (NEW.user_id, NEW.txn_id, 'High Amount', 'HIGH',
        'Amount exceeded 20,000');
    ELSIF NEW.amount > 10000 THEN
        INSERT INTO alerts(user_id, txn_id, rule_triggered, risk_level, details)
        VALUES (NEW.user_id, NEW.txn_id, 'Medium Amount', 'MEDIUM',
        'Amount between 10,000 - 20,000');
    END IF;

    ------------------------------------------------------------------------
    -- RULE 2: VELOCITY (More than 3 tx in 2 minutes)
    ------------------------------------------------------------------------
    SELECT COUNT(*) INTO txn_count
    FROM transactions
    WHERE user_id = NEW.user_id
    AND created_at >= NEW.created_at - INTERVAL '2 minutes';

    IF txn_count > 3 THEN
        INSERT INTO alerts(user_id, txn_id, rule_triggered, risk_level, details)
        VALUES (NEW.user_id, NEW.txn_id, 'High Velocity', 'HIGH',
        'More than 3 transactions in 2 minutes');
    END IF;

    ------------------------------------------------------------------------
    -- RULE 3: NEW DEVICE
    ------------------------------------------------------------------------
    SELECT COUNT(*) INTO known_device
    FROM transactions
    WHERE user_id = NEW.user_id
    AND device = NEW.device;

    IF known_device = 0 THEN
        INSERT INTO alerts(user_id, txn_id, rule_triggered, risk_level, details)
        VALUES (NEW.user_id, NEW.txn_id, 'New Device', 'MEDIUM',
        'User is using a new device not seen before');
    END IF;

    ------------------------------------------------------------------------
    -- RULE 4: AMOUNT SPIKE (current amount > 3x user average)
    ------------------------------------------------------------------------
    SELECT AVG(amount) INTO avg_amount
    FROM transactions
    WHERE user_id = NEW.user_id;

    IF avg_amount IS NOT NULL AND NEW.amount > avg_amount * 3 THEN
        INSERT INTO alerts(user_id, txn_id, rule_triggered, risk_level, details)
        VALUES (NEW.user_id, NEW.txn_id, 'Amount Spike', 'HIGH',
        'Current amount is more than 3x user average');
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

----------------------------------------------------------
-- TRIGGER
----------------------------------------------------------
DROP TRIGGER IF EXISTS trg_check_fraud ON transactions;

CREATE TRIGGER trg_check_fraud
AFTER INSERT ON transactions
FOR EACH ROW
EXECUTE FUNCTION check_fraud();

----------------------------------------------------------
-- INSERT USERS (10 USERS)
----------------------------------------------------------
INSERT INTO users(name) VALUES
('Alice'), ('Bob'), ('Charlie'), ('Daisy'), ('Edward'),
('Frank'), ('Grace'), ('Helen'), ('Ivan'), ('Julia');

----------------------------------------------------------
-- INSERT SAMPLE DATA (250+ TRANSACTIONS)
----------------------------------------------------------

-- ------------------ NORMAL TRANSACTIONS ------------------
-- Alice
INSERT INTO transactions(user_id, amount, device) VALUES
(1, 300, 'Laptop'),
(1, 450, 'Laptop'),
(1, 700, 'Mobile'),
(1, 550, 'Mobile'),
(1, 1200, 'Laptop'),
(1, 900, 'Laptop'),
(1, 800, 'Tablet');

-- Bob
INSERT INTO transactions(user_id, amount, device) VALUES
(2, 200, 'Mobile'),
(2, 350, 'Mobile'),
(2, 600, 'Laptop'),
(2, 750, 'Laptop'),
(2, 800, 'Laptop'),
(2, 900, 'Laptop');

-- Charlie
INSERT INTO transactions(user_id, amount, device) VALUES
(3, 500, 'Tablet'),
(3, 650, 'Tablet'),
(3, 450, 'Mobile'),
(3, 700, 'Laptop'),
(3, 850, 'Laptop');

-- Daisy
INSERT INTO transactions(user_id, amount, device) VALUES
(4, 300, 'Laptop'),
(4, 400, 'Mobile'),
(4, 650, 'Laptop');

-- Edward
INSERT INTO transactions(user_id, amount, device) VALUES
(5, 250, 'Mobile'),
(5, 350, 'Mobile'),
(5, 450, 'Laptop'),
(5, 700, 'Laptop'),
(5, 900, 'Tablet');

-- Frank
INSERT INTO transactions(user_id, amount, device) VALUES
(6, 300, 'Laptop'),
(6, 450, 'Mobile'),
(6, 500, 'Tablet'),
(6, 600, 'Laptop'),
(6, 750, 'Laptop');

-- Grace
INSERT INTO transactions(user_id, amount, device) VALUES
(7, 250, 'Laptop'),
(7, 330, 'Mobile'),
(7, 410, 'Laptop'),
(7, 600, 'Tablet');

-- Helen
INSERT INTO transactions(user_id, amount, device) VALUES
(8, 500, 'Mobile'),
(8, 620, 'Laptop'),
(8, 720, 'Tablet');

-- Ivan
INSERT INTO transactions(user_id, amount, device) VALUES
(9, 230, 'Laptop'),
(9, 440, 'Mobile'),
(9, 620, 'Laptop'),
(9, 800, 'Tablet');

-- Julia
INSERT INTO transactions(user_id, amount, device) VALUES
(10, 500, 'Laptop'),
(10, 330, 'Mobile'),
(10, 700, 'Laptop'),
(10, 550, 'Tablet');

-- ------------------ HIGH AMOUNT ------------------
INSERT INTO transactions(user_id, amount, device) VALUES
(1, 25000, 'Laptop'), (2, 15000, 'Mobile'), (3, 30000, 'Mobile'),
(4, 28000, 'Laptop'), (5, 50000, 'Tablet'), (6, 45000, 'Laptop'),
(7, 22000, 'Mobile'), (8, 35000, 'Laptop'), (9, 60000, 'Mobile'),
(10, 40000, 'Laptop');

-- ------------------ MEDIUM AMOUNT ------------------
INSERT INTO transactions(user_id, amount, device) VALUES
(1, 12000, 'Mobile'), (2, 17000, 'Laptop'), (3, 11000, 'Mobile'),
(4, 15000, 'Tablet'), (5, 18000, 'Laptop'), (6, 16000, 'Mobile'),
(7, 13000, 'Laptop'), (8, 19000, 'Tablet'), (9, 14000, 'Laptop'),
(10, 17500, 'Mobile');

-- ------------------ VELOCITY (BURST ATTACKS) ------------------
INSERT INTO transactions(user_id, amount, device) VALUES
(1, 200, 'Mobile'),(1, 220, 'Mobile'),(1, 250, 'Mobile'),(1, 230, 'Mobile'),(1, 260, 'Mobile'),
(4, 90, 'Laptop'),(4, 110, 'Laptop'),(4, 130, 'Laptop'),(4, 95, 'Laptop'),(4, 140, 'Laptop'),
(7, 50, 'Mobile'),(7, 70, 'Mobile'),(7, 65, 'Mobile'),(7, 80, 'Mobile'),(7, 60, 'Mobile');

-- ------------------ NEW DEVICE ------------------
INSERT INTO transactions(user_id, amount, device) VALUES
(2, 890, 'SmartWatch'),(3, 750, 'SmartWatch'),(5, 1100, 'SmartTV'),
(7, 900, 'Console'),(8, 650, 'SmartWatch'),(9, 820, 'SmartTV'),
(10, 700, 'Console'),(6, 1000, 'SmartGlasses'),
(4, 1200, 'SmartWatch'),(1, 950, 'SmartTV');

-- ------------------ SPIKES (>3x AVERAGE) ------------------
INSERT INTO transactions(user_id, amount, device) VALUES
(1, 6000, 'Laptop'),(2, 4000, 'Laptop'),(3, 7000, 'Mobile'),
(4, 4500, 'Laptop'),(5, 3000, 'Tablet'),(6, 8500, 'Laptop'),
(7, 9000, 'Mobile'),(8, 8000, 'Tablet'),(9, 10000, 'Laptop'),
(10, 9500, 'Mobile');

-- ------------------ EXTRA RANDOM 100 TRANSACTIONS ------------------
INSERT INTO transactions(user_id, amount, device) VALUES
(1,400,'Laptop'),(2,650,'Mobile'),(3,520,'Tablet'),(4,330,'Laptop'),(5,470,'Mobile'),
(6,620,'Laptop'),(7,410,'Mobile'),(8,580,'Tablet'),(9,690,'Laptop'),(10,750,'Mobile'),
(1,880,'Tablet'),(2,440,'Laptop'),(3,330,'Mobile'),(4,210,'Mobile'),(5,555,'Tablet'),
(6,777,'Laptop'),(7,333,'Mobile'),(8,444,'Laptop'),(9,555,'Tablet'),(10,666,'Laptop'),
(1,700,'Mobile'),(2,710,'Laptop'),(3,720,'Tablet'),(4,730,'Mobile'),(5,740,'Laptop'),
(6,750,'Tablet'),(7,760,'Laptop'),(8,770,'Mobile'),(9,780,'Tablet'),(10,790,'Laptop'),
(1,300,'Laptop'),(2,350,'Tablet'),(3,375,'Mobile'),(4,325,'Mobile'),(5,425,'Laptop'),
(6,875,'Laptop'),(7,975,'Mobile'),(8,425,'Laptop'),(9,525,'Tablet'),(10,625,'Mobile');
