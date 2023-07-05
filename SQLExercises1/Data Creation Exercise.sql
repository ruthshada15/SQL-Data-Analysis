CREATE DATABASE SQLExercises1

CREATE TABLE Physician (
  EmployeeID int PRIMARY KEY NOT NULL,
  Names varchar NOT NULL,
  Position varchar NOT NULL,
  SSN int NOT NULL
);
ALTER TABLE Physician ALTER COLUMN Names varchar(255);
ALTER TABLE Physician ALTER COLUMN Position varchar(255);

CREATE TABLE Department (
  DepartmentID int PRIMARY KEY NOT NULL,
  Names varchar NOT NULL,
  Head int NOT NULL
    CONSTRAINT fk_Physician_xEmployeeID REFERENCES Physician(EmployeeID)
);

ALTER TABLE Department ALTER COLUMN Names varchar(255);

CREATE TABLE Affiliated_With (
  Physician int NOT NULL
    CONSTRAINT fk_Physician_EmployeeID REFERENCES Physician(EmployeeID),
  Department int NOT NULL
    CONSTRAINT fk_Department_DepartmentID REFERENCES Department(DepartmentID),
  PrimaryAffiliation BIT NOT NULL,
  PRIMARY KEY(Physician, Department)
);
CREATE TABLE Procedure_Table (
  Code int PRIMARY KEY NOT NULL,
  Names varchar NOT NULL,
  Cost real NOT NULL
);

ALTER TABLE Procedure_Table ALTER COLUMN Names varchar(255);


CREATE TABLE Trained_In (
  Physician int NOT NULL
    CONSTRAINT fk_Physician_EmployeeID2 REFERENCES Physician(EmployeeID),
  Treatment int NOT NULL
    CONSTRAINT fk_Procedure_Code REFERENCES Procedure_Table(Code),
  CertificationDate datetime NOT NULL,
  CertificationExpires datetime NOT NULL,
  PRIMARY KEY(Physician, Treatment)
);

CREATE TABLE Patient (
  SSN int PRIMARY KEY NOT NULL,
  Names varchar NOT NULL,
  Address varchar NOT NULL,
  Phone varchar NOT NULL,
  InsuranceID int NOT NULL,
  PCP int NOT NULL
    CONSTRAINT fk_Physician_EmployeeID3 REFERENCES Physician(EmployeeID)
);

ALTER TABLE Patient ALTER COLUMN Names varchar(255);
ALTER TABLE Patient ALTER COLUMN Address varchar(255);
ALTER TABLE Patient ALTER COLUMN Phone varchar(255);

CREATE TABLE Nurse (
  EmployeeID int PRIMARY KEY NOT NULL,
  Names varchar NOT NULL,
  Position varchar NOT NULL,
  Registered BIT NOT NULL,
  SSN int NOT NULL
);

ALTER TABLE Nurse ALTER COLUMN Names varchar(255);
ALTER TABLE Nurse ALTER COLUMN Position varchar(255);

CREATE TABLE Appointment (
  AppointmentID int PRIMARY KEY NOT NULL,
  Patient int NOT NULL
    CONSTRAINT fk_Patient_SSN REFERENCES Patient(SSN),
  PrepNurse int
    CONSTRAINT fk_Nurse_EmployeeID REFERENCES Nurse(EmployeeID),
  Physician int NOT NULL
    CONSTRAINT fk_Physician_EmployeeID4 REFERENCES Physician(EmployeeID),
  StartTime datetime NOT NULL,
  EndTime datetime NOT NULL,
  ExaminationRoom varchar NOT NULL
);

ALTER TABLE Appointment ALTER COLUMN ExaminationRoom varchar(255);

CREATE TABLE Medication (
  Code int PRIMARY KEY NOT NULL,
  Names varchar NOT NULL,
  Brand varchar NOT NULL,
  Description varchar NOT NULL
);
ALTER TABLE Medication ALTER COLUMN Names varchar(255);
ALTER TABLE Medication ALTER COLUMN Brand varchar(255);
ALTER TABLE Medication ALTER COLUMN Description varchar(255);

CREATE TABLE Prescribes (
  Physician int NOT NULL
    CONSTRAINT fk_Physician_EmployeeID5 REFERENCES Physician(EmployeeID),
  Patient int NOT NULL
    CONSTRAINT fk_Patient_SSN2 REFERENCES Patient(SSN),
  Medication int NOT NULL
    CONSTRAINT fk_Medication_Code REFERENCES Medication(Code),
  Date datetime NOT NULL,
  Appointment int
    CONSTRAINT fk_Appointment_AppointmentID REFERENCES Appointment(AppointmentID),
  Dose varchar NOT NULL,
  PRIMARY KEY(Physician, Patient, Medication, Date)
);
ALTER TABLE Prescribes ALTER COLUMN Dose varchar(255);

CREATE TABLE Block_Table (
  Floors int NOT NULL,
  Code int NOT NULL,
  PRIMARY KEY(Floors, Code)
);

CREATE TABLE Room (
  Room_Number int PRIMARY KEY NOT NULL,
  Room_Type varchar NOT NULL,
  BlockFloor int NOT NULL,
   -- CONSTRAINT fk_Block_Floor REFERENCES Block_Table(Floors), --Not Working, gotta find another solution with ALTER TABLE
  BlockCode int NOT NULL,
   -- CONSTRAINT fk_Block_Code REFERENCES Block_Table(Code), --Not Working, gotta find another solution with ALTER TABLE
  Unavailable BIT NOT NULL
);

ALTER TABLE Room ALTER COLUMN Room_Type varchar(255);

ALTER TABLE Room ADD CONSTRAINT fk_Block_Floor2 FOREIGN KEY (BlockFloor,BlockCode) REFERENCES Block_Table(Floors,Code);

CREATE TABLE On_Call (
  Nurse int NOT NULL
    CONSTRAINT fk_Nurse_EmployeeID2 REFERENCES Nurse(EmployeeID),
  BlockFloor int NOT NULL,
   -- CONSTRAINT fk_Block_Floor REFERENCES Block(Floor), --Not Working, gotta find another solution with ALTER TABLE
  BlockCode int NOT NULL,
   -- CONSTRAINT fk_Block_Code REFERENCES Block(Code), --Not Working, gotta find another solution with ALTER TABLE
  StartDate datetime NOT NULL,
  EndDate datetime NOT NULL,
  PRIMARY KEY(Nurse, BlockFloor, BlockCode, StartDate, EndDate)
);

ALTER TABLE On_Call ADD CONSTRAINT fk_Block_Floor FOREIGN KEY (BlockFloor,BlockCode) REFERENCES Block_Table(Floors,Code);

CREATE TABLE Stay (
  StayID int PRIMARY KEY NOT NULL,
  Patient int NOT NULL
    CONSTRAINT fk_Patient_SSN3 REFERENCES Patient(SSN),
  Room int NOT NULL
    CONSTRAINT fk_Room_Number REFERENCES Room(Room_Number),
  StartDate datetime NOT NULL,
  EndDate datetime NOT NULL
);

CREATE TABLE Undergoes (
  Patient int NOT NULL
    CONSTRAINT fk_Patient_SSN4 REFERENCES Patient(SSN),
  Procedures int NOT NULL
    CONSTRAINT fk_Procedure_Code2 REFERENCES Procedure_Table(Code),
  Stay int NOT NULL
    CONSTRAINT fk_Stay_StayID REFERENCES Stay(StayID),
  Date datetime NOT NULL,
  Physician int NOT NULL
    CONSTRAINT fk_Physician_EmployeeID6 REFERENCES Physician(EmployeeID),
  AssistingNurse int
    CONSTRAINT fk_Nurse_EmployeeID3 REFERENCES Nurse(EmployeeID),
  PRIMARY KEY(Patient, Procedures, Stay, Date)
);

-- INSERTING DATA

INSERT INTO Physician ( EmployeeID, Names, Position, SSN) VALUES (1,'John Dorian','Staff Internist',111111111);
INSERT INTO Physician ( EmployeeID, Names, Position, SSN) VALUES(2,'Elliot Reid','Attending Physician',222222222);
INSERT INTO Physician ( EmployeeID, Names, Position, SSN) VALUES(3,'Christopher Turk','Surgical Attending Physician',333333333);
INSERT INTO Physician ( EmployeeID, Names, Position, SSN) VALUES(4,'Percival Cox','Senior Attending Physician',444444444);
INSERT INTO Physician ( EmployeeID, Names, Position, SSN) VALUES(5,'Bob Kelso','Head Chief of Medicine',555555555);
INSERT INTO Physician ( EmployeeID, Names, Position, SSN) VALUES(6,'Todd Quinlan','Surgical Attending Physician',666666666);
INSERT INTO Physician ( EmployeeID, Names, Position, SSN) VALUES(7,'John Wen','Surgical Attending Physician',777777777);
INSERT INTO Physician ( EmployeeID, Names, Position, SSN) VALUES(8,'Keith Dudemeister','MD Resident',888888888);
INSERT INTO Physician ( EmployeeID, Names, Position, SSN) VALUES(9,'Molly Clock','Attending Psychiatrist',999999999);

SELECT * FROM Physician

INSERT INTO Department VALUES(1,'General Medicine',4);
INSERT INTO Department VALUES(2,'Surgery',7);
INSERT INTO Department VALUES(3,'Psychiatry',9);

SELECT * FROM Department

INSERT INTO Affiliated_With VALUES(1,1,1);
INSERT INTO Affiliated_With VALUES(2,1,1);
INSERT INTO Affiliated_With VALUES(3,1,0);
INSERT INTO Affiliated_With VALUES(3,2,1);
INSERT INTO Affiliated_With VALUES(4,1,1);
INSERT INTO Affiliated_With VALUES(5,1,1);
INSERT INTO Affiliated_With VALUES(6,2,1);
INSERT INTO Affiliated_With VALUES(7,1,0);
INSERT INTO Affiliated_With VALUES(7,2,1);
INSERT INTO Affiliated_With VALUES(8,1,1);
INSERT INTO Affiliated_With VALUES(9,3,1);

SELECT * FROM Affiliated_With

INSERT INTO Procedure_Table VALUES(1,'Reverse Rhinopodoplasty',1500.0);
INSERT INTO Procedure_Table VALUES(2,'Obtuse Pyloric Recombobulation',3750.0);
INSERT INTO Procedure_Table VALUES(3,'Folded Demiophtalmectomy',4500.0);
INSERT INTO Procedure_Table VALUES(4,'Complete Walletectomy',10000.0);
INSERT INTO Procedure_Table VALUES(5,'Obfuscated Dermogastrotomy',4899.0);
INSERT INTO Procedure_Table VALUES(6,'Reversible Pancreomyoplasty',5600.0);
INSERT INTO Procedure_Table VALUES(7,'Follicular Demiectomy',25.0);

SELECT * FROM Procedure_Table

INSERT INTO Patient VALUES(100000001,'John Smith','42 Foobar Lane','555-0256',68476213,1);
INSERT INTO Patient VALUES(100000002,'Grace Ritchie','37 Snafu Drive','555-0512',36546321,2);
INSERT INTO Patient VALUES(100000003,'Random J. Patient','101 Omgbbq Street','555-1204',65465421,2);
INSERT INTO Patient VALUES(100000004,'Dennis Doe','1100 Foobaz Avenue','555-2048',68421879,3);

SELECT * FROM Patient

INSERT INTO Nurse VALUES(101,'Carla Espinosa','Head Nurse',1,111111110);
INSERT INTO Nurse VALUES(102,'Laverne Roberts','Nurse',1,222222220);
INSERT INTO Nurse VALUES(103,'Paul Flowers','Nurse',0,333333330);

SELECT * FROM Nurse

INSERT INTO Appointment VALUES(13216584,100000001,101,1,'2008-04-24 10:00','2008-04-24 11:00','A');
INSERT INTO Appointment VALUES(26548913,100000002,101,2,'2008-04-24 10:00','2008-04-24 11:00','B');
INSERT INTO Appointment VALUES(36549879,100000001,102,1,'2008-04-25 10:00','2008-04-25 11:00','A');
INSERT INTO Appointment VALUES(46846589,100000004,103,4,'2008-04-25 10:00','2008-04-25 11:00','B');
INSERT INTO Appointment VALUES(59871321,100000004,NULL,4,'2008-04-26 10:00','2008-04-26 11:00','C');
INSERT INTO Appointment VALUES(69879231,100000003,103,2,'2008-04-26 11:00','2008-04-26 12:00','C');
INSERT INTO Appointment VALUES(76983231,100000001,NULL,3,'2008-04-26 12:00','2008-04-26 13:00','C');
INSERT INTO Appointment VALUES(86213939,100000004,102,9,'2008-04-27 10:00','2008-04-21 11:00','A');
INSERT INTO Appointment VALUES(93216548,100000002,101,2,'2008-04-27 10:00','2008-04-27 11:00','B');

SELECT * FROM Appointment

INSERT INTO Medication VALUES(1,'Procrastin-X','X','N/A');
INSERT INTO Medication VALUES(2,'Thesisin','Foo Labs','N/A');
INSERT INTO Medication VALUES(3,'Awakin','Bar Laboratories','N/A');
INSERT INTO Medication VALUES(4,'Crescavitin','Baz Industries','N/A');
INSERT INTO Medication VALUES(5,'Melioraurin','Snafu Pharmaceuticals','N/A');

SELECT * FROM Medication

INSERT INTO Prescribes VALUES(1,100000001,1,'2008-04-24 10:47',13216584,'5');
INSERT INTO Prescribes VALUES(9,100000004,2,'2008-04-27 10:53',86213939,'10');
INSERT INTO Prescribes VALUES(9,100000004,2,'2008-04-30 16:53',NULL,'5');

SELECT * FROM Prescribes

INSERT INTO Block_Table VALUES(1,1);
INSERT INTO Block_Table VALUES(1,2);
INSERT INTO Block_Table VALUES(1,3);
INSERT INTO Block_Table VALUES(2,1);
INSERT INTO Block_Table VALUES(2,2);
INSERT INTO Block_Table VALUES(2,3);
INSERT INTO Block_Table VALUES(3,1);
INSERT INTO Block_Table VALUES(3,2);
INSERT INTO Block_Table VALUES(3,3);
INSERT INTO Block_Table VALUES(4,1);
INSERT INTO Block_Table VALUES(4,2);
INSERT INTO Block_Table VALUES(4,3);

SELECT * FROM Block_Table

INSERT INTO Room VALUES(101,'Single',1,1,0);
INSERT INTO Room VALUES(102,'Single',1,1,0);
INSERT INTO Room VALUES(103,'Single',1,1,0);
INSERT INTO Room VALUES(111,'Single',1,2,0);
INSERT INTO Room VALUES(112,'Single',1,2,1);
INSERT INTO Room VALUES(113,'Single',1,2,0);
INSERT INTO Room VALUES(121,'Single',1,3,0);
INSERT INTO Room VALUES(122,'Single',1,3,0);
INSERT INTO Room VALUES(123,'Single',1,3,0);
INSERT INTO Room VALUES(201,'Single',2,1,1);
INSERT INTO Room VALUES(202,'Single',2,1,0);
INSERT INTO Room VALUES(203,'Single',2,1,0);
INSERT INTO Room VALUES(211,'Single',2,2,0);
INSERT INTO Room VALUES(212,'Single',2,2,0);
INSERT INTO Room VALUES(213,'Single',2,2,1);
INSERT INTO Room VALUES(221,'Single',2,3,0);
INSERT INTO Room VALUES(222,'Single',2,3,0);
INSERT INTO Room VALUES(223,'Single',2,3,0);
INSERT INTO Room VALUES(301,'Single',3,1,0);
INSERT INTO Room VALUES(302,'Single',3,1,1);
INSERT INTO Room VALUES(303,'Single',3,1,0);
INSERT INTO Room VALUES(311,'Single',3,2,0);
INSERT INTO Room VALUES(312,'Single',3,2,0);
INSERT INTO Room VALUES(313,'Single',3,2,0);
INSERT INTO Room VALUES(321,'Single',3,3,1);
INSERT INTO Room VALUES(322,'Single',3,3,0);
INSERT INTO Room VALUES(323,'Single',3,3,0);
INSERT INTO Room VALUES(401,'Single',4,1,0);
INSERT INTO Room VALUES(402,'Single',4,1,1);
INSERT INTO Room VALUES(403,'Single',4,1,0);
INSERT INTO Room VALUES(411,'Single',4,2,0);
INSERT INTO Room VALUES(412,'Single',4,2,0);
INSERT INTO Room VALUES(413,'Single',4,2,0);
INSERT INTO Room VALUES(421,'Single',4,3,1);
INSERT INTO Room VALUES(422,'Single',4,3,0);
INSERT INTO Room VALUES(423,'Single',4,3,0);

SELECT * FROM Room

INSERT INTO On_Call VALUES(101,1,1,'2008-11-04 11:00','2008-11-04 19:00');
INSERT INTO On_Call VALUES(101,1,2,'2008-11-04 11:00','2008-11-04 19:00');
INSERT INTO On_Call VALUES(102,1,3,'2008-11-04 11:00','2008-11-04 19:00');
INSERT INTO On_Call VALUES(103,1,1,'2008-11-04 19:00','2008-11-05 03:00');
INSERT INTO On_Call VALUES(103,1,2,'2008-11-04 19:00','2008-11-05 03:00');
INSERT INTO On_Call VALUES(103,1,3,'2008-11-04 19:00','2008-11-05 03:00');


SELECT * FROM On_Call

INSERT INTO Stay VALUES(3215,100000001,111,'2008-05-01','2008-05-04');
INSERT INTO Stay VALUES(3216,100000003,123,'2008-05-03','2008-05-14');
INSERT INTO Stay VALUES(3217,100000004,112,'2008-05-02','2008-05-03');

SELECT * FROM Stay

INSERT INTO Undergoes VALUES(100000001,6,3215,'2008-05-02',3,101);
INSERT INTO Undergoes VALUES(100000001,2,3215,'2008-05-03',7,101);
INSERT INTO Undergoes VALUES(100000004,1,3217,'2008-05-07',3,102);
INSERT INTO Undergoes VALUES(100000004,5,3217,'2008-05-09',6,NULL);
INSERT INTO Undergoes VALUES(100000001,7,3217,'2008-05-10',7,101);
INSERT INTO Undergoes VALUES(100000004,4,3217,'2008-05-13',3,103);

SELECT * FROM Undergoes

INSERT INTO Trained_In VALUES(3,1,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(3,2,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(3,5,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(3,6,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(3,7,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(6,2,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(6,5,'2007-01-01','2007-12-31');
INSERT INTO Trained_In VALUES(6,6,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,1,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,2,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,3,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,4,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,5,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,6,'2008-01-01','2008-12-31');
INSERT INTO Trained_In VALUES(7,7,'2008-01-01','2008-12-31');

SELECT * FROM Trained_In


