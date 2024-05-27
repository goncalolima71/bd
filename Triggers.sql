use p10g2

go

----------------------------Triggers---------------------------------


-- Trigger to check and update vaccination and treatment records when a pet is adopted
CREATE TRIGGER trg_UpdateRecordsOnAdoption
ON Pet
AFTER UPDATE
AS
BEGIN
    IF NEW.EstadoAdocaoPet = 1
        -- Update vaccination records
		BEGIN
        UPDATE Vacinas
        SET PrimeiraDose = 1, SegundaDose = 1
        WHERE IdPet_Pet = NEW.Id

        -- Update treatment records
        UPDATE Tratamentos
        SET Desparasitado = 1, Esterilizado = 1, CuidadoDentario = 1
        WHERE IdPet_Pet_Pet = NEW.Id
		
		END
	END
GO

-- Trigger to create entries in Vacinas and Tratamentos tables when a new pet is added
CREATE TRIGGER trg_CreateRecordsOnNewPet
ON Pet
AFTER INSERT
AS
BEGIN
    -- Create vaccination record
    INSERT INTO Vacinas (IdPet_Pet, PrimeiraDose, SegundaDose)
    VALUES (NEW.Id, 0, 0)

    -- Create treatment record
    INSERT INTO Tratamentos (IdPet_Pet_Pet, Desparasitado, Esterilizado, CuidadoDentario)
    VALUES (NEW.Id, 0, 0, 0)
END
GO

-- Trigger to update pet's adoption status when a new adoption is recorded
CREATE TRIGGER trg_UpdateAdoptionStatusOnNewAdoption
ON Adocoes
AFTER INSERT
AS
BEGIN
    -- Update pet's adoption status
    UPDATE Pet
    SET EstadoDeAdocao = 1
    WHERE Id = NEW.IdPet
END
GO

-- Trigger to create a corresponding entry in Adotante or Empregado table when a new user is added
CREATE TRIGGER trg_CreateRoleRecordOnNewUser
ON Utilizador
AFTER INSERT
AS
BEGIN
    -- Check user's role and create a corresponding entry
    IF NEW.Role = 'Adotante' 
        INSERT INTO Adotante (CC, Idade, Emprego, TermosDeResponsabilidade)
        VALUES (NEW.CC, NEW.Idade, NEW.Emprego, NEW.TermosDeResponsabilidade)
    IF NEW.Role = 'Empregado'
        INSERT INTO Empregado (CC, IddeTrabalho)
        VALUES (NEW.CC, NEW.IddeTrabalho)

END
GO

-- Trigger to add pet's details to Pet table when a new pet is added to Dog or Cat table
CREATE TRIGGER trg_AddPetDetailsOnNewDog
ON Dog
AFTER INSERT
AS
BEGIN
    -- Add pet's details to Pet table
    INSERT INTO Pet (Id, EstadoDeAdocao, Microchip, Comportamento, ShelterId)
    VALUES (NEW.IdDog, NEW.EstadoDeAdocaoDog, 0, NEW.Descricao, NEW.ShelterId)
END
GO


CREATE TRIGGER trg_AddPetDetailsOnNewCat
ON Cat
AFTER INSERT
AS
BEGIN
    -- Add pet's details to Pet table
    INSERT INTO Pet (Id, EstadoDeAdocao, Microchip, Comportamento, ShelterId)
    VALUES (NEW.IdCat, NEW.EstadoDeAdocaoCat, 0, NEW.Descricao, NEW.ShelterId)
END
GO

-- Trigger to update pet's adoption status in Pet table when it's updated in Dog or Cat table
CREATE TRIGGER trg_UpdateAdoptionStatusOnDogUpdate
ON Dog
AFTER UPDATE
AS
BEGIN
    -- Update pet's adoption status in Pet table
    UPDATE Pet
    SET EstadoDeAdocao = NEW.EstadoDeAdocaoDog
    WHERE Id = NEW.IdDog
END
GO

CREATE TRIGGER trg_UpdateAdoptionStatusOnCatUpdate
ON Cat
AFTER UPDATE
AS
BEGIN
    -- Update pet's adoption status in Pet table
    UPDATE Pet
    SET EstadoDeAdocao = NEW.EstadoDeAdocaoCat
    WHERE Id = NEW.IdCat
END
GO


CREATE TRIGGER trg_CheckPetAge
ON Pet
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @motherAge INT
    DECLARE @fatherAge INT
    DECLARE @errorMsg VARCHAR(100)
    DECLARE @newPetId INT
    DECLARE @newPetAge INT
    DECLARE @motherId INT
    DECLARE @fatherId INT

    -- Assuming only one row is inserted at a time
    SELECT @newPetId = Id, @newPetAge = Idade, @motherId = IdMae, @fatherId = IdPai
    FROM inserted

    -- Check age of mother
    IF @motherId IS NOT NULL
    BEGIN
        SELECT @motherAge = Idade FROM Pet WHERE Id = @motherId
        IF @newPetAge > @motherAge
        BEGIN
            SET @errorMsg = 'The pet cannot be older than its mother. Mother''s age: ' + CAST(@motherAge AS VARCHAR)
            RAISERROR (@errorMsg, 16, 1)
            RETURN
        END
    END

    -- Check age of father
    IF @fatherId IS NOT NULL
    BEGIN
        SELECT @fatherAge = Idade FROM Pet WHERE Id = @fatherId
        IF @newPetAge > @fatherAge
        BEGIN
            SET @errorMsg = 'The pet cannot be older than its father. Father''s age: ' + CAST(@fatherAge AS VARCHAR)
            RAISERROR (@errorMsg, 16, 1)
            RETURN
        END
    END

    -- If all checks pass, insert the new pet
    INSERT INTO Pet (Id, Idade, IdMae, IdPai)
    SELECT Id, Idade, IdMae, IdPai FROM inserted
END



