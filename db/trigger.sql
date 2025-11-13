DROP TRIGGER IF EXISTS trg_fraud_check ON transactions;

CREATE TRIGGER trg_fraud_check
AFTER INSERT ON transactions
FOR EACH ROW
EXECUTE FUNCTION fraud_check();
