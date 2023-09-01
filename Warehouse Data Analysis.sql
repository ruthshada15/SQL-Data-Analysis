-- WAREHOUSE DATA ANALYSIS EXERCISE

CREATE DATABASE SQLExercises2

--Creating Tables
CREATE TABLE Warehouses (
   Code int PRIMARY KEY NOT NULL,
   Location nvarchar(255) NOT NULL ,
   Capacity int NOT NULL
 );
 
 CREATE TABLE Boxes (
   Code nvarchar(255) PRIMARY KEY NOT NULL,
   Contents nvarchar(255) NOT NULL ,
   Value real NOT NULL ,
   Warehouse int NOT NULL
     CONSTRAINT fk_Warehouses_Code REFERENCES Warehouses(Code)
 );

 --Inserting Data
INSERT INTO Warehouses(Code,Location,Capacity) VALUES(1,'Chicago',3);
INSERT INTO Warehouses(Code,Location,Capacity) VALUES(2,'Chicago',4);
INSERT INTO Warehouses(Code,Location,Capacity) VALUES(3,'New York',7);
INSERT INTO Warehouses(Code,Location,Capacity) VALUES(4,'Los Angeles',2);
INSERT INTO Warehouses(Code,Location,Capacity) VALUES(5,'San Francisco',8);

INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('0MN7','Rocks',180,3);
INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('4H8P','Rocks',250,1);
INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('4RT3','Scissors',190,4);
INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('7G3H','Rocks',200,1);
INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('8JN6','Papers',75,1);
INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('8Y6U','Papers',50,3);
INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('9J6F','Papers',175,2);
INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('LL08','Rocks',140,4);
INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('P0H6','Scissors',125,1);
INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('P2T6','Scissors',150,2);
INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('TU55','Papers',90,5);

-- EXERCISES

-- 1.	Select all warehouses.

SELECT * FROM Warehouses;

-- 2.	Select all boxes with a value larger than $150.

SELECT * FROM Boxes
WHERE Value > 150;

-- 3.	Select all distinct contents in all the boxes.

SELECT DISTINCT Contents FROM Boxes

-- 4.	Select the average value of all the boxes.

SELECT AVG(Value) FROM Boxes

-- 5.	Select the warehouse code and the average value of the boxes in each warehouse.

SELECT wh.Code, AVG(bx.Value) AvgValue FROM Warehouses wh
JOIN Boxes bx ON bx.Warehouse = wh.Code
GROUP BY wh.Code

-- OR

SELECT Warehouse, AVG(Value) AvgValue
FROM Boxes
GROUP BY Warehouse;


-- 6.	Same as previous exercise, but select only those warehouses where the average value of the boxes is greater than 150.

SELECT Warehouse, AVG(Value) AvgValue
FROM Boxes
GROUP BY Warehouse
HAVING AVG(Value) > 150;

-- 7.	Select the code of each box, along with the name of the city the box is located in.

SELECT bx.Code, wh.Location FROM Warehouses wh
JOIN Boxes bx ON bx.Warehouse = wh.Code;

-- 8.	Select the warehouse codes, along with the number of boxes in each warehouse. 

SELECT wh.Code, COUNT(bx.Code) NoOfBoxes FROM Warehouses wh
JOIN Boxes bx ON bx.Warehouse = wh.Code
GROUP BY wh.Code;

-- OR Not taking into account Empty Warehouses
SELECT Warehouse, COUNT(*) NoOfBoxes
  FROM Boxes
  GROUP BY Warehouse;


-- 9. Select the codes of all warehouses that are saturated (a warehouse is saturated if the number of boxes in it is larger than the warehouse’s capacity).

SELECT wh.Code FROM Warehouses wh
JOIN Boxes bx ON bx.Warehouse = wh.Code
GROUP BY wh.Code, wh.Capacity
HAVING COUNT(bx.Code) > wh.Capacity;

--OR

SELECT Code
   FROM Warehouses
   WHERE Capacity <
   (
     SELECT COUNT(*)
       FROM Boxes
       WHERE Warehouse = Warehouses.Code
   );


-- 10.	Select the codes of all the boxes located in Chicago.

SELECT bx.Code FROM Warehouses wh
JOIN Boxes bx ON bx.Warehouse = wh.Code
WHERE wh.Location = 'Chicago'

-- OR WITH SUBQUERIES

SELECT Code
  FROM Boxes
  WHERE Warehouse IN
  (
    SELECT Code
      FROM Warehouses
      WHERE Location = 'Chicago'
  );


-- 11.	Create a new warehouse in New York with a capacity for 3 boxes.

INSERT INTO Warehouses VALUES (6,'New York',3);

-- 12.	Create a new box, with code “H5RT”, containing “Papers” with a value of $200, and located in warehouse 2.

INSERT INTO Boxes VALUES ('H5RT','Papers', 200, 2);

-- 13.	Reduce the value of all boxes by 20%.

UPDATE Boxes SET Value = Value - (Value * 0.20);

-- 14.	Apply a 15% value reduction to boxes with a value larger than the average value of all the boxes.

UPDATE Boxes SET Value = Value - (Value * 0.15)
WHERE Value > (SELECT AVG(Value) FROM Boxes)

-- 15.	Remove all boxes with a value lower than $100.

DELETE FROM Boxes WHERE Value < 100

-- 16. Remove all boxes from saturated warehouses.

DELETE FROM Boxes WHERE Warehouse IN (
SELECT wh.Code FROM Boxes bx JOIN Warehouses wh ON bx.Warehouse = wh.Code
GROUP BY wh.Capacity, wh.Code
HAVING COUNT(bx.Code) > wh.Capacity
)

-- OR 

DELETE FROM Boxes WHERE Warehouse IN
  (
    SELECT Code
      FROM Warehouses
      WHERE Capacity <
      (
        SELECT COUNT(*)
          FROM Boxes
          WHERE Warehouse = Warehouses.Code
      )
  );