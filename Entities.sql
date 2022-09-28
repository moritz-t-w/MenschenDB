USE master -- Stop using the database so it can be dropped

DROP DATABASE IF EXISTS Menschen;

CREATE DATABASE Menschen
GO

USE Menschen


---- Geschlecht ----

CREATE TABLE Geschlecht
(
	ID
		UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT PK_Geschlecht PRIMARY KEY
		CONSTRAINT DF_Geschlecht_ID DEFAULT NEWID(),
	Binär -- Binary or on a spectrum? Analog, you might say...
		BIT
		NOT NULL,
	Name -- Attack Helicopter
		NVARCHAR(MAX),
	Anrede -- Herr and Frau happen to have the same length
		NCHAR(4)
		CONSTRAINT CK_Geschlecht_Anrede CHECK (Anrede IN ('Herr', 'Frau')),-- No Anrede works too, just leave it out
	Pronomen
		NVARCHAR(3)
		NOT NULL
		CONSTRAINT CK_Geschlecht_Pronomen CHECK (Pronomen IN ('er', 'sie', 'er/sie')),
	GrussEndung -- Sehr geehrte(r/s)
		NVARCHAR(4),
)
Go



---- Strasse ----

CREATE TABLE Strasse
(

	ID
		UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT PK_Strasse PRIMARY KEY
		CONSTRAINT DF_Strasse_ID DEFAULT NEWID(),
	Name
		NVARCHAR(MAX)
		NOT NULL,
)
Go



---- Land ----

CREATE TABLE Land
(ID
		UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT PK_Land PRIMARY KEY
		CONSTRAINT DF_Land_ID DEFAULT NEWID(),
	Name -- No UNIQUE constraint, to avoid starting a war
		NVARCHAR(MAX)
		NOT NULL
)
Go



---- Ort ----

CREATE TABLE Ort
(
	ID
		UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT PK_Ort PRIMARY KEY
		CONSTRAINT DF_Ort_ID DEFAULT NEWID(),
	Name
		NVARCHAR(MAX)
		NOT NULL,
	Land -- Are there adresses outside of countries...? I hope not
		UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT FK_Ort_Land FOREIGN KEY REFERENCES Land(ID)
)
Go



---- Adresse ----

CREATE TABLE Adresse
(
	ID
		UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT PK_Adresse PRIMARY KEY
		CONSTRAINT DF_Adresse_ID DEFAULT NEWID(),
	Strasse
		UNIQUEIDENTIFIER

NOT NULL
CONSTRAINT FK_Adresse_Strasse FOREIGN KEY REFERENCES Strasse
(ID),
	Nummer -- worlds longest street number: 986039, TINYINT is not enough
		INT
		NOT NULL,
	PLZ -- Feel free to make a table for those ¯\_(ツ)_/¯
		NVARCHAR(10)
		NOT NULL,
	Ort
		UNIQUEIDENTIFIER

NOT NULL
CONSTRAINT FK_Adresse_Ort FOREIGN KEY REFERENCES Ort
(ID),
)
Go

-- KrankheitsKategorie ----

CREATE TABLE KrankheitsKategorie
(
	ID UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT PK_KrankheitsKategorie PRIMARY KEY
		CONSTRAINT DF_KrankheitsKategorie_ID DEFAULT NEWID(),
	Name NVARCHAR(MAX)
		NOT NULL
)
GO

---- Krankheit ----

CREATE TABLE Krankheit
(
	ID UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT PK_Krankheit PRIMARY KEY
		CONSTRAINT DF_Krankheit_ID DEFAULT NEWID(),
	Name
		NVARCHAR(MAX)
		NOT NULL,
	Beschreibung
		TEXT
		NOT NULL,
	Behandlung
		TEXT
		NOT NULL,
	Kategorie
		UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT FK_Krankheit_Kategorie REFERENCES KrankheitsKategorie(ID)
)
GO

---- Symptom ----

CREATE TABLE Symptom
(
	ID UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT PK_Symptom PRIMARY KEY
		CONSTRAINT DF_Symptom_ID DEFAULT NEWID(),
	Name
		NVARCHAR(MAX)
		NOT NULL,
	Beschreibung
		TEXT
		NOT NULL
)
GO
---- Krankheit hat Symptom ----

CREATE TABLE KrankheitSymptom
(
	Krankheit UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT DF_KrankheitSymptom_Krankheit DEFAULT NEWID()
		CONSTRAINT FK_KrankheitSymptom_Krankheit REFERENCES Krankheit (ID),
	Symptom UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT FK_KrankheitSymptom_Symptom REFERENCES Symptom (ID),


CONSTRAINT PK_KrankheitSymptom
PRIMARY KEY
(Krankheit, Symptom)
)
GO

---- BeschaeftigungsKategorie ----

CREATE TABLE BeschaeftigungsKategorie
(
	ID UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT PK_BeschaeftigungsKategorie PRIMARY KEY
		CONSTRAINT DF_BeschaeftigungsKategorie_ID DEFAULT NEWID() FOR ID,
	Name NVARCHAR(MAX)
		NOT NULL
)
GO

---- Beschaeftigung ----

CREATE TABLE Beschaeftigung
(
	ID UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT PK_Beschaeftigung PRIMARY KEY
		CONSTRAINT DF_Beschaeftigung_ID DEFAULT NEWID() FOR ID,
	Name NVARCHAR(MAX)
		NOT NULL,
	Beschreibung TEXT,
	Kategorie UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT FK_Beschaeftigung_Kategorie REFERENCES BeschaeftigungsKategorie(ID)
)
GO
---- Mensch ----

CREATE TABLE Mensch
(
	ID
		UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT PK_Mensch PRIMARY KEY
		CONSTRAINT DF_Mensch_ID DEFAULT NEWID(),
	Vorname -- some cultures have no first names
		NVARCHAR(MAX),
	Name -- but you gotta have at least one name
		NVARCHAR(MAX)
		NOT NULL,
	Geburtsdatum
		DATE
		NOT NULL
		CONSTRAINT CK_Mensch_Geburtsdatum CHECK (Geburtsdatum < GETDATE()), -- When do you really becoma a human...?
	Geschlecht
		UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT FK_Mensch_Geschlecht FOREIGN KEY REFERENCES Geschlecht(ID),
	Adresse
		UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT FK_Mensch_Adresse FOREIGN KEY REFERENCES Adresse(ID),
	EMail
		NVARCHAR(254) -- that's fixed
		NOT NULL,
	Telefon
		NVARCHAR (15) -- ITU-T recommendation E.164 alegedly says max 15 digits
		NOT NULL
		CONSTRAINT CK_Mensch_Telefon CHECK (LEN(Telefon) > 5)
)
Go

---- Mensch hat Beschaeftigung bei Arbeitgeber ----

CREATE TABLE MenschBeschaeftigungArbeitgeber
(
	Mensch UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT FK_MenschBeschaeftigung_Mensch REFERENCES Mensch (ID),
	Beschaeftigung UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT FK_MenschBeschaeftigung_Beschaeftigung REFERENCES Beschaeftigung (ID),
	Arbeitgeber UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT FK_MenschBeschaeftigung_Arbeitgeber REFERENCES Arbeitgeber (ID),
	Beginn DATE
		NOT NULL,
	Ende DATE,
	Arbeitsstunden FLOAT
		NOT NULL,
	Monatslohn MONEY,
	Kuendingungsfrist
		INT,
	CONSTRAINT PK_MenschBeschaeftigung PRIMARY KEY (Mensch, Beschaeftigung, Arbeitgeber)
)
GO

---- Mensch hat Krankheit ----

CREATE TABLE MenschKrankheit
(
	Mensch UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT DF_MenschKrankheit_Mensch DEFAULT NEWID()
		CONSTRAINT FK_MenschKrankheit_Mensch REFERENCES Mensch (ID),
	Krankheit UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT FK_MenschKrankheit_Krankheit REFERENCES Krankheit (ID),
	Diagnose
		DATE
		NOT NULL,

	CONSTRAINT PK_MenschKrankheit PRIMARY KEY (Mensch, Krankheit)
)
GO

---- Arzt -----
CREATE TABLE Arzt
(
	ID UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT PK_Arzt PRIMARY KEY
		CONSTRAINT FK_Arzt_Mensch FOREIGN KEY REFERENCES Mensch(ID)
)
GO

---- Mensch wird wegen Krankheit behandelt ----

CREATE TABLE Behandlung
(
	ID UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT PK_Behandlung PRIMARY KEY
		CONSTRAINT DF_Behandlung_ID DEFAULT NEWID(),
	Mensch UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT FK_Behandlung_Mensch REFERENCES Mensch (ID),
	Krankheit UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT FK_Behandlung_Krankheit REFERENCES Krankheit (ID),
	Datum
		DATE
		NOT NULL,
	Start
		TIME
		NOT NULL,
	Ende
		TIME
		NOT NULL,
	Arzt
		UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT FK_Behandlung_Arzt REFERENCES Arzt (ID)
		CONSTRAINT CK_Behandlung_Arzt CHECK (Mensch <> Arzt),
	Notiz
		TEXT
		NOT NULL
)
GO