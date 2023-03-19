--CREATE DATABASE CadetAccounting

USE CadetAccounting
GO

DROP TABLE IF EXISTS [Payment], [Contract], [Cadet], [Group], [LicenseCategory]

CREATE TABLE [LicenseCategory](
  [ID] INT IDENTITY NOT NULL,
  [Name] VARCHAR(30) NOT NULL,
  CONSTRAINT [PK__LicenseCategory__ID] PRIMARY KEY ([ID])
)
GO

CREATE TABLE [Group](
  [ID] INT IDENTITY NOT NULL,
  [LicenseCategoryID] INT NOT NULL,
  [Name] VARCHAR(30) NOT NULL,
  [DateStart] DATE NOT NULL,
  [DateEnd] DATE NOT NULL,
  CONSTRAINT [PK__Group__ID] PRIMARY KEY ([ID]),
  CONSTRAINT [FK__Group__LicenseCategory] FOREIGN KEY ([LicenseCategoryID]) REFERENCES [LicenseCategory]([ID])
)
GO

CREATE TABLE [Cadet](
  [ID] INT IDENTITY NOT NULL,
  [GroupID] INT NOT NULL,
  [Surname] VARCHAR(30) NOT NULL,
  [Name] VARCHAR(30) NOT NULL,
  [Patronymic] VARCHAR(30) NOT NULL,
  [Phone] VARCHAR(13) NOT NULL,
  CONSTRAINT [PK__Cadet__ID] PRIMARY KEY ([ID]),
  CONSTRAINT [FK__Cadet__Group] FOREIGN KEY ([GroupID]) REFERENCES [Group]([ID])
)
GO

CREATE TABLE [Contract](
  [ID] INT IDENTITY NOT NULL,
  [CadetID] INT NOT NULL,
  [DateOfConclusion] DATE NOT NULL,
  [StepCount] INT NOT NULL,
  [StepPrice] DECIMAL(14,2) NOT NULL,
  [TotalPrice] DECIMAL(14,2) NULL,
  CONSTRAINT [PK__Contract__ID] PRIMARY KEY ([ID]),
  CONSTRAINT [FK__Contract__Cadet] FOREIGN KEY ([CadetID]) REFERENCES [Cadet]([ID])
)
GO

CREATE TABLE [Payment](
  [ID] INT IDENTITY NOT NULL,
  [ContractID] INT NOT NULL,
  [PaymentPrice] DECIMAL(14,2) NOT NULL,
  [PaymentDate] DATE NOT NULL,
  [Paid] BIT NULL DEFAULT(0),
  CONSTRAINT [PK__Payment__ID] PRIMARY KEY ([ID]),
  CONSTRAINT [FK__Payment__Contract] FOREIGN KEY ([ContractID]) REFERENCES [Contract]([ID])
)
GO

CREATE OR ALTER TRIGGER ContractTotalPrice ON [Contract]
AFTER INSERT, UPDATE
AS
	UPDATE [Contract] SET [TotalPrice] = (SELECT (StepCount * StepPrice) FROM inserted)
	WHERE ID = (SELECT ID FROM inserted)
GO

CREATE OR ALTER TRIGGER CreatePayments ON [Contract]
AFTER INSERT
AS
	DECLARE @I INT = (SELECT [StepCount] FROM inserted)
	DECLARE @PaymentDate DATE = (SELECT [DateOfConclusion] FROM inserted)
	DECLARE @Step INT = (SELECT DATEDIFF(DAY,G.DateStart,G.DateEnd) / I.StepCount FROM inserted I
		JOIN Cadet CA ON CA.ID = I.CadetID
		JOIN [Group] G ON CA.GroupID = G.ID)
	DECLARE @ID INT = (SELECT ID FROM inserted)
	DECLARE @StepPrice DECIMAL(14,2) = (SELECT StepPrice FROM inserted)

	WHILE(@I > 0)
	BEGIN
		INSERT INTO [Payment] ([ContractID],[PaymentPrice],[PaymentDate]) VALUES (@ID, @StepPrice, @PaymentDate)
		SET @PaymentDate = DATEADD(DAY, @Step, @PaymentDate)
		SET @I = @I - 1
	END
GO

CREATE OR ALTER PROC PaymentGroupReport
	@GROUP VARCHAR(30)
AS
	SELECT CAD.Surname, CAD.[Name], CAD.Patronymic, CAD.Phone, CON.DateOfConclusion, CON.TotalPrice, CON.StepCount, (SELECT COUNT(Paid) FROM Payment WHERE Paid = 1) AS 'PaidSteps',
		(SELECT ISNULL(SUM(PaymentPrice),0) FROM Payment WHERE Paid = 1) AS 'CurrentPaidSum', (SELECT COUNT(Paid) FROM Payment WHERE Paid = 0) AS 'UnpaidSteps',
		(SELECT COUNT(PaymentDate) FROM Payment WHERE PaymentDate < CONVERT (date, GETDATE()) AND Paid = 0) AS 'PaymentArrears'
	FROM [Contract] CON
	JOIN [Payment] PAY ON CON.ID = PAY.ContractID
	JOIN [Cadet] CAD ON CON.CadetID = CAD.ID
	JOIN [Group] GR ON CAD.GroupID = GR.ID
	JOIN [LicenseCategory] LIC ON GR.LicenseCategoryID = LIC.ID
	WHERE GR.[Name] = @GROUP
	GROUP BY CAD.Surname, CAD.[Name], CAD.Patronymic, CAD.Phone, CON.DateOfConclusion, CON.TotalPrice, CON.StepCount
GO