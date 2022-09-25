USE master -- Stop using the database so it can be dropped

DROP DATABASE IF EXISTS Menschen;

CREATE DATABASE Menschen
GO

USE Menschen


---- Geschlecht ----

CREATE TABLE Geschlecht
(
	-- Fields --

	ID
		UNIQUEIDENTIFIER
		NOT NULL,
	Binär -- Binary or on a spectrum? Analog, you might say...
		BIT
		NOT NULL,
	Name -- Attack Helicopter
		NVARCHAR(MAX),
	Anrede -- Herr and Frau happen to have the same length
		NCHAR(4),
	Pronomen
		NVARCHAR(3)
		NOT NULL,
	GrussEndung -- Sehr geehrte(r/s)
		NVARCHAR(4),

	-- Constraints --
	CONSTRAINT PK_Geschlecht PRIMARY KEY
		(ID),

	CONSTRAINT CK_Geschlecht_Anrede CHECK -- No Anrede works too, just leave it out
		(Anrede IN ('Herr', 'Frau')),
	CONSTRAINT CK_Geschlecht_Pronomen CHECK -- er, sie, er/sie, es, german isn't so progressive
		(Pronomen IN ('er', 'sie'))
)
Go



---- Strasse ----

CREATE TABLE Strasse
(
	-- Fields --

	ID
		UNIQUEIDENTIFIER
		NOT NULL,
	Name
		NVARCHAR(MAX)
		NOT NULL,

	-- Constraints --

	CONSTRAINT PK_Strasse PRIMARY KEY
		(ID)
)
Go



---- Land ----

CREATE TABLE Land
(
	-- Fields --
	
	ID
		UNIQUEIDENTIFIER
		NOT NULL,
	Name -- No UNIQUE constraint, to avoid starting a war
		NVARCHAR(MAX)
		NOT NULL

	-- Constraints --

	CONSTRAINT PK_Land PRIMARY KEY
		(ID)
)
Go



---- Ort ----

CREATE TABLE Ort
(
	-- Fields --

	ID
		UNIQUEIDENTIFIER
		NOT NULL,
	Name
		NVARCHAR(MAX)
		NOT NULL,
	Land -- Are there adresses outside of countries...? I hope not
		UNIQUEIDENTIFIER
		NOT NULL,

	-- Constraints --

	CONSTRAINT PK_Ort PRIMARY KEY
		(ID)
)
Go



---- Adresse ----

CREATE TABLE Adresse
(
	-- Fields --

	ID
		UNIQUEIDENTIFIER
		NOT NULL,
	Strasse
		UNIQUEIDENTIFIER
		NOT NULL,
	Nummer -- worlds longest street number: 986039, TINYINT is not enough
		INT
		NOT NULL,
	PLZ -- Feel free to make a table for those ¯\_(ツ)_/¯
		NVARCHAR(10)
		NOT NULL,
	Ort
		UNIQUEIDENTIFIER
		NOT NULL,

	-- Constraints --

	CONSTRAINT PK_Adresse PRIMARY KEY
		(ID)
)
Go



---- Mensch ----

CREATE TABLE Mensch
(
	-- Fields --

	ID
		UNIQUEIDENTIFIER
		NOT NULL,
	Vorname -- some cultures have no first names
		NVARCHAR(MAX),
	Name -- but you gotta have at least one name
		NVARCHAR(MAX)
		NOT NULL,
	Geburtsdatum
		DATE,
	Geschlecht
		UNIQUEIDENTIFIER
		NOT NULL,
	Adresse
		UNIQUEIDENTIFIER
		NOT NULL,
	EMail
		NVARCHAR(254) -- that's fixed
		NOT NULL,
	Telefon
		NVARCHAR (15) -- ITU-T recommendation E.164 alegedly says max 15 digits
		NOT NULL,

	-- Constraints --

	CONSTRAINT PK_Mensch PRIMARY KEY
		(ID),

	CONSTRAINT FK_Mensch_Geschlecht FOREIGN KEY
		(Geschlecht) REFERENCES Geschlecht (ID),
	CONSTRAINT FK_Mensch_Adresse FOREIGN KEY
		(Adresse) REFERENCES Adresse (ID),

	CONSTRAINT CHK_Mensch_Geburtsdatum CHECK -- When do you really becoma a human...?
		(Geburtsdatum < GETDATE()),
	CONSTRAINT CHK_Mensch_Telefon CHECK -- ITU-T recommendation E.164 alegedly says max 15 digits
		(LEN(Telefon) <= 15)
)
Go