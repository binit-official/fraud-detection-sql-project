----------------------------------------------------------
-- USERS (10 Users)
----------------------------------------------------------
INSERT INTO users(name) VALUES
('Alice'),
('Bob'),
('Charlie'),
('Daisy'),
('Edward'),
('Frank'),
('Grace'),
('Helen'),
('Ivan'),
('Julia');


----------------------------------------------------------
-- NORMAL SPENDING DATA (PER USER)
----------------------------------------------------------

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


----------------------------------------------------------
-- HIGH AMOUNT (Triggers Rule 1 High Risk)
----------------------------------------------------------
INSERT INTO transactions(user_id, amount, device) VALUES
(1, 25000, 'Laptop'),
(2, 15000, 'Mobile'),
(3, 30000, 'Mobile'),
(4, 28000, 'Laptop'),
(5, 50000, 'Tablet'),
(6, 45000, 'Laptop'),
(7, 22000, 'Mobile'),
(8, 35000, 'Laptop'),
(9, 60000, 'Mobile'),
(10, 40000, 'Laptop');


----------------------------------------------------------
-- MEDIUM AMOUNT (Triggers Rule 1 Medium Risk)
----------------------------------------------------------
INSERT INTO transactions(user_id, amount, device) VALUES
(1, 12000, 'Mobile'),
(2, 17000, 'Laptop'),
(3, 11000, 'Mobile'),
(4, 15000, 'Tablet'),
(5, 18000, 'Laptop'),
(6, 16000, 'Mobile'),
(7, 13000, 'Laptop'),
(8, 19000, 'Tablet'),
(9, 14000, 'Laptop'),
(10, 17500, 'Mobile');


----------------------------------------------------------
-- VELOCITY RULE (More than 3 tx in 2 minutes)
----------------------------------------------------------

-- Alice Burst
INSERT INTO transactions(user_id, amount, device) VALUES
(1, 200, 'Mobile'),
(1, 220, 'Mobile'),
(1, 250, 'Mobile'),
(1, 230, 'Mobile'),
(1, 260, 'Mobile');

-- Daisy Burst
INSERT INTO transactions(user_id, amount, device) VALUES
(4, 90, 'Laptop'),
(4, 110, 'Laptop'),
(4, 130, 'Laptop'),
(4, 95, 'Laptop'),
(4, 140, 'Laptop');

-- Grace Burst
INSERT INTO transactions(user_id, amount, device) VALUES
(7, 50, 'Mobile'),
(7, 70, 'Mobile'),
(7, 65, 'Mobile'),
(7, 80, 'Mobile'),
(7, 60, 'Mobile');


----------------------------------------------------------
-- NEW DEVICE RULE
----------------------------------------------------------
INSERT INTO transactions(user_id, amount, device) VALUES
(2, 890, 'SmartWatch'),
(3, 750, 'SmartWatch'),
(5, 1100, 'SmartTV'),
(7, 900, 'Console'),
(8, 650, 'SmartWatch'),
(9, 820, 'SmartTV'),
(10, 700, 'Console'),
(6, 1000, 'SmartGlasses'),
(4, 1200, 'SmartWatch'),
(1, 950, 'SmartTV');


----------------------------------------------------------
-- SUDDEN SPIKE RULE (Amount > 3x Average)
----------------------------------------------------------
INSERT INTO transactions(user_id, amount, device) VALUES
(1, 6000, 'Laptop'),
(2, 4000, 'Laptop'),
(3, 7000, 'Mobile'),
(4, 4500, 'Laptop'),
(5, 3000, 'Tablet'),
(6, 8500, 'Laptop'),
(7, 9000, 'Mobile'),
(8, 8000, 'Tablet'),
(9, 10000, 'Laptop'),
(10, 9500, 'Mobile');


----------------------------------------------------------
-- EXTRA RANDOM TRANSACTIONS (100+ EXTRA)
----------------------------------------------------------
INSERT INTO transactions(user_id, amount, device) VALUES
(1, 400, 'Laptop'),
(2, 650, 'Mobile'),
(3, 520, 'Tablet'),
(4, 330, 'Laptop'),
(5, 470, 'Mobile'),
(6, 620, 'Laptop'),
(7, 410, 'Mobile'),
(8, 580, 'Tablet'),
(9, 690, 'Laptop'),
(10, 750, 'Mobile'),
(1, 880, 'Tablet'),
(2, 440, 'Laptop'),
(3, 330, 'Mobile'),
(4, 210, 'Mobile'),
(5, 555, 'Tablet'),
(6, 777, 'Laptop'),
(7, 333, 'Mobile'),
(8, 444, 'Laptop'),
(9, 555, 'Tablet'),
(10, 666, 'Laptop'),
(1, 700, 'Mobile'),
(2, 710, 'Laptop'),
(3, 720, 'Tablet'),
(4, 730, 'Mobile'),
(5, 740, 'Laptop'),
(6, 750, 'Tablet'),
(7, 760, 'Laptop'),
(8, 770, 'Mobile'),
(9, 780, 'Tablet'),
(10, 790, 'Laptop'),
(1, 300, 'Laptop'),
(2, 350, 'Tablet'),
(3, 375, 'Mobile'),
(4, 325, 'Mobile'),
(5, 425, 'Laptop'),
(6, 875, 'Laptop'),
(7, 975, 'Mobile'),
(8, 425, 'Laptop'),
(9, 525, 'Tablet'),
(10, 625, 'Mobile');
