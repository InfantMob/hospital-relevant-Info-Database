connect to se3db3;

--  Q1

SELECT E.Employee_ID, E.Role
FROM Employee E,
     Department D
WHERE E.Department_ID = D.Department_ID
  AND D.Department_Name = 'Cardiology'
  AND (E.Hospital = 'Bellevue General Hospital' OR E.Hospital = 'Grand Oak Hospital');

--  Q2

SELECT AVG(C.Value) AS Average_Blood_Glucose_Value
FROM Contain C, Test T
WHERE  T.Test_ID = C.Test_ID AND T.Test_Name = 'Blood Glucose Test';

--  Q3

SELECT AR.PatientID ,count(*) AS AdmissionCount
FROM AdmissionRecord AR
WHERE AR.AdmitDate >= '2020-01-01'
GROUP BY AR.PatientID
HAVING count(*)>= 3;

--  Q4

SELECT T.Type, count(*) AS NumberOfAbnormal
FROM Contain C, Test T
WHERE T.Test_ID = C.Test_ID AND C.Date < '2021-01-01' AND C.Date >= '2020-01-01' AND C.Result = 'Abnormal'
GROUP BY T.Type;

--  Q5

SELECT PAT.PatientID, PER.Age, PER.Gender
FROM ICUStay ICUS, AdmissionRecord AR, Patient PAT, Person PER
WHERE PER.PersonID = PAT.PatientID
  AND AR.PatientID = PAT.PatientID
  AND ICUS.Adm_ID = AR.Adm_ID
  AND (ICUS.DateOut-ICUS.DateIn) = (SELECT max(ICUS2.DateOut-ICUS2.DateIn)
                                    FROM ICUStay ICUS2);

--  Q6

SELECT DS.Category, avg(P.Age) AS avgAge
FROM Diagnosed DA, Disease DS, Person P
WHERE P.PersonID = DA.PatientID AND DA.Disease_ID = DS.Disease_ID
GROUP BY DS.Category;


--  Q7

SELECT DISTINCT E.Employee_ID
FROM Employee E, Diagnosed DA, Disease DS
WHERE E.Department_ID IS NOT NULL
  AND DA.PatientID = E.Employee_ID
  AND DA.Disease_ID = DS.Disease_ID
  AND DS.Disease_Name <> 'Food Allergy'
  AND DS.Disease_Name <> 'Flu'
  AND DS.Disease_Name <> 'Conjunctivitis';


--  Q8

SELECT DISTINCT P.PatientID, C.Date
FROM Diagnosed DIA, Contain C, Patient P, LabRecord L, Disease DIS
WHERE C.Result = 'Abnormal'
  AND C.Lab_ID = L.Lab_ID
  AND L.PatientID = P.PatientID
  AND P.PatientID = DIA.PatientID
  AND DIA.Disease_ID = DIS.Disease_ID
  AND DIS.Category = 'Blood and Lymph'
  AND DIA.Date_of_Diagnosis = C.Date;

--  Q9

SELECT count(P.RX_Num) AS NonBigThreeCount
FROM Prescription P,
     Drug D,
     HasDrug HD
WHERE P.RX_Num = HD.RX_Num
  AND HD.Drug_ID = D.Drug_ID
  AND D.Manufacturer <> 'Pfizer'
  AND D.Manufacturer <> 'Johnson & Johnson'
  AND D.Manufacturer <> 'Bayer';

--  Q10

SELECT HD.Hospital, D.Department_Name, HD.PatientCapacity
FROM HasDept HD,
     Department D
WHERE HD.Department_ID = D.Department_ID
  AND HD.Hospital = ANY (SELECT HD2.Hospital
             FROM Hospital H2,
                  HasDept HD2
             WHERE H2.Name = HD2.Hospital
             GROUP BY HD2.Hospital
             HAVING count(*) >= (SELECT count(D2.Department_Name)
                                 FROM Department D2));