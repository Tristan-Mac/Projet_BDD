-- On créée la database parc auto
IF (DB_ID(N'Parc_auto7') IS NULL)
    CREATE DATABASE [Parc_auto7]

GO

-- On se positionne sur la base
USE [Parc_auto7]

GO

-- On créée la table modèle du vehicule
IF NOT EXISTS(
    SELECT [name]
    FROM [sysobjects]
    WHERE [name] = 'Modele_MOD'
            AND [xtype] = 'U'
)
BEGIN
    CREATE TABLE [dbo].[Modele_MOD](
        [Id_modele] INT IDENTITY(1,1) PRIMARY KEY,
        [marque_vehicule] NVARCHAR(20) NOT NULL,
        [modele_vehicule] NVARCHAR(20) NOT NULL,
        [poids_vehicule] FLOAT NOT NULL,
        [puissance_vehicule] INT NOT NULL,
        [annee_sortie_usine_vehicule] DATE NOT NULL,
        [type_vehicule] NVARCHAR(15) NOT NULL, 
        [place_vehicule] TINYINT NOT NULL,-- j'ai pris cette variable car le nombre de place n'a pas de grande valeur
        [energie_vehicule] NVARCHAR(10) NOT NULL,
    )

	IF NOT EXISTS (
		SELECT TOP 1 [Id_modele]
		FROM [dbo].[Modele_MOD]
	)

    INSERT INTO [Parc_auto7].[dbo].[Modele_MOD] ([marque_vehicule], [modele_vehicule], [poids_vehicule], [puissance_vehicule], [annee_sortie_usine_vehicule],[type_vehicule],[place_vehicule],[energie_vehicule])
    VALUES  (N'mercedes', N'classe_A', 320, 300, N'2018-10-23', N'sport',4, N'essence'),
            (N'bmw', N'M5', 280, 240, N'2015-02-17', N'break',4, N'gazole'),
			(N'renault', N'clio 4', 240, 190, N'2010-12-23', N'sport',4, N'diesel');

END
GO

-- On créée la table de la fiche vehicule
IF NOT EXISTS(
    SELECT [name]
    FROM [sysobjects]
    WHERE [name] = 'Vehicule_VEH'
            AND [xtype] = 'U'
)
BEGIN
    CREATE TABLE [dbo].[Vehicule_VEH](
        [Id_vehicule] INT IDENTITY(1,1) PRIMARY KEY,
		[id_modeleFk] INT NOT NULL,
        [couleur_vehicule] NVARCHAR(20) NOT NULL,
        [premiere_mise_en_circulation] DATE NOT NULL,
        [kilometre_vehicule] FLOAT NOT NULL,
		[disponibilite] BIT,
		[kilometres_acquisition]FLOAT ,
        
    )
IF NOT EXISTS (
    SELECT TOP 1 [id_vehicule]
    FROM [dbo].[Vehicule_VEH]
)
    INSERT INTO [Parc_auto7].[dbo].[vehicule_VEH] ([id_modeleFk], [couleur_vehicule], [premiere_mise_en_circulation], [kilometre_vehicule], [disponibilite],[kilometres_acquisition])
    VALUES  (1, N'Rouge', N'2010-09-07', 1200.35, 1,2000),
            (1, N'noire', N'2015-02-25', 1500.3, 1,2500),
			(2, N'Verte', N'2012-03-15', 2400.83, 1,10000);


	ALTER TABLE [dbo].[Vehicule_VEH]
    ADD CONSTRAINT FK_VEH_Modele FOREIGN KEY ([id_modeleFk])
    REFERENCES [dbo].[Modele_MOD] ([Id_modele])

END
GO

IF NOT EXISTS(
    SELECT [name]
    FROM [sysobjects]
    WHERE [name] = 'client_CLI'
            AND [xtype] = 'U'
)
BEGIN
	CREATE TABLE [dbo].[Client_CLI](
        [Id_client] INT IDENTITY(1,1) PRIMARY KEY,
        [nom_client] NVARCHAR(30) NOT NULL,
        [prenom_client] NVARCHAR(30) NOT NULL,
        [adresse_client] NVARCHAR(50) NOT NULL,
        [telephone_client] INT NOT NULL,
        [type_permis_client] NVARCHAR(1) NOT NULL, 
    )

	IF NOT EXISTS (
		SELECT TOP 1 [Id_client]
		FROM [dbo].[Client_CLI]
	)

    INSERT INTO [Parc_auto7].[dbo].[client_CLI] ([nom_client], [prenom_client], [adresse_client], [telephone_client], [type_permis_client])
    VALUES  (N'Sarkozy', N'Nicolas', N'10 rue du general foy, Amiens 80000', N' 0607080910',N'B'),
			(N'Holland', N'Francois', N'9 rue du general foy, Amiens 80000', N' 0758962512',N'B');

END
GO

IF NOT EXISTS(
    SELECT [name]
    FROM [sysobjects]
    WHERE [name] = 'Location_LOC'
            AND [xtype] = 'U'
)
BEGIN
	CREATE TABLE [dbo].[Location_LOC](
		[Id_location] INT IDENTITY(1,1) PRIMARY KEY,
		[id_vehiculeFk] INT NOT NULL,
        [id_clientFk] INT NOT NULL,
        [date_debut_location] DATETIME2 NOT NULL,
        [date_fin_location] DATETIME2 NOT NULL,
		[kilometres_parcourus] FLOAT,
		)

	ALTER TABLE [dbo].[Location_LOC]
    ADD CONSTRAINT FK_LOC_vehicule FOREIGN KEY ([id_vehiculeFk])
    REFERENCES [dbo].[Vehicule_VEH] ([Id_vehicule])


	ALTER TABLE [dbo].[Location_LOC]
    ADD CONSTRAINT FK_LOC_client FOREIGN KEY ([id_clientFk])
    REFERENCES [dbo].[Client_CLI] ([Id_client])

END
GO

CREATE OR ALTER TRIGGER [dbo].[trig_new_location]
    ON [dbo].[location_LOC] 
    AFTER INSERT 
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @VehId INT ;
	SET @VehId = 0;

	WHILE(@VehId < 10)
	BEGIN
		SET @VehId = @VehId + 1;
		IF (SELECT [date_debut_location]
			FROM [dbo].[Location_LOC]
			WHERE [id_vehiculeFk] = @VehId
			)<= GETDATE()
		BEGIN
			UPDATE  [dbo].[Vehicule_VEH]
			SET     [disponibilite] = 0
			WHERE [Id_vehicule] = @VehId 
		END
	END
END
GO

/**/
IF NOT EXISTS (
	SELECT TOP 1 [Id_location]
	FROM [dbo].[Location_LOC]
)

INSERT INTO[parc_auto7].[dbo].[location_LOC]([id_vehiculeFk],[id_clientFk],[date_debut_location],[date_fin_location],[kilometres_parcourus])
VALUES    (1,1,GETDATE(),GETDATE(),200),
           (2,2,GETDATE(),GETDATE(),5000);

GO

CREATE OR ALTER VIEW [dbo].[VehiculeInfo]
AS
    SELECT *
    FROM [dbo].[vehicule_VEH]

GO

SELECT * FROM [dbo].[VehiculeInfo]

GO

CREATE OR ALTER VIEW [dbo].[VuesDesVehiculeDispo]
AS
	SELECT *
    FROM [dbo].[Vehicule_VEH] 
    WHERE [disponibilite]=1

GO

SELECT * FROM [dbo].[VuesDesVehiculeDispo]

GO

CREATE OR ALTER FUNCTION [dbo].[kilometreAcquisitionId](@ID INT) RETURNS FLOAT AS
BEGIN
	DECLARE @kilometre_acquisition int;
	SELECT @kilometre_acquisition = [Vehicule_VEH].[kilometres_acquisition]
	FROM [dbo].[Vehicule_VEH]
	WHERE [Vehicule_VEH].[Id_vehicule] = @ID;

	RETURN(@kilometre_acquisition)
END;
	
GO
CREATE OR ALTER FUNCTION [dbo].[kilometreId](@ID INT) RETURNS FLOAT AS 
BEGIN
    DECLARE @kilometre int;
    SELECT @kilometre = SUM([kilometres_parcourus]) 
    FROM [dbo].[location_LOC]
    WHERE [location_LOC].[id_vehiculeFk] = @ID;
    
	SELECT @kilometre = @kilometre + [vehicule_VEH].[kilometres_acquisition]
	FROM [dbo].[vehicule_VEH]
	WHERE [vehicule_VEH].[id_vehicule] = @ID;
	
	RETURN(@kilometre)
END;

GO

CREATE OR ALTER FUNCTION [dbo].[KmDepuisAcquisition](@id_vehicule INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @Resultat FLOAT

    SELECT @Resultat = SUM(kilometres_parcourus)
    FROM [dbo].[location_LOC]
	WHERE [id_vehiculeFK] = @id_vehicule

    RETURN(@Resultat)
END

GO

CREATE OR ALTER FUNCTION [dbo].[KmEffectuer](@id_veh int, @DateDebut Datetime2, @DateFin Datetime2)
RETURNS FLOAT
AS
BEGIN
	DECLARE @KmAcquis FLOAT

    SELECT @KmAcquis = SUM([kilometres_parcourus])
    FROM [dbo].[Location_LOC] 
    WHERE [date_debut_location] >= @DateDebut 
    AND [date_debut_location] < @DateFin
    AND  [date_fin_location] <= @DateFin
    AND [date_fin_location] > @DateDebut
    AND [id_vehiculeFk] = @id_veh

	RETURN(@KmAcquis)

END

GO

IF NOT EXISTS (
	SELECT TOP 1 [Id_location]
	FROM [dbo].[Location_LOC]
)

INSERT INTO[parc_auto].[dbo].[location_LOC]([id_vehiculeFk],[id_clientFk],[date_debut_location],[date_fin_location],[kilometres_parcourus])
VALUES    (1,1,GETDATE(),GETDATE(),100),
           (2,2,GETDATE(),GETDATE(),50);

GO


SELECT [dbo].[KmEffectuer](1,'2010-01-01','2030-01-01') AS 'Km effectué entre 2 périodes'

GO

CREATE OR ALTER VIEW [dbo].[VehiculeInfo]
AS
    SELECT *
    FROM [dbo].[Vehicule_VEH]

GO

SELECT * FROM [dbo].[VehiculeInfo]

GO

CREATE OR ALTER VIEW [dbo].[VuesDesVehiculeDispo]
AS
	SELECT *
    FROM [dbo].[Vehicule_VEH] 
    WHERE [disponibilite]=1

GO

SELECT * FROM [dbo].[VuesDesVehiculeDispo]

GO
CREATE OR ALTER PROCEDURE VehiculeDispoOrNot
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @vehicule_dispo INTEGER
	DECLARE @vehicule_non_dispo INTEGER

	SELECT @vehicule_dispo = [Vehicule_VEH].[Id_vehicule]
	FROM [dbo].[Vehicule_VEH], [dbo].[Location_LOC]
	WHERE [Vehicule_VEH].[Id_vehicule] = [Location_LOC].[id_vehiculeFk] AND 
		[Location_LOC].[date_fin_location] = GETDATE() - 1 AND [Location_LOC].[date_debut_location] != GETDATE() ;

	UPDATE  [dbo].[Vehicule_VEH]
	SET [disponibilite] = 1
	WHERE [Id_vehicule] = @vehicule_dispo 

	SELECT @vehicule_non_dispo = [Vehicule_VEH].[Id_vehicule]
	FROM [dbo].[Vehicule_VEH], [dbo].[Location_LOC]
	WHERE [Vehicule_VEH].[Id_vehicule] = [Location_LOC].[id_vehiculeFk] AND 
		[Location_LOC].[date_debut_location] = GETDATE();

	UPDATE  [dbo].[Vehicule_VEH]
	SET [disponibilite] = 0
	WHERE [Id_vehicule] = @vehicule_non_dispo 
END