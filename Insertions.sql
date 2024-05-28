use p10g2

go

INSERT INTO Utilizador VALUES ('marega@gmail.com', 'Moussa Marega da Silva',987654321, 'Bairro dos Tijolos', 122334466, 4)
INSERT INTO Utilizador VALUES ('maria@gmail.com', 'Maria Osvalda',925312946, 'Rua de Leiria', 251617294, 3)
INSERT INTO Utilizador VALUES ('joao@gmail.com', 'Joao Ratao',919209182, 'Rua de Portimao', 398098217, 2)
INSERT INTO Utilizador VALUES ('megatron@gmail.com', 'Megatron Fat Ass',923487039, 'Rua das Baleias', 382018972, 1)


-- Inserções para a tabela Shelter
INSERT INTO Shelter (Morada, Contacto, Email) VALUES
('Rua das Rosas, 15', 912345678, 'rosashelter@example.com'),
('Avenida dos Animais, 123', 987654321, 'animalavenue@example.com'),
('Beco dos Gatos, 4', 913246578, 'catcorner@example.com'),
('Rua dos Cães, 78', 934567890, 'dogstreet@example.com');

-- Inserções para a tabela Adotante
INSERT INTO Adotante (CC, Idade, Emprego, TermosDeResponsabilidade) VALUES
(122334466, 35, 'Engenheiro', 1),
(251617294, 29, 'Professora', 1),
(398098217, 40, 'Médico', 1);

-- Inserções para a tabela Empregado
INSERT INTO Empregado (CC, IddeTrabalho) VALUES
(382018972, 1),
(122334466, 2),
(251617294, 3);

-- Inserções para a tabela Pet
INSERT INTO Pet (EstadoDeAdocao, Microchip, Comportamento, ShelterId, IdMae, IdPai, Healthy) VALUES
(0, 1, 'Calmo', 1, NULL, NULL, 1),
(0, 0, 'Agitado', 2, NULL, NULL, 1),
(1, 1, 'Brincalhão', 3, NULL, NULL, 0),
(1, 0, 'Tímido', 4, NULL, NULL, 1);

-- Inserções para a tabela Dog
INSERT INTO Dog (IdDog, EstadoDeAdocaoDog, Descricao, Nome, Raca, Idade) VALUES
(1, 0, 'Cão de porte médio, muito brincalhão', 'Rex', 'Labrador', 3),
(2, 0, 'Cão pequeno, muito ativo', 'Toby', 'Beagle', 2);

-- Inserções para a tabela Cat
INSERT INTO Cat (IdCat, EstadoDeAdocaoCat, Descricao, Nome, Raca, Idade) VALUES
(3, 1, 'Gato de pelo longo, muito carinhoso', 'Mia', 'Persa', 4),
(4, 1, 'Gato de pelo curto, independente', 'Tom', 'Siamês', 5);

-- Inserções para a tabela Adocoes
INSERT INTO Adocoes (IdAdocao, TermosResponsabilidadeAdotante, CCAdotante, IdTrabalhoEmpregado, CCEmpregado, IdPet, EstadoAdocaoPet) VALUES
(1, 1, 122334466, 1, 382018972, 1, 1),
(2, 1, 251617294, 2, 122334466, 3, 1);

-- Inserções para a tabela Vacinas
INSERT INTO Vacinas (TipoVacina, PrimeiraDose, SegundaDose, IdPet_Pet, EstadoAdocaoPet_Pet) VALUES
('Gripe', 1, 0, 1, 0),
('Antirrabica', 1, 1, 2, 0),
('Giárdia', 1, 1, 3, 1),
('Leishmaniose', 0, 0, 4, 1);

-- Inserções para a tabela Tratamentos
INSERT INTO Tratamentos (IdPet_Pet_Pet, Desparasitado, Esterilizado, CuidadoDentario) VALUES
(1, 1, 1, 1),
(2, 1, 0, 0),
(3, 0, 1, 1),
(4, 1, 1, 0);


