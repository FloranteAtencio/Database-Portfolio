--DROP DATABASE IF EXISTS DFA

--CREATE DATABASE DFA 

--USE DFA

--FarmersInfo
--R:{
--1	2	3	4	5	6	7	8
--}
--FD :{ 1 -> 2 to 8} Highest Normal Form(BCNF) CK:{1}
DROP TABLE IF EXISTS FarmersInfo; 
CREATE TABLE FarmersInfo (
  PK_farmersInfo INT PRIMARY KEY IDENTITY(1,1),
  firstName NVARCHAR(100)  ,
  lastName NVARCHAR(100)   ,
  middleName Nvarchar(100),
  Birthday Date  ,
 [Block] Nvarchar(50),
  Street Nvarchar(50),
  baranggay Nvarchar(5)   
);

CREATE INDEX idx_First_Last ON FarmersInfo (firstName, lastName)
ALTER INDEX idx_First_Last ON FarmersInfo DISABLE

--Farm Technician
--R:{
--9	10	11	12	13	14	15
--}	
--FD:{ 9-> 10 to 15}     Highest Normal Form(BCNF) CK:{9}
DROP TABLE IF EXISTS [FarmTechnician]; 
CREATE TABLE [FarmTechnician] (
  [PK_farmTechnician] INT PRIMARY KEY IDENTITY(1,1),
  [firstname]   Nvarchar(25),
  [middleName] Nvarchar(25),
  [lastName]   Nvarchar(25),
  [assignBarangay]   Nvarchar(10),
  [desingation] Nvarchar(25),
  [ContactNumber] Nvarchar(25)
);

CREATE INDEX idx_First_Last_tech ON [FarmTechnician] ([firstname], [lastName])
ALTER INDEX idx_First_Last_tech ON [FarmTechnician] DISABLE

--LandTill	
--R:{
--16	17	18		
--}
--FD:{16 ->1, 17, 18} Highest Normal Form(BCNF) CK:{16}
DROP TABLE IF EXISTS [LandTill];
CREATE TABLE [LandTill] (
  [BaranggayLocation]   Nvarchar(5),
  [squareMeter] DECIMAL(10,2),
  [ProofofEntitledLand]   Nvarchar(25) PRIMARY KEY,
  [PK_farmerInfo]   INT,
  CONSTRAINT [FK_LandTill.PK_farmerInfo]
    FOREIGN KEY ([PK_farmerInfo])
      REFERENCES [FarmersInfo]([PK_farmersInfo]) 
	  ON DELETE NO ACTION 
	  ON UPDATE NO ACTION
);

--Contact
--R:{
--1	32	33								
--}
--FD:{19 ->1, 20, 21} Highest Normal Form(BCNF) CK:{19}
CREATE TABLE [Contact] (
  [PK_contact] INT PRIMARY KEY IDENTITY(1,1),
  [Cellphone] Nvarchar(12),
  [Telcom] Nvarchar(50),
  [FK_farmerInfo] INT,
  CONSTRAINT [FK_Contact.FK_farmerInfo]
    FOREIGN KEY ([FK_farmerInfo])
      REFERENCES [FarmersInfo]([PK_farmersInfo]) ON DELETE NO ACTION ON UPDATE NO ACTION
);

--Live Stock Info
--R:{
--22	23	24					
--}
--FD:{ 22 -> 23, 24} Highest Normal Form{BCNF} CK:{22}
CREATE TABLE [liveStockinfo] (
  [PK_liveStockInfo]  INT PRIMARY KEY IDENTITY(1,1) ,
  [liveStockinfo]  Nvarchar(50) ,
 [Description]  Nvarchar(100) 
);

--Live Stock
--R:{
--25	26	22	1	9	
--}
--FD:{ 25->26, 22, 1, 9 } Highest Normal Form{2NF} CK:{25}
CREATE TABLE [LiveStock] (
  [PK_LiveStock] INT PRIMARY KEY IDENTITY(1,1) ,
  [FK_personalInf] INT,
  [FK_liveStock] INT,
  [quantity] INT,
  [FK_farmTechnician] INT,
  CONSTRAINT [FK_LiveStock.FK_personalInf]
    FOREIGN KEY ([FK_personalInf])
      REFERENCES [FarmersInfo]([PK_farmersInfo])ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT [FK_LiveStock.FK_liveStock]
    FOREIGN KEY ([FK_liveStock])
      REFERENCES [liveStockinfo]([PK_liveStockInfo]) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT [FK_LiveStock.FK_farmTechnician]
    FOREIGN KEY ([FK_farmTechnician])
      REFERENCES [FarmTechnician]([PK_farmTechnician]) ON DELETE NO ACTION ON UPDATE NO ACTION
);

--Brand Seed
--R:{
--27	28	29	30				
--}
--FD:{ 27 -> 28, 29, 30} Highest Normal Form{BCNF} CK:{27}
CREATE TABLE [BrandSeed] (
  [PK_brandSeed] INT PRIMARY KEY IDENTITY(1,1) ,
  [brandName] Nvarchar(50),
  [seed] Nvarchar(50),
  [price] Nvarchar(50)
);

CREATE INDEX idx_brandName ON [BrandSeed] (brandName)
ALTER INDEX idx_brandName ON [BrandSeed] DISABLE

--Season Crop
--R:{
--31	32	33			
--}
--FD:{ 31 -> 32 33 27, 1, 9} Highest Normal Form{BCNF} CK:{31}
CREATE TABLE [SeasonCrop] (
  [PK_SeasonCrop] INT PRIMARY KEY IDENTITY(1,1) ,
  [FK_farmerInfo] INT,
  [FK_brandSeed] INT,
  [estimatedCost] Decimal,
  [SubsGrant] Bit,
  [FK_farmTechnician] INT,
  CONSTRAINT [FK_SeasonCrop.FK_farmerInfo]
    FOREIGN KEY ([FK_farmerInfo])
      REFERENCES [BrandSeed]([PK_brandSeed]) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT [FK_SeasonCrop.FK_farmTechnician]
    FOREIGN KEY ([FK_farmTechnician])
      REFERENCES [FarmTechnician]([PK_farmTechnician]) ON DELETE NO ACTION ON UPDATE NO ACTION
);

--Season
--R:{
--34	35	36	37		
--}
--FD:{ 34,-> 31, 35, 36, 37} Highest Normal Form{BCNF} CK:{34}
CREATE TABLE [Season] (
  [PK_season] INT PRIMARY KEY IDENTITY(1,1),
  [Season] NVARCHAR(25),
  [dateStart] Date,
  [dateEnd] Date,
  [FK_seasonCrop] INT,
  CONSTRAINT [FK_Season.FK_seasonCrop]
    FOREIGN KEY ([FK_seasonCrop])
      REFERENCES [SeasonCrop]([PK_SeasonCrop]) ON DELETE NO ACTION ON UPDATE NO ACTION
);

--CompanyProvider
--R:{
--38, 39, 40, 41, 42
--}
--FD:{ 38 -> 39 to 42} Highest Normal Form{BCNF} CK:{34}
CREATE TABLE [CompanyProvider] (
  [Company] NVARchar,
  [PK_BrandName] Nvarchar(25) PRIMARY KEY  ,
  [OriginalPrice] Decimal,
  [Classification] Nvarchar(25),
  [description] Nvarchar(255)
);


--Subsidized
--R:{
--43 , 44, 45
--}
--FD:{  43 -> 1, 38, 44, 45} Highest Normal Form{BCNF} CK:{43}
CREATE TABLE [Subsidized] (
  [PK_subsidized] INT PRIMARY KEY IDENTITY(1,1),
  [Date] Date,
  [SubsidizedPrice] Decimal,
  [FK_personalInfo] INT,
  [FK_BrandName] Nvarchar(25),
  CONSTRAINT [FK_Subsidized.FK_personalInfo]
    FOREIGN KEY ([FK_personalInfo])
      REFERENCES [FarmersInfo]([PK_farmersInfo]) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT [FK_Subsidized.FK_BrandName]
    FOREIGN KEY ([FK_BrandName])
      REFERENCES [CompanyProvider]([PK_BrandName]) ON DELETE NO ACTION ON UPDATE NO ACTION
);


--Incident Type
--R:{
--46 , 47, 48
--}
--FD:{46 -> 47,48} Highest Normal Form{BCNF} CK:{46}

DROP TABLE IF EXISTS [IncidentType];
CREATE TABLE [IncidentType] (
  [PK_incidentType] INT PRIMARY KEY IDENTITY(1,1),
  [incidentType] Nvarchar(255),
  [description] Nvarchar(255)
);
--Stock Incident
--R:{
--49, 50, 51, 52
--}
--FD:{49 -> 46, 1, 9 50 to 52} Highest Normal Form{BCNF} CK:{49}
DROP TABLE IF EXISTS [StockIncident];
CREATE TABLE [StockIncident] (
  [PK_stockIncident] INT PRIMARY KEY IDENTITY(1,1),
  [FK_personalInfo] INT,
  [descriptionAdd] Nvarchar(255),
  [dateOccured] date,
  [dateReported] date,
  [FK_incidentType] INT,
  [FK_farmTechnician] INT,
  CONSTRAINT [FK_Stock Incident.FK_farmTechnician]
    FOREIGN KEY ([FK_farmTechnician])
      REFERENCES [FarmTechnician]([PK_farmTechnician]) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT [FK_Stock Incident.FK_personalInfo]
    FOREIGN KEY ([FK_personalInfo])
      REFERENCES [FarmersInfo]([PK_farmersInfo]) ON DELETE NO ACTION ON UPDATE NO ACTION,
	    CONSTRAINT [CROPINCIDENT_INCEDENTTYPES]
	FOREIGN KEY ([FK_incidentType])
		REFERENCES [IncidentType]([PK_incidentType]) ON DELETE NO ACTION ON UPDATE NO ACTION
);

--Crop Incident
--R:{
--53,54,55,56
--}
--FD:{53 -> 46, 1, 9, 54 to 56} Highest Normal Form{BCNF} CK:{53}
DROP TABLE IF EXISTS [CropIncident];
CREATE TABLE [CropIncident] (
  [PK_cropIncident] INT PRIMARY KEY IDENTITY(1,1),
  [FK_personalInfo] INT,
  [dateOccured] date,
  [dareReported] date,
  [descriptionAdd] Nvarchar(255),
  [FK_incidentType] INT,
  [FK_farmTechnician] INT,
  CONSTRAINT [FK_Crop Incident.FK_personalInfo]
    FOREIGN KEY ([FK_personalInfo])
      REFERENCES [FarmersInfo]([PK_farmersInfo]) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT [FK_Crop Incident.FK_farmTechnician]
    FOREIGN KEY ([FK_farmTechnician])
      REFERENCES [FarmTechnician]([PK_farmTechnician]) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT [CROPINCIDENT_INCEDENTTYP]
	FOREIGN KEY ([FK_incidentType])
		REFERENCES [IncidentType]([PK_incidentType]) ON DELETE NO ACTION ON UPDATE NO ACTION
);


-----------------------------------------------Function---------------------------------------------------------------------
DROP FUNCTION IF EXISTS Full_Name1;
CREATE FUNCTION Full_Name1
(
  @PK_farmersInfo INT
)
RETURNS NVARCHAR(100)
AS
BEGIN 

DECLARE @full_name AS NVarchar(100)

SELECT @Full_name = CONCAT(lastName, ', ',  firstName, ' ',middleName)
FROM FarmersInfo
WHERE PK_FarmersInfo =  @PK_farmersInfo;

RETURN @full_name

END 

DROP FUNCTION IF EXISTS Full_Name2;
CREATE FUNCTION Full_Name2
(
  @PK_farmersInfo INT
)
RETURNS NVARCHAR
AS
BEGIN 

DECLARE @Full_name Varchar(100)

SELECT @Full_name = CONCAT(firstName, ' ', middleName, ' ' ,lastName)
FROM FarmersInfo
WHERE PK_FarmersInfo =  @PK_farmersInfo;

RETURN @Full_name

END

DROP FUNCTION IF EXISTS Age1;
CREATE FUNCTION Age1
(
  @PK_farmersInfo INT
)
RETURNS INT
AS
BEGIN 

DECLARE @Age AS INT

SELECT @Age= (Year(GETDATE()) - Year(Birthday))
FROM FarmersInfo
WHERE PK_FarmersInfo =  @PK_farmersInfo;

RETURN @Age

END

CREATE FUNCTION Contact_Lists
(
  @PK_farmersInfo INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN 

DECLARE @CONTACTS NVARCHAR(MAX)

SELECT  @CONTACTS = STRING_AGG (CONVERT(NVARCHAR(MAX), b.Cellphone), ',')
FROM FarmersInfo a
JOIN Contact b ON a.PK_farmersInfo = b.FK_farmerInfo
WHERE a.PK_FarmersInfo =  @PK_farmersInfo;

RETURN @CONTACTS

END

CREATE FUNCTION Till_Lists
(
  @PK_farmersInfo INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN 

DECLARE @ProofofEntitledLand NVARCHAR(MAX)

SELECT @ProofofEntitledLand = STRING_AGG (CONVERT(NVARCHAR(MAX), ProofofEntitledLand), ',') 
FROM FarmersInfo a
JOIN LandTill b ON a.PK_farmersInfo = b.PK_farmerInfo
WHERE a.PK_farmersInfo =  @PK_farmersInfo;

RETURN @ProofofEntitledLand

END
