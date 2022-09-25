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
		CONSTRAINT PK_Geschlecht PRIMARY KEY,
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
		CONSTRAINT PK_Strasse PRIMARY KEY,
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
		CONSTRAINT PK_Land PRIMARY KEY,
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
		CONSTRAINT PK_Ort PRIMARY KEY,
	Name
		NVARCHAR(MAX)
		NOT NULL,
	Land -- Are there adresses outside of countries...? I hope not
		UNIQUEIDENTIFIER
		NOT NULL,
)
Go



---- Adresse ----

CREATE TABLE Adresse
(
	ID
		UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT PK_Adresse PRIMARY KEY,
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
)
Go



---- Mensch ----

CREATE TABLE Mensch
(
	ID
		UNIQUEIDENTIFIER
		NOT NULL
		CONSTRAINT PK_Mensch PRIMARY KEY,
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