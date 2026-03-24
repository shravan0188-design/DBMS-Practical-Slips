-- ===== SLIP 20 =====

-- =========================
-- TABLE CREATION
-- =========================

CREATE TABLE Branch(
    Bid INT PRIMARY KEY,
    brname VARCHAR(30),
    brcity VARCHAR(20)
);

CREATE TABLE Customer(
    Cno INT PRIMARY KEY,
    cname VARCHAR(30),
    caddr VARCHAR(50),
    city VARCHAR(20)
);

CREATE TABLE Loan_application(
    Lno INT PRIMARY KEY,
    l_amt_required NUMERIC CHECK (l_amt_required > 0),
    lamtapproved NUMERIC,
    l_date DATE
);

CREATE TABLE Ternary(
    Bid INT,
    Cno INT,
    Lno INT,
    PRIMARY KEY(Bid,Cno,Lno),
    FOREIGN KEY (Bid) REFERENCES Branch(Bid),
    FOREIGN KEY (Cno) REFERENCES Customer(Cno),
    FOREIGN KEY (Lno) REFERENCES Loan_application(Lno)
);

-- =========================
-- INSERT DATA
-- =========================

INSERT INTO Branch VALUES
(1,'Pimpri','Pune'),
(2,'Aundh','Pune'),
(3,'Deccan','Pune');

INSERT INTO Customer VALUES
(1,'Amit','Pune','Pune'),
(2,'Riya','Mumbai','Mumbai'),
(3,'Pooja','Delhi','Delhi');

INSERT INTO Loan_application VALUES
(1,500000,400000,'2020-01-01'),
(2,800000,700000,'2020-02-01'),
(3,100000,90000,'2020-03-01');

INSERT INTO Ternary VALUES
(1,1,1),
(2,2,2),
(3,3,3);

-- =========================
-- SAMPLE QUERIES
-- =========================

SELECT * FROM Branch;
SELECT cname FROM Customer;
SELECT SUM(lamtapproved) FROM Loan_application;

-- =========================
-- TRIGGER
-- =========================

CREATE OR REPLACE FUNCTION check_amount()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.l_amt_required <= 0 THEN
        RAISE EXCEPTION 'Invalid amount';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_amount
BEFORE INSERT ON Loan_application
FOR EACH ROW EXECUTE FUNCTION check_amount();

-- =========================
-- FUNCTION
-- =========================

CREATE OR REPLACE FUNCTION get_customer_loans(cust_name VARCHAR)
RETURNS TABLE(name VARCHAR, amount NUMERIC) AS $$
BEGIN
    RETURN QUERY
    SELECT cname, lamtapproved
    FROM Customer C
    JOIN Ternary T ON C.Cno=T.Cno
    JOIN Loan_application L ON L.Lno=T.Lno
    WHERE cname=cust_name;
END;
$$ LANGUAGE plpgsql;
