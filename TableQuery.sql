DROP TABLE IF EXISTS Tratamento
DROP TABLE IF EXISTS Vacinas
DROP TABLE IF EXISTS Adocoes
DROP TABLE IF EXISTS Cat
DROP TABLE IF EXISTS Dog
DROP TABLE IF EXISTS Adotante
DROP TABLE IF EXISTS Empregado
DROP TABLE IF EXISTS Utilizador
DROP TABLE IF EXISTS Pet
DROP TABLE IF EXISTS Shelter

CREATE TABLE Shelter (
    Id INT IdENTITY(1,1) PRIMARY KEY,
    Morada VARCHAR(255),
    Contacto INT CHECK (Contacto >= 0 AND Contacto < 1000000000), --9 digitos de contacto
    Email VARCHAR(255)
);

CREATE TABLE Utilizador (
    Email VARCHAR(255),
    Nome VARCHAR(255),
    Contacto INT,
    Morada VARCHAR(255),
    CC VARCHAR(255) PRIMARY KEY,
    ShelterId INT,
    FOREIGN KEY (ShelterId) REFERENCES Shelter(Id)
);

CREATE TABLE Adotante (
    CC VARCHAR(255) PRIMARY KEY,
    Idade INT,
    Emprego VARCHAR(255),
    TermosDeResponsabilidade BIT,
    FOREIGN KEY (CC) REFERENCES Utilizador(CC)
);

CREATE TABLE Empregado (
    CC VARCHAR(255),
    IddeTrabalho INT PRIMARY KEY,
    FOREIGN KEY (CC) REFERENCES Utilizador(CC)
);

CREATE TABLE Pet (
    Id INT IDENTITY(1,1),
    EstadoDeAdocao BIT,
    Microchip BIT,
    Comportamento VARCHAR(255),
    ShelterId INT,
	IdMae INT,
	IdPai INT,
    Healthy BIT,
    FOREIGN KEY (ShelterId) REFERENCES Shelter(Id),
	PRIMARY KEY (Id),
	FOREIGN KEY (IdMae) REFERENCES Pet(Id),
	FOREIGN KEY (IdPai) REFERENCES Pet(Id),
);

CREATE TABLE Dog (
    IdDog INT,
	EstadoDeAdocaoDog BIT,
    Descricao VARCHAR(255),
    Nome VARCHAR(255),
    Raca VARCHAR(255),
    Idade INT,
	FOREIGN KEY (IdDog) REFERENCES Pet(Id),
	PRIMARY KEY (IdDog),
);

CREATE TABLE Cat (
    IdCat INT,
	EstadoDeAdocaoCat BIT,
    Descricao VARCHAR(255),
    Nome VARCHAR(255),
    Raca VARCHAR(255),
    Idade INT,
    FOREIGN KEY (IdCat) REFERENCES Pet(Id),
	PRIMARY KEY (IdCat),
);

CREATE TABLE Adocoes(
	IdAdocao INT PRIMARY KEY,
	TermosResponsabilidadeAdotante BIT,
	CCAdotante INT,
	IdTrabalhoEmpregado INT,
	CCEmpregado INT,
	IdPet INT,
	EstadoAdocaoPet BIT,
	FOREIGN KEY (IdPet) REFERENCES Pet(Id),
);

CREATE TABLE Vacinas(
	TipoVacina VARCHAR(255),
	CHECK(TipoVacina IN ('Gripe', 'Leishmaniose', 'Antirrabica', 'Gi�rdia')),
	PrimeiraDose BIT,
	SegundaDose Bit,
	IdPet_Pet INT,
	EstadoAdocaoPet_Pet BIT,
	FOREIGN KEY (IdPet_Pet) REFERENCES Pet(Id),
	PRIMARY KEY (IdPet_Pet),
);

CREATE TABLE Tratamentos(
	IdPet_Pet_Pet INT,
	Desparasitado BIT,
	Esterilizado BIT,
	CuidadoDentario BIT,
	FOREIGN KEY (IdPet_Pet_Pet) REFERENCES Pet(Id),
);



-- Triggers

-- Trigger to check and update vaccination and treatment records when a pet is adopted
CREATE TRIGGER trg_UpdateRecordsOnAdoption
AFTER UPDATE ON Pet
FOR EACH ROW
BEGIN
    IF NEW.EstadoAdocaoPet = 1 THEN
        -- Update vaccination records
        UPDATE Vacinas
        SET PrimeiraDose = 1, SegundaDose = 1
        WHERE IdPet_Pet = NEW.Id;

        -- Update treatment records
        UPDATE Tratamentos
        SET Desparasitado = 1, Esterilizado = 1, CuidadoDentario = 1
        WHERE IdPet_Pet_Pet = NEW.Id;
    END IF;
END;

-- Trigger to create entries in Vacinas and Tratamentos tables when a new pet is added
CREATE TRIGGER trg_CreateRecordsOnNewPet
AFTER INSERT ON Pet
FOR EACH ROW
BEGIN
    -- Create vaccination record
    INSERT INTO Vacinas (IdPet_Pet, PrimeiraDose, SegundaDose)
    VALUES (NEW.Id, 0, 0);

    -- Create treatment record
    INSERT INTO Tratamentos (IdPet_Pet_Pet, Desparasitado, Esterilizado, CuidadoDentario)
    VALUES (NEW.Id, 0, 0, 0);
END;

-- Trigger to update pet's adoption status when a new adoption is recorded
CREATE TRIGGER trg_UpdateAdoptionStatusOnNewAdoption
AFTER INSERT ON Adocoes
FOR EACH ROW
BEGIN
    -- Update pet's adoption status
    UPDATE Pet
    SET EstadoDeAdocao = 1
    WHERE Id = NEW.IdPet;
END;

-- Trigger to create a corresponding entry in Adotante or Empregado table when a new user is added
CREATE TRIGGER trg_CreateRoleRecordOnNewUser
AFTER INSERT ON Utilizador
FOR EACH ROW
BEGIN
    -- Check user's role and create a corresponding entry
    IF NEW.Role = 'Adotante' THEN
        INSERT INTO Adotante (CC, Idade, Emprego, TermosDeResponsabilidade)
        VALUES (NEW.CC, NEW.Idade, NEW.Emprego, NEW.TermosDeResponsabilidade);
    ELSEIF NEW.Role = 'Empregado' THEN
        INSERT INTO Empregado (CC, IddeTrabalho)
        VALUES (NEW.CC, NEW.IddeTrabalho);
    END IF;
END;



-- Trigger to add pet's details to Pet table when a new pet is added to Dog or Cat table
CREATE TRIGGER trg_AddPetDetailsOnNewDog
AFTER INSERT ON Dog
FOR EACH ROW
BEGIN
    -- Add pet's details to Pet table
    INSERT INTO Pet (Id, EstadoDeAdocao, Microchip, Comportamento, ShelterId)
    VALUES (NEW.IdDog, NEW.EstadoDeAdocaoDog, 0, NEW.Descricao, NEW.ShelterId);
END;

CREATE TRIGGER trg_AddPetDetailsOnNewCat
AFTER INSERT ON Cat
FOR EACH ROW
BEGIN
    -- Add pet's details to Pet table
    INSERT INTO Pet (Id, EstadoDeAdocao, Microchip, Comportamento, ShelterId)
    VALUES (NEW.IdCat, NEW.EstadoDeAdocaoCat, 0, NEW.Descricao, NEW.ShelterId);
END;

-- Trigger to update pet's adoption status in Pet table when it's updated in Dog or Cat table
CREATE TRIGGER trg_UpdateAdoptionStatusOnDogUpdate
AFTER UPDATE ON Dog
FOR EACH ROW
BEGIN
    -- Update pet's adoption status in Pet table
    UPDATE Pet
    SET EstadoDeAdocao = NEW.EstadoDeAdocaoDog
    WHERE Id = NEW.IdDog;
END;

CREATE TRIGGER trg_UpdateAdoptionStatusOnCatUpdate
AFTER UPDATE ON Cat
FOR EACH ROW
BEGIN
    -- Update pet's adoption status in Pet table
    UPDATE Pet
    SET EstadoDeAdocao = NEW.EstadoDeAdocaoCat
    WHERE Id = NEW.IdCat;
END;


CREATE TRIGGER trg_CheckPetAge
BEFORE INSERT OR UPDATE ON Pet
FOR EACH ROW
BEGIN
    DECLARE parentAge INT;
    DECLARE errorMsg VARCHAR(100);

    -- Check age of mother
    SELECT Idade INTO parentAge FROM Pet WHERE Id = NEW.IdMae;
    IF NEW.Idade > parentAge THEN
        SET errorMsg = CONCAT('The pet cannot be older than its mother. Mothers age: ', parentAge);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errorMsg;
    END IF;

    -- Check age of father
    SELECT Idade INTO parentAge FROM Pet WHERE Id = NEW.IdPai;
    IF NEW.Idade > parentAge THEN
        SET errorMsg = CONCAT('The pet cannot be older than its father. Fathers age: ', parentAge);
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = errorMsg;
    END IF;
END;



--UDFs

--A function to get the total number of pets in a shelter:
CREATE FUNCTION fn_TotalPetsInShelter(@shelterId INT)
RETURNS INT
AS
BEGIN
    DECLARE @totalPets INT;
    SELECT @totalPets = COUNT(*) FROM Pet WHERE ShelterId = @shelterId;
    RETURN @totalPets;
END;

--A function to get the total number of adopted pets in a shelter:
CREATE FUNCTION fn_TotalAdoptedPetsInShelter(@shelterId INT)
RETURNS INT
AS
BEGIN
    DECLARE @totalAdoptedPets INT;
    SELECT @totalAdoptedPets = COUNT(*) FROM Pet WHERE ShelterId = @shelterId AND EstadoDeAdocao = 1;
    RETURN @totalAdoptedPets;
END;

--A function to get the total number of employees in a shelter:
CREATE FUNCTION fn_TotalEmployeesInShelter(@shelterId INT)
RETURNS INT
AS
BEGIN
    DECLARE @totalEmployees INT;
    SELECT @totalEmployees = COUNT(*) FROM Empregado WHERE CC IN (SELECT CC FROM Utilizador WHERE ShelterId = @shelterId);
    RETURN @totalEmployees;
END;

--A function to get the total number of adoptions made by an adopter:
CREATE FUNCTION fn_TotalAdoptionsByAdopter(@ccAdotante VARCHAR(255))
RETURNS INT
AS
BEGIN
    DECLARE @totalAdoptions INT;
    SELECT @totalAdoptions = COUNT(*) FROM Adocoes WHERE CCAdotante = @ccAdotante;
    RETURN @totalAdoptions;
END;


--A function to get the average age of pets in a shelter:
CREATE FUNCTION fn_TotalAdoptionsByAdopter(@ccAdotante VARCHAR(255))
RETURNS INT
AS
BEGIN
    DECLARE @totalAdoptions INT;
    SELECT @totalAdoptions = COUNT(*) FROM Adocoes WHERE CCAdotante = @ccAdotante;
    RETURN @totalAdoptions;
END;

--A function to get the average age of pets in a shelter:
CREATE FUNCTION fn_PercentageAdoptedPetsInShelter(@shelterId INT)
RETURNS FLOAT
AS
BEGIN
    DECLARE @totalPets FLOAT;
    DECLARE @totalAdoptedPets FLOAT;
    SELECT @totalPets = COUNT(*) FROM Pet WHERE ShelterId = @shelterId;
    SELECT @totalAdoptedPets = COUNT(*) FROM Pet WHERE ShelterId = @shelterId AND EstadoDeAdocao = 1;
    RETURN (@totalAdoptedPets / @totalPets) * 100;
END;


--A function to get the most common pet breed in a shelter:
CREATE FUNCTION fn_MostCommonPetBreedInShelter(@shelterId INT)
RETURNS VARCHAR(255)
AS
BEGIN
    DECLARE @mostCommonBreed VARCHAR(255);
    SELECT TOP 1 @mostCommonBreed = Raca FROM (SELECT Raca FROM Dog WHERE ShelterId = @shelterId UNION ALL SELECT Raca FROM Cat WHERE ShelterId = @shelterId) AS PetRaca GROUP BY Raca ORDER BY COUNT(*) DESC;
    RETURN @mostCommonBreed;
END;

--A function to get the number of pets adopted by an adopter in a specific year:
CREATE FUNCTION fn_TotalAdoptionsByAdopterInYear(@ccAdotante VARCHAR(255), @year INT)
RETURNS INT
AS
BEGIN
    DECLARE @totalAdoptions INT;
    SELECT @totalAdoptions = COUNT(*) FROM Adocoes WHERE CCAdotante = @ccAdotante AND YEAR(DataAdocao) = @year;
    RETURN @totalAdoptions;
END;



--SPs

CREATE PROCEDURE sp_UpdateHealthStatus @petId INT
AS
BEGIN
    DECLARE @vaccinationStatus BIT;
    DECLARE @treatmentStatus BIT;

    -- Check if the pet has received all its vaccinations
    SELECT @vaccinationStatus = CASE WHEN PrimeiraDose = 1 AND SegundaDose = 1 THEN 1 ELSE 0 END
    FROM Vacinas
    WHERE IdPet_Pet = @petId;

    -- Check if the pet has received all its treatments
    SELECT @treatmentStatus = CASE WHEN Desparasitado = 1 AND Esterilizado = 1 AND CuidadoDentario = 1 THEN 1 ELSE 0 END
    FROM Tratamentos
    WHERE IdPet_Pet_Pet = @petId;

    -- If the pet has received all its vaccinations and treatments, update its health status
    IF @vaccinationStatus = 1 AND @treatmentStatus = 1
    BEGIN
        UPDATE Pet
        SET Healthy = 1
        WHERE Id = @petId;
    END
END;

--EXEC sp_UpdateHealthStatus @petId = 1;


--Cursors
-- Cursor to fetch all animals ready for adoption
DECLARE cursor_ready_for_adoption CURSOR FOR 
SELECT * FROM Pet 
WHERE Healthy = 1 AND Adopted = 0;

-- Cursor to fetch all animals not ready for adoption
DECLARE cursor_not_ready_for_adoption CURSOR FOR 
SELECT * FROM Pet
WHERE Healthy = 0 OR Adopted = 1;

-- Cursor to fetch all animals that have been adopted
DECLARE cursor_adopted_animals CURSOR FOR 
SELECT * FROM Animals 
WHERE Adopted = 1;

-- Cursor to fetch all users who have adopted animals
DECLARE cursor_adopters CURSOR FOR 
SELECT * FROM Utilizador
WHERE CC IN (SELECT CC FROM Adocoes);