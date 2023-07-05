-- EXERCISES

--1.	Obtain the names of all physicians that have performed a medical procedure they have ”never” been certified to perform.

--My Answer
SELECT ph.Names
FROM Undergoes un 
FULL OUTER JOIN Trained_In tr ON un.Physician = tr.Physician AND un.Procedures = tr.Treatment 
JOIN Physician ph ON ph.EmployeeID = un.Physician
WHERE un.Procedures IS NOT NULL AND tr.Physician IS NULL
;

-- CORRECTION

--Answer #1
SELECT Names
  FROM Physician
 WHERE EmployeeID IN
       (
         SELECT Physician FROM Undergoes U WHERE NOT EXISTS
            (
               SELECT * FROM Trained_In
                WHERE Treatment = Procedures
                  AND Physician = U.Physician
            )
       );

-- Answer #2
SELECT P.Names FROM
 Physician AS P,
 (SELECT Physician, Procedures FROM Undergoes
    EXCEPT
    SELECT Physician, Treatment FROM Trained_in) AS Pe
 WHERE P.EmployeeID=Pe.Physician
 ;

-- Answer #3
SELECT Names
  FROM Physician
 WHERE EmployeeID IN
   (
      SELECT Undergoes.Physician
        FROM Undergoes
             LEFT JOIN Trained_In
             ON Undergoes.Physician=Trained_In.Physician
                 AND Undergoes.Procedures=Trained_In.Treatment
       WHERE Treatment IS NULL
   );

-- CONCLUSION : My Answer is also correct but I used a different approach, not the best but still works and is a shorter code

-- 2.	Same as the previous query, but include the following information in the results: Physician name, name of procedure, date 
--		when the procedure was carried out, name of the patient the procedure was carried out on.

--My Answer
SELECT ph.Names, pt.Names as Procedures, un.Date, pat.Names as Patient
FROM Undergoes un 
FULL OUTER JOIN Trained_In tr ON un.Physician = tr.Physician AND un.Procedures = tr.Treatment 
JOIN Physician ph ON ph.EmployeeID = un.Physician
JOIN Procedure_Table pt ON pt.Code = un.Procedures
JOIN Patient pat ON pat.SSN = un.Patient
WHERE un.Procedures IS NOT NULL AND tr.Physician IS NULL
;
--CORRECTION

--Answer#1
SELECT P.Names AS Physician, Pr.Names AS Procedures, U.Date, Pt.Names AS Patient
  FROM Physician P, Undergoes U, Patient Pt, Procedure_Table Pr
  WHERE U.Patient = Pt.SSN
    AND U.Procedures = Pr.Code
    AND U.Physician = P.EmployeeID
    AND NOT EXISTS
              (
                SELECT * FROM Trained_In T
                WHERE T.Treatment = U.Procedures
                AND T.Physician = U.Physician
              );

-- Answer #2
SELECT P.Names,Pr.Names,U.Date,Pt.Names FROM
 Physician AS P,
 Procedure_Table AS Pr,
 Undergoes AS U,
 Patient AS Pt,
 (SELECT Physician, Procedures FROM Undergoes
    EXCEPT
    SELECT Physician, Treatment FROM Trained_in) AS Pe
 WHERE P.EmployeeID=Pe.Physician AND Pe.Procedures=Pr.Code AND Pe.Physician=U.Physician AND Pe.Procedures=U.Procedures AND U.Patient=Pt.SSN
 ;
 -- CONCLUSION : Still works the same, my Answer is just less complicated

 --3.	Obtain the names of all physicians that have performed a medical procedure that they are certified to perform, 
 --		but such that the procedure was done at a date (Undergoes.Date) after the physician’s certification expired (Trained_In.CertificationExpires).

 -- My answer
SELECT ph.Names
FROM Undergoes un 
FULL OUTER JOIN Trained_In tr ON un.Physician = tr.Physician AND un.Procedures = tr.Treatment 
JOIN Physician ph ON ph.EmployeeID = un.Physician
WHERE un.Procedures IS NOT NULL AND un.Date > tr.CertificationExpires
;

--CORRECTION 
-- Answer #1
SELECT Names
  FROM Physician
 WHERE EmployeeID IN
       (
         SELECT Physician FROM Undergoes U
          WHERE Date >
               (
                  SELECT CertificationExpires
                    FROM Trained_In T
                   WHERE T.Physician = U.Physician
                     AND T.Treatment = U.Procedures
               )
       );
-- Answer #2
SELECT P.Names FROM
 Physician AS P,
 Trained_In T,
 Undergoes AS U
 WHERE T.Physician=U.Physician AND T.Treatment=U.Procedures AND U.Date>T.CertificationExpires AND P.EmployeeID=U.Physician
 ;
 -- 4.	Same as the previous query, but include the following information in the results: 
 --		Physician name, name of procedure, date when the procedure was carried out, 
 --		name of the patient the procedure was carried out on, and date when the certification expired.

 -- My answer
 SELECT ph.Names AS Physician, pr.Names AS Procedures, un.Date, pat.Names AS Patient, tr.CertificationExpires
FROM Undergoes un 
FULL OUTER JOIN Trained_In tr ON un.Physician = tr.Physician AND un.Procedures = tr.Treatment 
JOIN Physician ph ON ph.EmployeeID = un.Physician
JOIN Procedure_Table pr ON pr.Code = un.Procedures
JOIN Patient pat ON pat.SSN = un.Patient
WHERE un.Procedures IS NOT NULL AND un.Date > tr.CertificationExpires
;
--CORRECTION

--Answer #1
SELECT P.Names AS Physician, Pr.Names AS Procedures, U.Date, Pt.Names AS Patient, T.CertificationExpires
  FROM Physician P, Undergoes U, Patient Pt, Procedure_Table Pr, Trained_In T
  WHERE U.Patient = Pt.SSN
    AND U.Procedures = Pr.Code
    AND U.Physician = P.EmployeeID
    AND Pr.Code = T.Treatment
    AND P.EmployeeID = T.Physician
    AND U.Date > T.CertificationExpires;



-- 5.	Obtain the information for appointments where a patient met with a physician other than 
--		his/her primary care physician. Show the following information: 
--		Patient name, physician name, nurse name (if any), start and end time of appointment, 
--		examination room, and the name of the patient’s primary care physician.

-- My answer 
WITH CTE_Infos AS (
SELECT pat.Names AS Patient, ph.Names AS Physician, nur.Names AS Nurse, app.StartTime, app.EndTime, app.ExaminationRoom, pat.PCP
FROM Appointment app
LEFT JOIN Physician ph ON ph.EmployeeID = app.Physician
JOIN Patient pat ON pat.SSN = app.Patient 
LEFT JOIN Nurse nur ON nur.EmployeeID = app.PrepNurse
WHERE app.Physician <> pat.PCP
)
SELECT Patient, Physician, Nurse, StartTime, EndTime,ExaminationRoom, ph.Names AS "Primary Care Physician" FROM CTE_Infos pcp
JOIN Physician ph ON ph.EmployeeID = pcp.PCP

;
--CORRECTION

--Answer #1
SELECT Pt.Names AS Patient, Ph.Names AS Physician, N.Names AS Nurse, A.StartTime, A.EndTime, A.ExaminationRoom, PhPCP.Names AS PCP
  FROM Patient Pt, Physician Ph, Physician PhPCP, Appointment A LEFT JOIN Nurse N ON A.PrepNurse = N.EmployeeID
 WHERE A.Patient = Pt.SSN
   AND A.Physician = Ph.EmployeeID
   AND Pt.PCP = PhPCP.EmployeeID
   AND A.Physician <> Pt.PCP;

-- 6.	The Patient field in Undergoes is redundant, since we can obtain it from the Stay table. 
--		There are no constraints in force to prevent inconsistencies between these two tables. 
--		More specifically, the Undergoes table may include a row where the patient ID does not match the one we would obtain from 
--		the Stay table through the Undergoes.Stay foreign key. Select all rows from Undergoes that exhibit this inconsistency.

-- My answer
SELECT * FROM Undergoes un 
JOIN Stay st ON un.Stay = st.StayID AND un.Patient <> st.Patient

;
--CORRECTION
SELECT * FROM Undergoes U
 WHERE Patient <>
   (
     SELECT Patient FROM Stay S
      WHERE U.Stay = S.StayID
   );


-- 7.	Obtain the names of all the nurses who have ever been on call for room 123.

-- My Answer
SELECT nur.Names FROM Nurse nur
JOIN On_Call onc ON onc.Nurse = nur.EmployeeID
JOIN Room ro ON ro.BlockCode = onc.BlockCode AND ro.BlockFloor = onc.BlockFloor
WHERE ro.Room_Number = 123
;
--CORRECTION
SELECT N.Names FROM Nurse N
 WHERE EmployeeID IN
   (
     SELECT OC.Nurse FROM On_Call OC, Room R
      WHERE OC.BlockFloor = R.BlockFloor
        AND OC.BlockCode = R.BlockCode
        AND R.Room_Number = 123
   );


  -- 8.	The hospital has several examination rooms where appointments take place. 
  --	Obtain the number of appointments that have taken place in each examination room.

  -- My Answer
  SELECT ExaminationRoom, COUNT(AppointmentID) AS NoOfAppointments FROM Appointment 
  GROUP BY ExaminationRoom
  ;

  --CORRECTION
  SELECT ExaminationRoom, COUNT(AppointmentID) AS Number FROM Appointment
	GROUP BY ExaminationRoom;


-- 9.	Obtain the names of all patients (also include, for each patient, the name of the patient’s primary care physician), 
--		such that \emph{all} the following are true:
--		The patient has been prescribed some medication by his/her primary care physician.
--		The patient has undergone a procedure with a cost larger that $5,000
--		The patient has had at least two appointment where the nurse who prepped the appointment was a registered nurse.
--		The patient’s primary care physician is not the head of any department.


--My Answer
WITH CTE_table AS (
SELECT pat.Names AS Patient, ph.Names AS Physician, pr.Cost, presc.Appointment 
FROM Patient pat
  JOIN Physician ph ON pat.PCP = ph.EmployeeID
  JOIN Prescribes presc ON presc.Patient = pat.SSN
  JOIN Undergoes un ON un.Patient = pat.SSN
  JOIN Procedure_Table pr ON pr.Code = un.Procedures
  JOIN Nurse nur ON nur.EmployeeID = un.AssistingNurse
  LEFT JOIN Department dept ON dept.Head = ph.EmployeeID
  WHERE presc.Medication IS NOT NULL
  AND presc.Physician = PCP
  AND Registered =1
  AND dept.Head IS NULL
  
)
SELECT Patient, Physician FROM CTE_table
GROUP BY Patient, Physician
 HAVING COUNT(Appointment) >= 2 AND MAX(Cost) >= 5000
 ;
 
 -- CORRECTION
 SELECT Pt.Names, PhPCP.Names FROM Patient Pt, Physician PhPCP
 WHERE Pt.PCP = PhPCP.EmployeeID
   AND EXISTS
       (
         SELECT * FROM Prescribes Pr
          WHERE Pr.Patient = Pt.SSN
            AND Pr.Physician = Pt.PCP
       )
   AND EXISTS
       (
         SELECT * FROM Undergoes U, Procedure_Table Pr
          WHERE U.Procedures = Pr.Code
            AND U.Patient = Pt.SSN
            AND Pr.Cost > 5000
       )
   AND 2 <=
       (
         SELECT COUNT(A.AppointmentID) FROM Appointment A, Nurse N
          WHERE A.PrepNurse = N.EmployeeID
            AND N.Registered = 1
       )
   AND NOT Pt.PCP IN
       (
          SELECT Head FROM Department
       );
