use p10g2

go

--UDFs

IF OBJECT_ID('dbo.GetTotalPetsInShelter', 'FN') IS NOT NULL
    DROP FUNCTION dbo.GetTotalPetsInShelter;
GO

IF OBJECT_ID('dbo.TotalAdoptedPetsInShelter', 'FN') IS NOT NULL
    DROP FUNCTION dbo.TotalAdoptedPetsInShelter;
GO

IF OBJECT_ID('dbo.TotalEmployeesInShelter', 'FN') IS NOT NULL
    DROP FUNCTION dbo.TotalEmployeesInShelter;
GO

IF OBJECT_ID('dbo.TotalAdoptionsByAdopter', 'FN') IS NOT NULL
    DROP FUNCTION dbo.TotalAdoptionsByAdopter;
GO

IF OBJECT_ID('dbo.PercentageAdoptedPetsInShelter', 'FN') IS NOT NULL
    DROP FUNCTION dbo.PercentageAdoptedPetsInShelter;
GO

IF OBJECT_ID('dbo.MostCommonPetBreedInShelter', 'FN') IS NOT NULL
    DROP FUNCTION dbo.MostCommonPetBreedInShelter;
GO

IF OBJECT_ID('dbo.TotalAdoptionsByAdopterInYear', 'FN') IS NOT NULL
    DROP FUNCTION dbo.TotalAdoptionsByAdopterInYear;
GO

--A function to get the total number of pets in a shelter:
CREATE FUNCTION dbo.GetTotalPetsInShelter (@shelterId INT) RETURNS INT
AS
BEGIN
    DECLARE @totalPets INT;

    -- Contar o número total de pets no abrigo especificado
    SELECT @totalPets = COUNT(*)
    FROM dbo.Pet
    WHERE ShelterId = @shelterId;

    RETURN @totalPets;
END;
GO


--A function to get the total number of adopted pets in a shelter:
CREATE FUNCTION dbo.TotalAdoptedPetsInShelter (@shelterId INT)
RETURNS INT
AS
BEGIN
    DECLARE @totalAdoptedPets INT;
    SELECT @totalAdoptedPets = COUNT(*) 
	FROM dbo.Pet 
	WHERE ShelterId = @shelterId AND EstadoDeAdocao = 1;
    RETURN @totalAdoptedPets;
END;
GO

--A function to get the total number of employees in a shelter:
CREATE FUNCTION dbo.TotalEmployeesInShelter(@shelterId INT)
RETURNS INT
AS
BEGIN
    DECLARE @totalEmployees INT;
    SELECT @totalEmployees = COUNT(*) 
	FROM dbo.Empregado 
	WHERE CC IN (SELECT CC FROM Utilizador WHERE ShelterId = @shelterId);
    RETURN @totalEmployees;
END;
GO

--A function to get the total number of adoptions made by an adopter:
CREATE FUNCTION dbo.TotalAdoptionsByAdopter(@ccAdotante VARCHAR(255))
RETURNS INT
AS
BEGIN
    DECLARE @totalAdoptions INT;
    SELECT @totalAdoptions = COUNT(*) 
	FROM Adocoes 
	WHERE CCAdotante = @ccAdotante;
    RETURN @totalAdoptions;
END;
GO


--A function to get the average age of pets in a shelter:
CREATE FUNCTION dbo.PercentageAdoptedPetsInShelter(@shelterId INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @totalPets FLOAT;
    DECLARE @totalAdoptedPets FLOAT;
    SELECT @totalPets = COUNT(*) 
		FROM dbo.Pet 
		WHERE ShelterId = @shelterId;
    SELECT @totalAdoptedPets = COUNT(*) 
		FROM dbo.Pet 
		WHERE ShelterId = @shelterId AND EstadoDeAdocao = 1;
    RETURN (@totalAdoptedPets / @totalPets) * 100;
END;
GO


--A function to get the most common pet breed in a shelter:
CREATE FUNCTION dbo.MostCommonPetBreedInShelter(@shelterId INT)
RETURNS VARCHAR(255)
AS
BEGIN
    DECLARE @mostCommonBreed VARCHAR(255);
    SELECT TOP 1 @mostCommonBreed = Raca 
		FROM (SELECT Raca FROM Dog WHERE dbo.ShelterId = @shelterId UNION ALL SELECT Raca FROM Cat WHERE ShelterId = @shelterId) AS PetRaca GROUP BY Raca ORDER BY COUNT(*) DESC;
    RETURN @mostCommonBreed;
END;
GO

--A function to get the number of pets adopted by an adopter in a specific year:
CREATE FUNCTION dbo.TotalAdoptionsByAdopterInYear(@ccAdotante VARCHAR(255), @year INT)
RETURNS INT
AS
BEGIN
    DECLARE @totalAdoptions INT;
    SELECT @totalAdoptions = COUNT(*) 
		FROM dbo.Adocoes 
		WHERE CCAdotante = @ccAdotante AND YEAR(DataAdocao) = @year;
    RETURN @totalAdoptions;
END;
GO

