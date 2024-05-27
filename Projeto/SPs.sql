use p10g2

go

--SPs

CREATE PROCEDURE sp_UpdateHealthStatus @petId INT
AS
BEGIN
    DECLARE @vaccinationStatus BIT;
    DECLARE @treatmentStatus BIT;

    -- Check if the pet has received all its vaccinations
    SELECT @vaccinationStatus = CASE WHEN PrimeiraDose = 1 AND SegundaDose = 1 THEN 1 ELSE 0 END
    FROM dbo.Vacinas
    WHERE IdPet_Pet = @petId;

    -- Check if the pet has received all its treatments
    SELECT @treatmentStatus = CASE WHEN Desparasitado = 1 AND Esterilizado = 1 AND CuidadoDentario = 1 THEN 1 ELSE 0 END
    FROM dbo.Tratamentos
    WHERE IdPet_Pet_Pet = @petId;

    -- If the pet has received all its vaccinations and treatments, update its health status
    IF @vaccinationStatus = 1 AND @treatmentStatus = 1
    BEGIN
        UPDATE Pet
        SET Healthy = 1
        WHERE Id = @petId;
    END
END;
GO

--EXEC sp_UpdateHealthStatus @petId = 1;