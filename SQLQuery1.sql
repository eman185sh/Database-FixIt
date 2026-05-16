-- 1. Create the Database
CREATE DATABASE FixItExpertDB;

USE FixItExpertDB;


-- 2. Create Users & Roles Tables
CREATE TABLE Roles (
    RoleID INT PRIMARY KEY IDENTITY(1,1),
    RoleName VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(150) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(20),
    CreatedAt DATETIME DEFAULT GETDATE(),
    RoleID INT FOREIGN KEY REFERENCES Roles(RoleID)
);

-- 3. Create Devices Categories & Metadata
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(100) NOT NULL, -- Laptops, Cameras, Kitchen Appliances
    Description NVARCHAR(255)
);

CREATE TABLE SupportedDevices (
    DeviceID INT PRIMARY KEY IDENTITY(1,1),
    DeviceName NVARCHAR(100) NOT NULL, -- e.g., Mirrorless Camera, Microwave Oven
    ModelNumber VARCHAR(50),
    Brand NVARCHAR(50),
    CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID)
);

-- 4. Create Common Issues Table (التي عرضناها بجانب الكاميرا وباقي الأجهزة)
CREATE TABLE CommonIssues (
    IssueID INT PRIMARY KEY IDENTITY(1,1),
    IssueTitle NVARCHAR(150) NOT NULL, -- e.g., Lens Mechanical Failure
    DescriptionText NVARCHAR(500),
    DeviceID INT FOREIGN KEY REFERENCES SupportedDevices(DeviceID)
);

-- 5. Create Repair Orders & Status (يرتبط ببوكس وصف المشكلة)
CREATE TABLE OrderStatuses (
    StatusID INT PRIMARY KEY IDENTITY(1,1),
    StatusName NVARCHAR(50) NOT NULL UNIQUE -- Pending, Diagnostics, Repairing, Completed
);

CREATE TABLE RepairOrders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    DeviceID INT FOREIGN KEY REFERENCES SupportedDevices(DeviceID),
    ProblemDescription NVARCHAR(MAX) NOT NULL, -- النص الذي يكتبه اليوزر في الـ Description Box
    StatusID INT FOREIGN KEY REFERENCES OrderStatuses(StatusID) DEFAULT 1,
    EstimatedCost DECIMAL(10,2),
    TermsAccepted BIT NOT NULL DEFAULT 1, -- للتحقق من موافقة المستخدم على الـ Terms & Conditions
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);

-- 6. Create Help Center & FAQ Table (لقسم الـ Help Center)
CREATE TABLE HelpCenterFAQs (
    FAQID INT PRIMARY KEY IDENTITY(1,1),
    Question NVARCHAR(255) NOT NULL,
    Answer NVARCHAR(MAX) NOT NULL,
    Category NVARCHAR(50) -- General, Repairs, Account
);
GO

-- ==========================================
-- INSERTING SEED DATA (البيانات التجريبية لملء الجداول)
-- ==========================================

-- Insert Roles
INSERT INTO Roles (RoleName) VALUES ('Customer'), ('Expert'), ('Admin');

-- Insert Users
INSERT INTO Users (FullName, Email, PasswordHash, PhoneNumber, RoleID) VALUES 
(N'Ahmad Mohammad', 'ahmad@example.com', 'hashed_pwd_123', '0791234567', 1),
(N'Sophia Carter', 'sophia.c@fixit.com', 'expert_pwd_456', '0789876543', 2); -- الـ CTO كخبير صيانة

-- Insert Categories
INSERT INTO Categories (CategoryName, Description) VALUES 
(N'Computing', N'Laptops, Desktops, and related hardware'),
(N'Digital Imaging', N'Professional and compact digital cameras'),
(N'Kitchen Appliances', N'Microwaves, Ovens, and smart kitchen gear');

-- Insert Supported Devices (التي اخترنا صورها معاً)
INSERT INTO SupportedDevices (DeviceName, ModelNumber, Brand, CategoryID) VALUES 
(N'Premium Silver Laptop', 'XPS-13', 'Dell', 1),
(N'Professional Mirrorless Camera', 'Alpha 7', 'Sony', 2),
(N'Countertop Microwave Oven', 'MW-2026', 'Panasonic', 3),
(N'Built-in Electric Oven', 'OV-900', 'Bosch', 3);

-- Insert Common Issues (أعطال الكاميرا التي رتبناها بالإنجليزية)
INSERT INTO CommonIssues (IssueTitle, DescriptionText, DeviceID) VALUES 
(N'Lens Mechanical Failure', N'Stuck or jammed lens barrels that prevent zooming.', 2),
(N'Sensor Dust & Debris', N'Spots appearing on images due to internal sensor dust.', 2),
(N'Shutter Error', N'Mechanical failure of the shutter curtain.', 2);

---- Insert Order Statuses
INSERT INTO OrderStatuses (StatusName) VALUES 
('Pending'), ('In Diagnostics'), ('Repairing'), ('Ready for Pickup');

-- Insert Sample Repair Order
INSERT INTO RepairOrders (UserID, DeviceID, ProblemDescription, StatusID, EstimatedCost, TermsAccepted) VALUES 
(1, 2, N'The camera lens gets stuck halfway when turning it on. No physical impact, happened suddenly.', 1, 45.00, 1);

-- Insert Help Center FAQs
INSERT INTO HelpCenterFAQs (Question, Answer, Category) VALUES 
(N'How is the repair cost calculated?', N'Initial diagnostics are free if repaired with us. Otherwise, a standard check-up fee applies.', 'Repairs'),
(N'Do you provide a warranty on replaced parts?', N'Yes, all hardware repairs come with a standard 30-to-90 day warranty.', 'General');
GO