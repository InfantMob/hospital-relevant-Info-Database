USE demo;
-- CREATE TABLES

--  DDL Statements for table Person
create table Person(
    PersonID integer not null,
    Age integer, 
    Gender varchar(20), 
    Ethnicity varchar(40), 
    Phone varchar(40),
    primary key (PersonID)
);

--  DDL Statements for table Patient
create table Patient(
    PatientID integer not null references Person (PersonID) on delete cascade,
    DOD DATE,
    primary key (PatientID)
);

--  DDL Statements for table Disease
create table Disease(
    Disease_ID integer not null,
    Disease_Name varchar(100),
    Category varchar(100),
    primary key (Disease_ID)
);

--  DDL Statements for table Diagnosed
create table Diagnosed(
    PatientID integer not null,
    Disease_ID integer not null,
    Date_of_Diagnosis DATE not null,
    primary key (PatientID, Disease_ID),
    foreign key(PatientID) references Patient(PatientID) on delete cascade,
    foreign key(Disease_ID) references Disease(Disease_ID) on delete cascade
);

--  DDL Statements for table LabRecord
create table LabRecord(
    Lab_ID integer not null,
    PatientID integer not null,
    primary key (Lab_ID),
    foreign key(PatientID) references Patient(PatientID) on delete cascade
);

--  DDL Statements for table Test
create table Test(
    Test_ID integer not null,
    Test_Name varchar(50) not null,
    Type varchar(40),
    primary key (Test_ID)
);

--  DDL Statements for table Contain
create table Contain(
    Lab_ID integer not null,
    Test_ID integer not null,
    Date DATE,
    Value varchar(10),
    Result varchar(20) not null,
    primary key(Lab_ID, Test_ID),
    foreign key (Lab_ID) references LabRecord(Lab_ID) on delete cascade,
    foreign key (Test_ID) references Test(Test_ID) on delete cascade
);

--  DDL Statements for table Hospital
create table Hospital(
    Name varchar(40) not null,
    Address varchar(100),
    primary key (Name)
);

--  DDL Statements for table Department
create table Department(
    Department_ID integer not null,
    Department_Name varchar(20),
    primary key (Department_ID)
);

--  DDL Statements for table HasDept
create table HasDept(
    Hospital varchar(40) not null,
    Department_ID integer not null,
    PatientCapacity integer not null,
    primary key (Hospital, Department_ID),
    foreign key(Hospital) references Hospital(Name) on delete cascade,
    foreign key(Department_ID) references Department(Department_ID) on delete cascade
);

--  DDL Statements for table Employee
create table Employee(
    Employee_ID integer not null references Person (PersonID) on delete cascade,
    Hospital varchar(40) not null,
    Department_ID integer,
    Role varchar(40),
    primary key(Employee_ID),
    foreign key(Hospital) references Hospital(Name) on delete cascade,
    foreign key(Department_ID) references Department(Department_ID) on delete cascade
);

--  DDL Statements for table AdmissionRecord
CREATE TABLE AdmissionRecord (
    Adm_ID INTEGER NOT NULL,
    PatientID INTEGER NOT NULL,
    Hospital VARCHAR(40) NOT NULL,
    AdmitDate DATE,
    DischDate DATE,
    PRIMARY KEY (Adm_ID),
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID) ON DELETE CASCADE,
    FOREIGN KEY (Hospital) REFERENCES Hospital(Name) ON DELETE CASCADE
);

--  DDL Statements for table ICU
create table ICU(
    Hospital varchar(40) not null,
    ICU_Name varchar(20) not null,
    ICUCapacity integer,
    primary key (Hospital, ICU_Name),
    foreign key(Hospital) references Hospital(Name) on delete cascade
);

--  DDL Statements for table ICUStay
create table ICUStay(
    Hospital varchar(40) not null,
    ICU_Name varchar(20) not null,
    Adm_ID integer not null,
    DateIn DATE,
    DateOut DATE,
    primary key (Hospital, ICU_Name, Adm_ID),
    foreign key(Hospital, ICU_Name) references ICU(Hospital, ICU_Name) on delete cascade,
    foreign key(Adm_ID) references AdmissionRecord(Adm_ID) on delete cascade
);

--  DDL Statements for table Prescription
create table Prescription(
    RX_Num varchar(20) not null,
    Adm_ID integer not null,
    StartDate DATE,
    EndDate DATE,
    primary key(RX_Num),
    foreign key(Adm_ID) references AdmissionRecord(Adm_ID) on delete cascade
);

--  DDL Statements for table Drug
create table Drug(
    Drug_ID integer not null,
    Drug_Name varchar(40),
    Type varchar(100),
    Manufacturer varchar(30),
    primary key(Drug_ID)
);

--  DDL Statements for table HasDrug
create table HasDrug(
    RX_Num varchar(20) not null,
    Drug_ID integer not null,
    Dose integer,
    primary key(RX_Num, Drug_ID),
    foreign key(RX_Num) references Prescription(RX_Num) on delete cascade,
    foreign key(Drug_ID) references Drug(Drug_ID) on delete cascade
);