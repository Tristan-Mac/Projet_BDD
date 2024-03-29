IF(DB_ID(N'parc_auto')IS NULL)
    CREATE DATABASE [parc_auto]

GO

USE [parc_auto]

GO

IF NOT EXISTS(
    SELECT [name]
    FROM [sysobjects]
    WHERE [name] = 'vehicule'
            AND [xtype] = 'u'
)

    CREATE TABLE [dbo].[vehicule_VEH](
        [id_vehicule] INT IDENTITY(1,1) PRIMARY KEY,
        [couleur_vehicule] NVARCHAR(20) NOT NULL,
        [premiere_mise_en_circulation] DATETIME2,
        [kilometre_vehicule] FLOAT NOT NULL,
        [disponibilite_vehicule] BIT, 
    )

GO

IF NOT EXISTS(
    SELECT [name]
    FROM [sysobjects]
    WHERE [name] = 'client'
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
    WHERE [name] = 'modele'
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
    WHERE [name] = 'location'
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


 
