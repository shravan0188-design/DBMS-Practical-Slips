CREATE TABLE Branch(Bid INT PRIMARY KEY, brname VARCHAR(30), brcity VARCHAR(10));
CREATE TABLE Customer(Cno INT PRIMARY KEY, cname VARCHAR(20), caddr VARCHAR(35), city VARCHAR(15));
CREATE TABLE Loan_application(Lno INT PRIMARY KEY, l_amt_required MONEY CHECK(l_amt_required>0), lamtapproved MONEY, l_date DATE);
CREATE TABLE Ternary(Bid INT, Cno INT, Lno INT, PRIMARY KEY(Bid,Cno,Lno));

SELECT Bid,SUM(lamtapproved) FROM Loan_application l JOIN Ternary t ON l.Lno=t.Lno WHERE l_date BETWEEN '2019-06-01' AND '2020-06-01' GROUP BY Bid;
SELECT c.* FROM Customer c JOIN Ternary t ON c.Cno=t.Cno JOIN Branch b ON b.Bid=t.Bid WHERE b.brname='Aundh';
SELECT SUM(l_amt_required) FROM Loan_application;
SELECT * FROM Branch;

CREATE FUNCTION trig1() RETURNS TRIGGER AS $$
BEGIN
IF NEW.Cno<=0 OR NEW.cname IS NULL THEN RAISE EXCEPTION 'Invalid'; END IF;
RETURN NEW;
END; $$ LANGUAGE plpgsql;
CREATE TRIGGER t1 BEFORE INSERT ON Customer FOR EACH ROW EXECUTE FUNCTION trig1();

CREATE FUNCTION f1(name VARCHAR) RETURNS TABLE(lno INT, amt MONEY) AS $$
BEGIN
RETURN QUERY SELECT l.Lno,l.lamtapproved FROM Loan_application l JOIN Ternary t ON l.Lno=t.Lno JOIN Customer c ON c.Cno=t.Cno WHERE c.cname=name;
END; $$ LANGUAGE plpgsql;
