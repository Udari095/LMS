DROP DATABASE StudentRegSystem;
GO
CREATE DATABASE StudentRegSystem;
GO

USE StudentRegSystem;
GO
 j
-- Students Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Students' AND xtype='U')
BEGIN
    CREATE TABLE Students (
        StudentID INT PRIMARY KEY,
        FirstName NVARCHAR(50) NOT NULL,
        LastName NVARCHAR(50) NOT NULL,
        DateOfBirth DATE,
        Email NVARCHAR(100) UNIQUE NOT NULL,
        PasswordHash NVARCHAR(256) NOT NULL,
        CreatedAt DATETIME DEFAULT GETDATE()
    );
END

-- Courses Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Courses' AND xtype='U')
BEGIN
    CREATE TABLE Courses (
        CourseID NVARCHAR(10) PRIMARY KEY,
        CourseName NVARCHAR(100) NOT NULL,
        CourseDescription NVARCHAR(255),
        Credits INT NOT NULL,
        CreatedAt DATETIME DEFAULT GETDATE()
    );
END

-- Registrations Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Registrations' AND xtype='U')
BEGIN
    CREATE TABLE Registrations (
        RegistrationID INT PRIMARY KEY IDENTITY,
        StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
        CourseID NVARCHAR(10) FOREIGN KEY REFERENCES Courses(CourseID),
        RegistrationDate DATETIME DEFAULT GETDATE(),
        Status NVARCHAR(50) DEFAULT 'Registered'
    );
END

-- Academics Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Academics' AND xtype='U')
BEGIN
    CREATE TABLE Academics (
        AcademicID INT PRIMARY KEY IDENTITY,
        FirstName NVARCHAR(50) NOT NULL,
        LastName NVARCHAR(50) NOT NULL,
        Email NVARCHAR(100) UNIQUE NOT NULL,
        PasswordHash NVARCHAR(256) NOT NULL,
        CreatedAt DATETIME DEFAULT GETDATE()
    );
END

-- ManagementStaff Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ManagementStaff' AND xtype='U')
BEGIN
    CREATE TABLE ManagementStaff (
        StaffID INT PRIMARY KEY IDENTITY,
        FirstName NVARCHAR(50) NOT NULL,
        LastName NVARCHAR(50) NOT NULL,
        Email NVARCHAR(100) UNIQUE NOT NULL,
        PasswordHash NVARCHAR(256) NOT NULL,
        CreatedAt DATETIME DEFAULT GETDATE()
    );
END

-- Admins Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Admins' AND xtype='U')
BEGIN
    CREATE TABLE Admins (
        AdminID INT PRIMARY KEY IDENTITY,
        FirstName NVARCHAR(50) NOT NULL,
        LastName NVARCHAR(50) NOT NULL,
        Email NVARCHAR(100) UNIQUE NOT NULL,
        PasswordHash NVARCHAR(256) NOT NULL,
        CreatedAt DATETIME DEFAULT GETDATE()
    );
END

-- Results Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Results' AND xtype='U')
BEGIN
    CREATE TABLE Results (
        ResultID INT PRIMARY KEY IDENTITY,
        StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
        CourseID NVARCHAR(10) FOREIGN KEY REFERENCES Courses(CourseID),
        Grade NVARCHAR(5),
        CreatedAt DATETIME DEFAULT GETDATE()
    );
END

-- Insert data into Students table
INSERT INTO Students (StudentID, FirstName, LastName, DateOfBirth, Email, PasswordHash)
VALUES 
(5051, 'John', 'Doe', '1998-04-23', 'john.doe@example.com', HASHBYTES('SHA2_256', 'password123')),
(5063, 'Jane', 'Smith', '1999-06-15', 'jane.smith@example.com', HASHBYTES('SHA2_256', 'password456')),
(5075, 'Alice', 'Johnson', '2000-08-30', 'alice.johnson@example.com', HASHBYTES('SHA2_256', 'password789'));

-- Insert data into Courses table
INSERT INTO Courses (CourseID, CourseName, CourseDescription, Credits)
VALUES 
('COM1204', 'Introduction to Computer Science', 'An introductory course on computer science concepts.', 3),
('MAT1202', 'Advanced Mathematics', 'A course on advanced mathematical concepts.', 4),
('ENG1101', 'English Literature', 'Study of English literature from various periods.', 3);

-- Insert data into Registrations table
INSERT INTO Registrations (StudentID, CourseID)
VALUES 
(5051, 'COM1204'),
(5063, 'MAT1202'),
(5075, 'ENG1101');

-- Insert data into Academics table
INSERT INTO Academics (FirstName, LastName, Email, PasswordHash)
VALUES 
('Dr. Emily', 'Brown', 'emily.brown@university.edu', HASHBYTES('SHA2_256', 'acadpassword1')),
('Dr. Michael', 'Green', 'michael.green@university.edu', HASHBYTES('SHA2_256', 'acadpassword2')),
('Dr. Sarah', 'White', 'sarah.white@university.edu', HASHBYTES('SHA2_256', 'acadpassword3'));

-- Insert data into ManagementStaff table
INSERT INTO ManagementStaff (FirstName, LastName, Email, PasswordHash)
VALUES 
('Robert', 'Williams', 'robert.williams@university.edu', HASHBYTES('SHA2_256', 'staffpassword1')),
('Laura', 'Davis', 'laura.davis@university.edu', HASHBYTES('SHA2_256', 'staffpassword2')),
('David', 'Miller', 'david.miller@university.edu', HASHBYTES('SHA2_256', 'staffpassword3'));

-- Insert data into Admins table
INSERT INTO Admins (FirstName, LastName, Email, PasswordHash)
VALUES 
('Admin1', 'AdminLast1', 'admin1@university.edu', HASHBYTES('SHA2_256', 'adminpassword1')),
('Admin2', 'AdminLast2', 'admin2@university.edu', HASHBYTES('SHA2_256', 'adminpassword2')),
('Admin3', 'AdminLast3', 'admin3@university.edu', HASHBYTES('SHA2_256', 'adminpassword3'));

-- Insert data into Results table
INSERT INTO Results (StudentID, CourseID, Grade)
VALUES 
(5051, 'COM1204', 'A'),
(5063, 'MAT1202', 'B+'),
(5075, 'ENG1101', 'A-');
