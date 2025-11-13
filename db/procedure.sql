CREATE OR REPLACE FUNCTION fraud_check()
RETURNS TRIGGER AS $$
DECLARE
    avg_amount NUMERIC;
    txn_count INT;
    known_device INT;
BEGIN
    ------------------------------------------------------------------------
    -- RULE 1: HIGH AMOUNT → RISK SCORING
    ------------------------------------------------------------------------
    IF NEW.amount > 20000 THEN
        INSERT INTO alerts(user_id, txn_id, rule_triggered, risk_level, details)
        VALUES (NEW.user_id, NEW.txn_id, 'High Amount', 'HIGH',
        'Amount above 20,000 is considered high risk');
    ELSIF NEW.amount > 10000 THEN
        INSERT INTO alerts(user_id, txn_id, rule_triggered, risk_level, details)
        VALUES (NEW.user_id, NEW.txn_id, 'Medium Amount', 'MEDIUM',
        'Amount between 10,000 and 20,000 is moderate risk');
    END IF;


    ------------------------------------------------------------------------
    -- RULE 2: VELOCITY RULE (More than 3 tx in 2 minutes)
    ------------------------------------------------------------------------
    SELECT COUNT(*) INTO txn_count
    FROM transactions
    WHERE user_id = NEW.user_id
    AND created_at >= NEW.created_at - INTERVAL '2 minutes';

    IF txn_count > 3 THEN
        INSERT INTO alerts(user_id, txn_id, rule_triggered, risk_level, details)
        VALUES (NEW.user_id, NEW.txn_id, 'High Velocity',
        'HIGH', 'More than 3 transactions in 2 minutes');
    END IF;


    ------------------------------------------------------------------------
    -- RULE 3: NEW DEVICE RULE
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
    -- RULE 4: SUDDEN SPIKE (amount > 3x user’s average)
    ------------------------------------------------------------------------
    SELECT AVG(amount) INTO avg_amount
    FROM transactions
    WHERE user_id = NEW.user_id;

    IF avg_amount IS NOT NULL AND NEW.amount > avg_amount * 3 THEN
        INSERT INTO alerts(user_id, txn_id, rule_triggered, risk_level, details)
        VALUES (NEW.user_id, NEW.txn_id, 'Amount Spike', 'HIGH',
        'Amount is more than 3x user average');
    END IF;


    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
