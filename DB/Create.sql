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
	('��'),
	('�'),
	('�1'),
	('�'),
	('�'),
	('D'),
	('��'),
	('��'),
	('DE'),
	('F'),
	('I')
GO

INSERT INTO [Teacher] VALUES
	('�������','�������','��������','+375441112233'),
	('�������','��������','����������','+375441112234'),
	('�������','��������','���������','+375441112235'),
	('�������','�����','����������','+375441112236'),
	('�������','������','��������','+375441112237'),
	('������','����������','��������','+375441112238'),
	('�������','�������','����������','+375441112239'),
	('���������','�������','����������','+375441112240'),
	('��������','�����','��������','+375441112241'),
	('������','��������','���������','+375441112242'),
	('�������','������','����������','+375441112243'),
	('�������','������','��������','+375441112244'),
	('������','�����','�����������','+375441112245'),
	('����������','�����','������������','+375441112246'),
	('������','�����','����������','+375441112247'),
	('��������','�������','����������','+375441112248'),
	('�������','����','�������������','+375441112249'),
	('��������','������','�����������','+375441112250'),
	('���������','�����','�����������','+375441112251'),
	('���������','��������','�������������','+375441112252'),
	('�������','��������','���������','+375441112253'),
	('��������','���','���������','+375441112254')

SET DATEFORMAT dmy; 

INSERT INTO [Group] VALUES
	(4,1,'1B', '��������', '21.03.2022','21.08.2022'),
	(4,2,'2B', '��������', '11.03.2023','11.08.2023'),
	(4,3,'3B', '��������', '21.06.2023','21.11.2023'),
	(2,4,'1A', '��������', '11.03.2023','11.08.2023'),
	(2,5,'2A', '��������� ���', '21.03.2023','21.08.2023'),
	(2,6,'3A', '��������� ���', '21.06.2023','21.11.2023'),
	(5,7,'1C', '��������', '21.04.2023','21.09.2023'),
	(5,8,'2C', '��������� ���', '21.05.2023','21.10.2023'),
	(5,9,'3C', '��������', '21.7.2023','21.12.2023'),
	(6,10,'1D', '��������', '21.03.2023','21.08.2023')
GO
  
INSERT INTO [Cadet] VALUES
	(1,'�������','�������','��������','+375441112233', 'makarovgeorg@gmail.com'),
	(1,'�������','��������','����������','+375441112234', 'ivanovkornel@gmail.com'),
	(1,'�������','��������','���������','+375441112235', 'petyhovpantele@gmail.com'),
	(1,'�������','�����','����������','+375441112236', 'selethenovtimur@gmail.com'),
	(1,'�������','������','��������','+375441112237', 'komarovlasy@gmail.com'),
	(1,'������','����������','��������','+375441112238', 'noskov@gmail.com'),
	(1,'�������','�������','����������','+375441112239', 'ignatov@gmail.com'),
	(1,'���������','�������','����������','+375441112240', 'boleshakovapalon@gmail.com'),
	(1,'��������','�����','��������','+375441112241', 'myravevvadim@gmail.com'),
	(1,'������','��������','���������','+375441112242', 'isakov@gmail.com'),
	(1,'�������','������','����������','+375441112243', 'romanov@gmail.com'),
	(1,'�������','������','��������','+375441112244', 'komarproxor@gmail.com'),
	(1,'������','�����','�����������','+375441112245', 'egorovvadim@gmail.com'),
	(1,'����������','�����','������������','+375441112246', 'vinogradovroman@gmail.com'),
	(1,'������','�����','����������','+375441112247', 'blinov@gmail.com'),
	(1,'��������','�������','����������','+375441112248', 'potapov@gmail.com'),
	(1,'�������','����','�������������','+375441112249', 'Galkina@gmail.com'),
	(1,'��������','������','�����������','+375441112250', 'Sorokina@gmail.com'),
	(1,'���������','�����','�����������','+375441112251', 'NesterovaEltha@gmail.com'),
	(1,'���������','��������','�������������','+375441112252', 'stepanovadominika@gmail.com'),
	(1,'�������','��������','���������','+375441112253', 'pavlov@gmail.com'),
	(1,'��������','���','���������','+375441112254', 'ermakov@gmail.com'),
	(1,'���������','������','����������','+375441112255', 'aganovazorayna@gmail.com'),
	(1,'��������','�������','���������','+375441112256', 'efremov@gmail.com'),
	(1,'���������','�����','����������','+375441112257', 'bespalova@gmail.com'),
	(1,'������','���','���������','+375441112258', 'fominalie@gmail.com'),
	(1,'��������','���������','��������','+375441112259', 'lazarev22@gmail.com'),
	(1,'�������','���','�����������','+375441112260', 'egorov23@gmail.com'),
	(1,'������','����','���������','+375441112261', 'rybovaella@gmail.com'),
	(1,'��������','�����','��������','+375441112262', 'voronov@gmail.com'),
	(2,'�������','�������','��������','+375451112233', 'makarovgeorge@gmail.com'),
	(2,'�������','��������','����������','+375451112234', 'ivankovan@gmail.com'),
	(2,'�������','��������','���������','+375451112235', 'petyuhov123@gmail.com'),
	(2,'�������','�����','����������','+375451112236', 'selesen23@gmail.com'),
	(2,'�������','������','��������','+375451112237', 'komarov@gmail.com'),
	(2,'������','����������','��������','+375451112238', 'nosovink@gmail.com'),
	(2,'�������','�������','����������','+375451112239', 'igansa1@gmail.com'),
	(2,'���������','�������','����������','+375451112240', 'bolshak@gmail.com'),
	(2,'��������','�����','��������','+375451112241', 'myrafd@gmail.com'),
	(2,'������','��������','���������','+375451112242', 'isakov@gmail.com'),
	(2,'�������','������','����������','+375451112243', 'romanovich@gmail.com'),
	(2,'�������','������','��������','+375451112244', 'komarchyk@gmail.com'),
	(2,'������','�����','�����������','+375451112245', 'egorovich@gmail.com'),
	(2,'����������','�����','������������','+375451112246', 'vinogradov@gmail.com'),
	(2,'������','�����','����������','+375451112247', 'blynovich@gmail.com'),
	(2,'��������','�������','����������','+375451112248', 'potapovna@gmail.com'),
	(2,'�������','����','�������������','+375451112249', 'ufkrbyf@gmail.com'),
	(2,'��������','������','�����������','+375451112250', 'sorokinas@gmail.com'),
	(2,'���������','�����','�����������','+375451112251', 'nesterovna@gmail.com'),
	(2,'���������','��������','�������������','+375451112252', 'stepanochik@gmail.com'),
	(2,'�������','��������','���������','+375451112253', 'pavlovich@gmail.com'),
	(2,'��������','���','���������','+375451112254', 'ermak321@gmail.com'),
	(2,'���������','������','����������','+375451112255', 'agan12@gmail.com'),
	(2,'��������','�������','���������','+375451112256', 'efrem45@gmail.com'),
	(2,'���������','�����','����������','+375451112257', 'bespalov55@gmail.com'),
	(2,'������','���','���������','+375451112258', 'fomina2000@gmail.com'),
	(2,'��������','���������','��������','+375451112259', 'lazarev@gmail.com'),
	(2,'�������','���','�����������','+375451112260', 'egorovasd@gmail.com'),
	(2,'������','����','���������','+375451112261', 'arsdjja@gmail.com'),
	(2,'��������','�����','��������','+375451112262', 'fdasdf@gmail.com'),
	(3,'�������','�������','��������','+375291112233', 'makaromarkovewwvgeorg@gmail.com'),
	(3,'�������','��������','����������','+375291112234', 'inkoivanch@gmail.com'),
	(3,'�������','��������','���������','+375291112235', 'petyhov878@gmail.com'),
	(3,'�������','�����','����������','+375291112236', 'sel232@gmail.com'),
	(3,'�������','������','��������','+375291112237', 'kom321@gmail.com'),
	(3,'������','����������','��������','+375291112238', 'noskob89@gmail.com'),
	(3,'�������','�������','����������','+375291112239', 'ignatik@gmail.com'),
	(3,'���������','�������','����������','+375291112240', 'bigname@gmail.com'),
	(3,'��������','�����','��������','+375291112241', 'myraveob@gmail.com'),
	(3,'������','��������','���������','+375291112242', 'isakov@gmail.com'),
	(3,'�������','������','����������','+375291112243', 'romanov@gmail.com'),
	(3,'�������','������','��������','+375291112244', 'komar64@gmail.com'),
	(3,'������','�����','�����������','+375291112245', 'egora22@gmail.com'),
	(3,'����������','�����','������������','+375291112246', 'vinman@gmail.com'),
	(3,'������','�����','����������','+375291112247', 'blinman@gmail.com'),
	(3,'��������','�������','����������','+375291112248', 'potapov2111@gmail.com'),
	(3,'�������','����','�������������','+375291112249', 'galka66@gmail.com'),
	(3,'��������','������','�����������','+375291112250', 'soroka21@gmail.com'),
	(3,'���������','�����','�����������','+375291112251', 'nester@gmail.com'),
	(3,'���������','��������','�������������','+375291112252', 'stepan@gmail.com'),
	(3,'�������','��������','���������','+375291112253', 'pavolov@gmail.com'),
	(3,'��������','���','���������','+375291112254', 'ermak2135@gmail.com'),
	(3,'���������','������','����������','+375291112255', 'a12gafon@gmail.com'),
	(3,'��������','�������','���������','+375291112256', 'erma123n@gmail.com'),
	(3,'���������','�����','����������','+375291112257', 'bespal51@gmail.com'),
	(3,'������','���','���������','+375291112258', 'foma77@gmail.com'),
	(3,'��������','���������','��������','+375291112259', 'laser123@gmail.com'),
	(3,'�������','���','�����������','+375291112260', 'egorovaAza@gmail.com'),
	(3,'������','����','���������','+375291112261', 'r16ova@gmail.com'),
	(3,'��������','�����','��������','+375291112262', 'voronovaol1ga@gmail.com')
GO

INSERT INTO [Contract] VALUES (1,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (2,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (3,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (4,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (5,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (6,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (7,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (8,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (9,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (10,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (11,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (12,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (13,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (14,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (15,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (16,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (17,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (18,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (19,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (20,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (21,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (22,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (23,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (24,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (25,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (26,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (27,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (28,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (29,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (30,'15.03.2022',2, 460, 920)
INSERT INTO [Contract] VALUES (31,'01.03.2023',1, 910, 910)
INSERT INTO [Contract] VALUES (32,'01.03.2023',1, 910, 910)
INSERT INTO [Contract] VALUES (33,'01.03.2023',1, 910, 910)
INSERT INTO [Contract] VALUES (34,'01.03.2023',1, 910, 910)
INSERT INTO [Contract] VALUES (35,'01.03.2023',1, 910, 910)
INSERT INTO [Contract] VALUES (36,'01.03.2023',1, 910, 910)
INSERT INTO [Contract] VALUES (37,'01.03.2023',1, 910, 910)
INSERT INTO [Contract] VALUES (38,'01.03.2023',1, 910, 910)
INSERT INTO [Contract] VALUES (39,'01.03.2023',1, 910, 910)
INSERT INTO [Contract] VALUES (40,'01.03.2023',3, 310, 930)
INSERT INTO [Contract] VALUES (41,'01.03.2023',3, 310, 930)
INSERT INTO [Contract] VALUES (42,'01.03.2023',3, 310, 930)
INSERT INTO [Contract] VALUES (43,'01.03.2023',3, 310, 930)
INSERT INTO [Contract] VALUES (44,'01.03.2023',3, 310, 930)
INSERT INTO [Contract] VALUES (45,'01.03.2023',3, 310, 930)
INSERT INTO [Contract] VALUES (46,'01.03.2023',3, 310, 930)
INSERT INTO [Contract] VALUES (47,'01.03.2023',3, 310, 930)
INSERT INTO [Contract] VALUES (48,'01.03.2023',3, 310, 930)
INSERT INTO [Contract] VALUES (49,'01.03.2023',3, 310, 930)
INSERT INTO [Contract] VALUES (50,'01.03.2023',3, 310, 930)
INSERT INTO [Contract] VALUES (51,'01.03.2023',3, 310, 930)
INSERT INTO [Contract] VALUES (52,'01.03.2023',3, 310, 930)
INSERT INTO [Contract] VALUES (53,'01.03.2023',3, 310, 930)
INSERT INTO [Contract] VALUES (54,'01.03.2023',3, 310, 930)
INSERT INTO [Contract] VALUES (55,'01.03.2023',3, 310, 930)
INSERT INTO [Contract] VALUES (56,'01.03.2023',3, 310, 930)
INSERT INTO [Contract] VALUES (57,'01.03.2023',3, 310, 930)
INSERT INTO [Contract] VALUES (58,'01.03.2023',3, 310, 930)
INSERT INTO [Contract] VALUES (59,'01.03.2023',3, 310, 930)
INSERT INTO [Contract] VALUES (60,'01.03.2023',3, 310, 930)
INSERT INTO [Contract] VALUES (61,'05.06.2023',1, 940, 940)
INSERT INTO [Contract] VALUES (62,'05.06.2023',1, 940, 940)
INSERT INTO [Contract] VALUES (63,'05.06.2023',1, 940, 940)
INSERT INTO [Contract] VALUES (64,'05.06.2023',1, 940, 940)
INSERT INTO [Contract] VALUES (65,'05.06.2023',1, 940, 940)
INSERT INTO [Contract] VALUES (66,'05.06.2023',1, 940, 940)
INSERT INTO [Contract] VALUES (67,'05.06.2023',1, 940, 940)
INSERT INTO [Contract] VALUES (68,'05.06.2023',1, 940, 940)
INSERT INTO [Contract] VALUES (69,'05.06.2023',1, 940, 940)
INSERT INTO [Contract] VALUES (70,'05.06.2023',1, 940, 940)
INSERT INTO [Contract] VALUES (71,'05.06.2023',1, 940, 940)
INSERT INTO [Contract] VALUES (72,'05.06.2023',2, 520, 1040)
INSERT INTO [Contract] VALUES (73,'05.06.2023',2, 520, 1040)
INSERT INTO [Contract] VALUES (74,'05.06.2023',2, 520, 1040)
INSERT INTO [Contract] VALUES (75,'05.06.2023',2, 520, 1040)
INSERT INTO [Contract] VALUES (76,'05.06.2023',2, 520, 1040)
INSERT INTO [Contract] VALUES (77,'05.06.2023',2, 520, 1040)
INSERT INTO [Contract] VALUES (78,'05.06.2023',2, 520, 1040)
INSERT INTO [Contract] VALUES (79,'05.06.2023',2, 520, 1040)
INSERT INTO [Contract] VALUES (80,'05.06.2023',2, 520, 1040)
INSERT INTO [Contract] VALUES (81,'05.06.2023',2, 520, 1040)
INSERT INTO [Contract] VALUES (82,'05.06.2023',2, 520, 1040)
INSERT INTO [Contract] VALUES (83,'05.06.2023',3, 330, 990)
INSERT INTO [Contract] VALUES (84,'05.06.2023',3, 330, 990)
INSERT INTO [Contract] VALUES (85,'05.06.2023',3, 330, 990)
INSERT INTO [Contract] VALUES (86,'05.06.2023',3, 330, 990)
INSERT INTO [Contract] VALUES (87,'05.06.2023',3, 330, 990)
INSERT INTO [Contract] VALUES (88,'05.06.2023',3, 330, 990)
INSERT INTO [Contract] VALUES (89,'05.06.2023',3, 330, 990)
INSERT INTO [Contract] VALUES (90,'05.06.2023',3, 330, 990)
GO

INSERT INTO [Class] VALUES
	('���, �������� �������', '21.03.2022','13:30', 10),
	('���, �������� �������', '24.03.2022','13:30', 10),
	('���, �������� �������', '28.03.2022','13:30', 10),
	('���, �������� �������', '31.03.2022','13:30', 10),
	('���, �������� �������', '7.04.2022','13:30', 10),
	('����� ����������� ���������', '7.04.2022','13:30', 10),
	('����� ����������� ���������', '10.04.2022','13:30', 10),
	('����� ����������� ���������', '14.04.2022','13:30', 10),
	('����� ����������� ���������', '17.04.2022','13:30', 10),
	('����� ����������� ���������', '21.04.2022','13:30', 10),
	('����������� ���������', '24.04.2022','13:30', 10),
	('����������� ���������', '28.04.2022','13:30', 10),
	('����� ����������� ����������', '7.05.2022','13:30', 10),
	('����� ����������� ���������', '10.05.2022','13:30', 10),
	('�������� �����', '14.05.2022','13:30', 10),
	('�������� �����', '17.05.2022','13:30', 10),
	('�������� �����', '21.05.2022','13:30', 10),
	('�������� �����', '24.05.2022','13:30', 10),
	('�������� �����', '4.06.2022','13:30', 10),
	('�������� �����', '7.06.2022','13:30', 10),
	('�������� �����', '11.06.2022','13:30', 10)
GO

INSERT INTO [ClassesList] VALUES
	(1,1),
	(1,2),
	(1,3),
	(1,4),
	(1,5),
	(1,6),
	(1,7),
	(1,8),
	(1,9),
	(1,10),
	(1,11),
	(1,12),
	(1,13),
	(1,14),
	(1,15),
	(1,16),
	(1,17),
	(1,18),
	(1,19),
	(1,20),
	(1,21)
GO