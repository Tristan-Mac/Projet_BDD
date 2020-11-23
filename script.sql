IF(DB_ID(N'parc_auto')IS NULL)
    CREATE DATABASE [parc_auto]

GO

USE [parc_auto]

GO

IF NOT EXISTS(
    SELECT [name]
    FROM [sysobjects]
    WHERE [name] = 'vehicule_VEH'
            AND [xtype] = 'u'
)

    CREATE TABLE [dbo].[vehicule_VEH](
        [id_vehicule] INT IDENTITY(1,1) PRIMARY KEY,
		[id_modele_fk] INT,/*clé secondaire*/
        [couleur_vehicule] NVARCHAR(20) NOT NULL,
        [premiere_mise_en_circulation] DATETIME2,
        [kilometre_vehicule] FLOAT NOT NULL,
        [disponibilite_vehicule] BIT, 
    )

GO

IF NOT EXISTS(
    SELECT [name]
    FROM [sysobjects]
    WHERE [name] = 'client_CLI'
            AND [xtype] = 'u'
)
CREATE TABLE [dbo].[client_CLI](
        [id_client] INT IDENTITY(1,1) PRIMARY KEY,
        [nom_client] NVARCHAR(20) NOT NULL,
        [prenom_client] NVARCHAR(20) NOT NULL,
        [adresse_client] NVARCHAR(50) NOT NULL,
        [telephone_client] INT NOT NULL,
        [type_permis_client] NVARCHAR(1) NOT NULL, 
    )

GO

IF NOT EXISTS(
    SELECT [name]
    FROM [sysobjects]
    WHERE [name] = 'modele_MOD'
            AND [xtype] = 'u'
)

    CREATE TABLE [dbo].[modele_MOD](
        [id_modele] INT IDENTITY(1,1) PRIMARY KEY,
        [marque_vehicule] NVARCHAR(20) NOT NULL,
        [modele_vehicule] NVARCHAR(20) NOT NULL,
        [vitesse_max_vehicule] INT NOT NULL,
        [poids_vehicule] FLOAT NOT NULL,
        [puissance_vehicule] INT NOT NULL,
        [annee_sortie_usine_vehicule] DATE NOT NULL,
        [type_vehicule] NVARCHAR(15) NOT NULL, 
        [place_vehicule] INT NOT NULL,
        [energie_vehicule] NVARCHAR(10) NOT NULL,
    )

GO

GO
	IF NOT EXISTS(
    SELECT [name]
    FROM [sysobjects]
    WHERE [name] = 'location_LOC'
            AND [xtype] = 'u'
)   

	CREATE TABLE [dbo].[location_LOC](
        [id_location] INT IDENTITY(1,1) PRIMARY KEY,
        [id_vehicule_fk] INT /*clé secondaire */,
        [id_client_fk] INT /*clé secondaire*/,
        [date_debut_location] DATETIME2,
        [date_fin_location] DATETIME2,
        [disponibilite] BIT,
 
    )

GO
/*
GO
	ALTER TABLE [dbo].[vehicule_VEH]
	ADD CONSTRAINT FK_VEH_IDMOD FOREIGN KEY([id_modele_fk])
	REFERENCES [dbo].[modele_MOD]([id_modele])
GO



GO
	ALTER TABLE [dbo].[location_LOC]
	ADD CONSTRAINT FK_LOC_VEH FOREIGN KEY([id_vehicule_fk])
	REFERENCES [dbo].[vehicule_VEH]([id_vehicule])
GO

GO
	ALTER TABLE [dbo].[location_LOC]
	ADD CONSTRAINT FK_LOC_CLT FOREIGN KEY([id_client_fk])
	REFERENCES [dbo].[client_CLI]([id_client])
GO
*/



GO
UPDATE  [dbo].[location_LOC]
    SET     [disponibilite] = '0'
    WHERE   [date_debut_location] = GETDATE()
GO

CREATE OR ALTER VIEW [dbo].[VuesDesVehiculeDispo]
AS
SELECT * 
FROM [dbo].[vehicule_VEH] AS [vhc](NOLOCK)
WHERE [id_vehicule]=(SELECT [id_vehicule_fk] FROM [location_LOC] WHERE [disponibilite]=1)

GO


/*
GO
	ALTER TABLE [dbo].[vehicule_VEH]
	ADD [kilometre_acquisition] DATETIME2
	
GO

GO
	ALTER TABLE [dbo].[vehicule_VEH]
	DROP COLUMN [kilometre_vehicule]
GO
*/

IF NOT EXISTS (
    SELECT TOP 1 [id_vehicule]
    FROM [dbo].[vehicule_VEH]
)
BEGIN
    INSERT INTO [parc_auto].[dbo].[vehicule_VEH] ([couleur_vehicule],[id_modele_fk] , [premiere_mise_en_circulation], [kilometre_acquisition], [disponibilite_vehicule])
	VALUES  (N'Rouge', 2,CAST('2007-05-08 12:35:29. 1234567 +12:15' AS datetime2(7)), 1200, 1),
            (N'Verte', 1,CAST('2007-05-08 12:35:29. 1234567 +12:15' AS datetime2(7)) , 1500.35, 0)

   
END

GO

IF NOT EXISTS(
	SELECT TOP 1 [id_modele]
	FROM [dbo].[modele_MOD]	
)
BEGIN
	INSERT INTO [parc_auto].[dbo].[modele_MOD] ([marque_vehicule], [modele_vehicule], [vitesse_max_vehicule], [poids_vehicule], [puissance_vehicule], [annee_sortie_usine_vehicule],[type_vehicule],[place_vehicule],[energie_vehicule])
    VALUES  (N'mercedes', N'classe_A', 320, 1500,300,N'2018-10-23',N'sport',4,N'essence'),
            (N'bmw', N'M5', 280, 1300,240,N'2015-02-17',N'break',4,N'gazole')

   

END
GO

IF NOT EXISTS(
	SELECT TOP 1 [id_client]
	FROM [dbo].[client_CLI]	
)
BEGIN
	INSERT INTO [parc_auto].[dbo].[client_CLI] ([nom_client], [prenom_client], [adresse_client], [telephone_client], [type_permis_client])
    VALUES  (N'Sarkozy', N'Nicolas', N'10 rue du general foy, Amiens 80000', N' 0607080910',N'B'),
			(N'Holland', N'Francois', N'9 rue du general foy, Amiens 80000', N' 0758962512',N'B')
           


END
GO

CREATE OR ALTER VIEW [dbo].[VehiculeInfo]
AS
    SELECT *
    FROM [dbo].[vehicule_VEH]

GO

SELECT * FROM [dbo].[VehiculeInfo]

GO

CREATE OR ALTER VIEW [dbo].[ClientsInfo]
AS
    SELECT *
    FROM [dbo].[client_CLI]

GO
SELECT * FROM [dbo].[ClientsInfo]

GO
CREATE OR ALTER VIEW [dbo].[ModeleInfo]
AS
    SELECT *
    FROM [dbo].[modele_MOD]

GO

SELECT * FROM [dbo].[ModeleInfo]

