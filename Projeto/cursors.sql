use p10g2

go


--Cursors
-- Cursor to fetch all animals ready for adoption
DECLARE cursor_ready_for_adoption CURSOR FOR 
SELECT * FROM dbo.Pet 
WHERE Healthy = 1 AND Adopted = 0;

-- Cursor to fetch all animals not ready for adoption
DECLARE cursor_not_ready_for_adoption CURSOR FOR 
SELECT * FROM dbo.Pet
WHERE Healthy = 0 OR Adopted = 1;

-- Cursor to fetch all animals that have been adopted
DECLARE cursor_adopted_animals CURSOR FOR 
SELECT * FROM dbo.Animals 
WHERE Adopted = 1;

-- Cursor to fetch all users who have adopted animals
DECLARE cursor_adopters CURSOR FOR 
SELECT * FROM dbo.Utilizador
WHERE CC IN (SELECT CC FROM Adocoes);