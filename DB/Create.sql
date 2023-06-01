--CREATE DATABASE CadetAccounting

USE CadetAccounting
GO

DROP TABLE IF EXISTS [Payment], [ClassesList], [Class], [Contract], [Cadet], [Group], [Teacher], [LicenseCategory]

CREATE TABLE [LicenseCategory](
  [ID] INT IDENTITY NOT NULL,
  [Name] VARCHAR(30) NOT NULL,
  CONSTRAINT [PK__LicenseCategory__ID] PRIMARY KEY ([ID])
)
GO

CREATE TABLE [Teacher](
  [ID] INT IDENTITY NOT NULL,
  [Surname] VARCHAR(30) NOT NULL,
  [Name] VARCHAR(30) NOT NULL,
  [Patronymic] VARCHAR(30) NOT NULL,
  [Phone] VARCHAR(13) NOT NULL,
  CONSTRAINT [PK__Teacher__ID] PRIMARY KEY ([ID]),
)
GO

CREATE TABLE [Group](
  [ID] INT IDENTITY NOT NULL,
  [LicenseCategoryID] INT NOT NULL,
  [TeacherID] INT NOT NULL,
  [Name] VARCHAR(30) NOT NULL,
  [Type] VARCHAR(30) NOT NULL,
  [DateStart] DATE NOT NULL,
  [DateEnd] DATE NOT NULL,
  CONSTRAINT [PK__Group__ID] PRIMARY KEY ([ID]),
  CONSTRAINT [FK__Group__LicenseCategory] FOREIGN KEY ([LicenseCategoryID]) REFERENCES [LicenseCategory]([ID]),
  CONSTRAINT [FK__Group__Teacher] FOREIGN KEY ([TeacherID]) REFERENCES [Teacher]([ID])
)
GO

CREATE TABLE [Class](
  [ID] INT IDENTITY NOT NULL,
  [Name] VARCHAR(30) NOT NULL,
  [Date] DATE NOT NULL,
  [Time] TIME NOT NULL,
  [RoomNumber] INT NOT NULL,
  CONSTRAINT [PK__Class__ID] PRIMARY KEY ([ID]),
)
GO

CREATE TABLE [ClassesList](
  [ID] INT IDENTITY NOT NULL,
  [GroupID] INT NOT NULL,
  [ClassID] INT NOT NULL,
  CONSTRAINT [PK__ClassesList__ID] PRIMARY KEY ([ID]),
  CONSTRAINT [FK__ClassesList__Group] FOREIGN KEY ([GroupID]) REFERENCES [Group]([ID]),
  CONSTRAINT [FK__ClassesList__Class] FOREIGN KEY ([ClassID]) REFERENCES [Class]([ID])
)
GO

CREATE TABLE [Cadet](
  [ID] INT IDENTITY NOT NULL,
  [GroupID] INT NOT NULL,
  [Surname] VARCHAR(30) NOT NULL,
  [Name] VARCHAR(30) NOT NULL,
  [Patronymic] VARCHAR(30) NOT NULL,
  [Phone] VARCHAR(13) NOT NULL,
  [Email] VARCHAR(50) NOT NULL,
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

CREATE OR ALTER TRIGGER CreatePayments ON [Contract]
AFTER INSERT
AS
	DECLARE @I INT = (SELECT [StepCount] FROM inserted)
	DECLARE @PaymentDate DATE = (SELECT G.DateStart 
								 FROM inserted I
								 JOIN Cadet C ON I.CadetID = C.ID
								 JOIN [Group] G ON C.GroupID = G.ID)
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
	SELECT DISTINCT CAD.Surname, CAD.[Name], CAD.Patronymic, CAD.Phone, CON.DateOfConclusion, CON.TotalPrice, CON.StepCount, (SELECT COUNT(Paid) FROM Payment WHERE ContractID = CON.ID AND Paid = 1) AS 'PaidSteps',
		(SELECT ISNULL(SUM(PaymentPrice),0) FROM Payment WHERE ContractID = CON.ID AND Paid = 1) AS 'CurrentPaidSum', (SELECT COUNT(Paid) FROM Payment WHERE ContractID = CON.ID AND Paid = 0) AS 'UnpaidSteps',
		(SELECT ISNULL(SUM(PaymentPrice),0) FROM Payment WHERE ContractID = CON.ID AND Paid = 0) AS 'PaymentArrears'
	FROM [Contract] CON
	JOIN [Payment] PAY ON CON.ID = PAY.ContractID
	JOIN [Cadet] CAD ON CON.CadetID = CAD.ID
	JOIN [Group] GR ON CAD.GroupID = GR.ID
	JOIN [LicenseCategory] LIC ON GR.LicenseCategoryID = LIC.ID
	WHERE GR.[Name] = @GROUP
GO

INSERT INTO LicenseCategory VALUES
	('АМ'),
	('А'),
	('А1'),
	('В'),
	('С'),
	('D'),
	('ВЕ'),
	('СЕ'),
	('DE'),
	('F'),
	('I')
GO

--SET DATEFORMAT dmy; 

--INSERT INTO [Group] VALUES
--	(4,'1B', '21.03.2022','21.08.2022'),
--	(4,'2B', '11.03.2023','11.08.2023'),
--	(4,'3B', '21.06.2023','21.11.2023'),
--	(2,'1A', '11.03.2023','11.08.2023'),
--	(2,'2A', '21.03.2023','21.08.2023'),
--	(2,'3A', '21.06.2023','21.11.2023'),
--	(5,'1C', '21.04.2023','21.09.2023'),
--	(5,'2C', '21.05.2023','21.10.2023'),
--	(5,'3C', '21.7.2023','21.12.2023'),
--	(6,'1D', '21.03.2023','21.08.2023')
--GO
  
--INSERT INTO [Cadet] VALUES
--	(1,'Макаров','Георгий','Глебович','+375441112233'),
--	(1,'Иванков','Корнелий','Кириллович','+375441112234'),
--	(1,'Петухов','Пантелей','Борисович','+375441112235'),
--	(1,'Селезнёв','Тимур','Игнатьевич','+375441112236'),
--	(1,'Комаров','Власий','Олегович','+375441112237'),
--	(1,'Носков','Иннокентий','Павлович','+375441112238'),
--	(1,'Игнатов','Клемент','Валерьевич','+375441112239'),
--	(1,'Большаков','Аполлон','Платонович','+375441112240'),
--	(1,'Муравьёв','Вадим','Улебович','+375441112241'),
--	(1,'Исаков','Вениамин','Тарасович','+375441112242'),
--	(1,'Романов','Гордей','Михайлович','+375441112243'),
--	(1,'Комаров','Прохор','Игоревич','+375441112244'),
--	(1,'Егоров','Вадим','Куприянович','+375441112245'),
--	(1,'Виноградов','Роман','Всеволодович','+375441112246'),
--	(1,'Блинов','Вилен','Федосеевич','+375441112247'),
--	(1,'Потапова','Неонила','Кирилловна','+375441112248'),
--	(1,'Галкина','Нила','Станиславовна','+375441112249'),
--	(1,'Сорокина','Ландыш','Протасьевна','+375441112250'),
--	(1,'Нестерова','Эльза','Альбертовна','+375441112251'),
--	(1,'Степанова','Доминика','Святославовна','+375441112252'),
--	(1,'Павлова','Альберта','Борисовна','+375441112253'),
--	(1,'Ермакова','Ася','Мироновна','+375441112254'),
--	(1,'Агафонова','Зоряна','Дмитриевна','+375441112255'),
--	(1,'Ефремова','Земфира','Юлиановна','+375441112256'),
--	(1,'Беспалова','Элиза','Агафоновна','+375441112257'),
--	(1,'Фомина','Лея','Тихоновна','+375441112258'),
--	(1,'Лазарева','Анастасия','Максовна','+375441112259'),
--	(1,'Егорова','Аза','Анатольевна','+375441112260'),
--	(1,'Рябова','Элла','Семеновна','+375441112261'),
--	(1,'Воронова','Ольга','Максовна','+375441112262'),
--	(2,'Макаров','Георгий','Глебович','+375451112233'),
--	(2,'Иванков','Корнелий','Кириллович','+375451112234'),
--	(2,'Петухов','Пантелей','Борисович','+375451112235'),
--	(2,'Селезнёв','Тимур','Игнатьевич','+375451112236'),
--	(2,'Комаров','Власий','Олегович','+375451112237'),
--	(2,'Носков','Иннокентий','Павлович','+375451112238'),
--	(2,'Игнатов','Клемент','Валерьевич','+375451112239'),
--	(2,'Большаков','Аполлон','Платонович','+375451112240'),
--	(2,'Муравьёв','Вадим','Улебович','+375451112241'),
--	(2,'Исаков','Вениамин','Тарасович','+375451112242'),
--	(2,'Романов','Гордей','Михайлович','+375451112243'),
--	(2,'Комаров','Прохор','Игоревич','+375451112244'),
--	(2,'Егоров','Вадим','Куприянович','+375451112245'),
--	(2,'Виноградов','Роман','Всеволодович','+375451112246'),
--	(2,'Блинов','Вилен','Федосеевич','+375451112247'),
--	(2,'Потапова','Неонила','Кирилловна','+375451112248'),
--	(2,'Галкина','Нила','Станиславовна','+375451112249'),
--	(2,'Сорокина','Ландыш','Протасьевна','+375451112250'),
--	(2,'Нестерова','Эльза','Альбертовна','+375451112251'),
--	(2,'Степанова','Доминика','Святославовна','+375451112252'),
--	(2,'Павлова','Альберта','Борисовна','+375451112253'),
--	(2,'Ермакова','Ася','Мироновна','+375451112254'),
--	(2,'Агафонова','Зоряна','Дмитриевна','+375451112255'),
--	(2,'Ефремова','Земфира','Юлиановна','+375451112256'),
--	(2,'Беспалова','Элиза','Агафоновна','+375451112257'),
--	(2,'Фомина','Лея','Тихоновна','+375451112258'),
--	(2,'Лазарева','Анастасия','Максовна','+375451112259'),
--	(2,'Егорова','Аза','Анатольевна','+375451112260'),
--	(2,'Рябова','Элла','Семеновна','+375451112261'),
--	(2,'Воронова','Ольга','Максовна','+375451112262'),
--	(3,'Макаров','Георгий','Глебович','+375291112233'),
--	(3,'Иванков','Корнелий','Кириллович','+375291112234'),
--	(3,'Петухов','Пантелей','Борисович','+375291112235'),
--	(3,'Селезнёв','Тимур','Игнатьевич','+375291112236'),
--	(3,'Комаров','Власий','Олегович','+375291112237'),
--	(3,'Носков','Иннокентий','Павлович','+375291112238'),
--	(3,'Игнатов','Клемент','Валерьевич','+375291112239'),
--	(3,'Большаков','Аполлон','Платонович','+375291112240'),
--	(3,'Муравьёв','Вадим','Улебович','+375291112241'),
--	(3,'Исаков','Вениамин','Тарасович','+375291112242'),
--	(3,'Романов','Гордей','Михайлович','+375291112243'),
--	(3,'Комаров','Прохор','Игоревич','+375291112244'),
--	(3,'Егоров','Вадим','Куприянович','+375291112245'),
--	(3,'Виноградов','Роман','Всеволодович','+375291112246'),
--	(3,'Блинов','Вилен','Федосеевич','+375291112247'),
--	(3,'Потапова','Неонила','Кирилловна','+375291112248'),
--	(3,'Галкина','Нила','Станиславовна','+375291112249'),
--	(3,'Сорокина','Ландыш','Протасьевна','+375291112250'),
--	(3,'Нестерова','Эльза','Альбертовна','+375291112251'),
--	(3,'Степанова','Доминика','Святославовна','+375291112252'),
--	(3,'Павлова','Альберта','Борисовна','+375291112253'),
--	(3,'Ермакова','Ася','Мироновна','+375291112254'),
--	(3,'Агафонова','Зоряна','Дмитриевна','+375291112255'),
--	(3,'Ефремова','Земфира','Юлиановна','+375291112256'),
--	(3,'Беспалова','Элиза','Агафоновна','+375291112257'),
--	(3,'Фомина','Лея','Тихоновна','+375291112258'),
--	(3,'Лазарева','Анастасия','Максовна','+375291112259'),
--	(3,'Егорова','Аза','Анатольевна','+375291112260'),
--	(3,'Рябова','Элла','Семеновна','+375291112261'),
--	(3,'Воронова','Ольга','Максовна','+375291112262')
--GO

--INSERT INTO [Contract] VALUES (1,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (2,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (3,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (4,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (5,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (6,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (7,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (8,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (9,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (10,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (11,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (12,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (13,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (14,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (15,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (16,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (17,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (18,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (19,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (20,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (21,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (22,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (23,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (24,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (25,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (26,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (27,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (28,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (29,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (30,'15.03.2022',2, 460, 920)
--INSERT INTO [Contract] VALUES (31,'01.03.2023',1, 910, 910)
--INSERT INTO [Contract] VALUES (32,'01.03.2023',1, 910, 910)
--INSERT INTO [Contract] VALUES (33,'01.03.2023',1, 910, 910)
--INSERT INTO [Contract] VALUES (34,'01.03.2023',1, 910, 910)
--INSERT INTO [Contract] VALUES (35,'01.03.2023',1, 910, 910)
--INSERT INTO [Contract] VALUES (36,'01.03.2023',1, 910, 910)
--INSERT INTO [Contract] VALUES (37,'01.03.2023',1, 910, 910)
--INSERT INTO [Contract] VALUES (38,'01.03.2023',1, 910, 910)
--INSERT INTO [Contract] VALUES (39,'01.03.2023',1, 910, 910)
--INSERT INTO [Contract] VALUES (40,'01.03.2023',3, 310, 930)
--INSERT INTO [Contract] VALUES (41,'01.03.2023',3, 310, 930)
--INSERT INTO [Contract] VALUES (42,'01.03.2023',3, 310, 930)
--INSERT INTO [Contract] VALUES (43,'01.03.2023',3, 310, 930)
--INSERT INTO [Contract] VALUES (44,'01.03.2023',3, 310, 930)
--INSERT INTO [Contract] VALUES (45,'01.03.2023',3, 310, 930)
--INSERT INTO [Contract] VALUES (46,'01.03.2023',3, 310, 930)
--INSERT INTO [Contract] VALUES (47,'01.03.2023',3, 310, 930)
--INSERT INTO [Contract] VALUES (48,'01.03.2023',3, 310, 930)
--INSERT INTO [Contract] VALUES (49,'01.03.2023',3, 310, 930)
--INSERT INTO [Contract] VALUES (50,'01.03.2023',3, 310, 930)
--INSERT INTO [Contract] VALUES (51,'01.03.2023',3, 310, 930)
--INSERT INTO [Contract] VALUES (52,'01.03.2023',3, 310, 930)
--INSERT INTO [Contract] VALUES (53,'01.03.2023',3, 310, 930)
--INSERT INTO [Contract] VALUES (54,'01.03.2023',3, 310, 930)
--INSERT INTO [Contract] VALUES (55,'01.03.2023',3, 310, 930)
--INSERT INTO [Contract] VALUES (56,'01.03.2023',3, 310, 930)
--INSERT INTO [Contract] VALUES (57,'01.03.2023',3, 310, 930)
--INSERT INTO [Contract] VALUES (58,'01.03.2023',3, 310, 930)
--INSERT INTO [Contract] VALUES (59,'01.03.2023',3, 310, 930)
--INSERT INTO [Contract] VALUES (60,'01.03.2023',3, 310, 930)
--INSERT INTO [Contract] VALUES (61,'05.06.2023',1, 940, 940)
--INSERT INTO [Contract] VALUES (62,'05.06.2023',1, 940, 940)
--INSERT INTO [Contract] VALUES (63,'05.06.2023',1, 940, 940)
--INSERT INTO [Contract] VALUES (64,'05.06.2023',1, 940, 940)
--INSERT INTO [Contract] VALUES (65,'05.06.2023',1, 940, 940)
--INSERT INTO [Contract] VALUES (66,'05.06.2023',1, 940, 940)
--INSERT INTO [Contract] VALUES (67,'05.06.2023',1, 940, 940)
--INSERT INTO [Contract] VALUES (68,'05.06.2023',1, 940, 940)
--INSERT INTO [Contract] VALUES (69,'05.06.2023',1, 940, 940)
--INSERT INTO [Contract] VALUES (70,'05.06.2023',1, 940, 940)
--INSERT INTO [Contract] VALUES (71,'05.06.2023',1, 940, 940)
--INSERT INTO [Contract] VALUES (72,'05.06.2023',2, 520, 1040)
--INSERT INTO [Contract] VALUES (73,'05.06.2023',2, 520, 1040)
--INSERT INTO [Contract] VALUES (74,'05.06.2023',2, 520, 1040)
--INSERT INTO [Contract] VALUES (75,'05.06.2023',2, 520, 1040)
--INSERT INTO [Contract] VALUES (76,'05.06.2023',2, 520, 1040)
--INSERT INTO [Contract] VALUES (77,'05.06.2023',2, 520, 1040)
--INSERT INTO [Contract] VALUES (78,'05.06.2023',2, 520, 1040)
--INSERT INTO [Contract] VALUES (79,'05.06.2023',2, 520, 1040)
--INSERT INTO [Contract] VALUES (80,'05.06.2023',2, 520, 1040)
--INSERT INTO [Contract] VALUES (81,'05.06.2023',2, 520, 1040)
--INSERT INTO [Contract] VALUES (82,'05.06.2023',2, 520, 1040)
--INSERT INTO [Contract] VALUES (83,'05.06.2023',3, 330, 990)
--INSERT INTO [Contract] VALUES (84,'05.06.2023',3, 330, 990)
--INSERT INTO [Contract] VALUES (85,'05.06.2023',3, 330, 990)
--INSERT INTO [Contract] VALUES (86,'05.06.2023',3, 330, 990)
--INSERT INTO [Contract] VALUES (87,'05.06.2023',3, 330, 990)
--INSERT INTO [Contract] VALUES (88,'05.06.2023',3, 330, 990)
--INSERT INTO [Contract] VALUES (89,'05.06.2023',3, 330, 990)
--INSERT INTO [Contract] VALUES (90,'05.06.2023',3, 330, 990)
--GO