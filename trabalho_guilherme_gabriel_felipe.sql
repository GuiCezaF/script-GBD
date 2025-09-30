-- Integrantes: Guilherme Felipe, Gabriel Eduardo, Felipe Zamariolli

-- 1. Criar banco de dados
CREATE DATABASE IF NOT EXISTS festival_indie;
USE festival_indie;

-- 2. Criar tabelas

-- Tabela de bandas
CREATE TABLE IF NOT EXISTS Banda (
    id_banda INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    genero VARCHAR(30),
    pais_origem VARCHAR(30)
);

-- Tabela de shows
CREATE TABLE IF NOT EXISTS Shows (
    id_show INT AUTO_INCREMENT PRIMARY KEY,
    local VARCHAR(100) NOT NULL,
    data_show DATE NOT NULL,
    capacidade INT
);

-- Tabela de patrocinadores
CREATE TABLE IF NOT EXISTS Patrocinador (
    id_patrocinador INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    tipo VARCHAR(30)
);

-- Tabela de associação Banda ↔ Shows (muitos-para-muitos)
CREATE TABLE IF NOT EXISTS Banda_Show (
    id_banda INT,
    id_show INT,
    ordem_apresentacao INT,
    PRIMARY KEY (id_banda, id_show),
    FOREIGN KEY (id_banda) REFERENCES Banda(id_banda) ON DELETE CASCADE,
    FOREIGN KEY (id_show) REFERENCES Shows(id_show) ON DELETE CASCADE
);

-- 3. Inserir dados fictícios

-- Bandas
INSERT INTO Banda (nome, genero, pais_origem) VALUES
('Aurora Skies', 'Dream Pop', 'Noruega'),
('Velvet Echoes', 'Indie Rock', 'Brasil'),
('Silver Pines', 'Folk', 'EUA'),
('Moonlight Drive', 'Shoegaze', 'Japão'),
('Wild Lanterns', 'Synthpop', 'Alemanha'),
('Golden Roots', 'Country Indie', 'Canadá'),
('Crystal Birds', 'Indie Pop', 'Reino Unido'),
('Paper Waves', 'Lo-fi', 'Austrália'),
('Dark Bloom', 'Post-Punk', 'França'),
('Electric Horizon', 'Electro Indie', 'Suécia');

-- Shows
INSERT INTO Shows (local, data_show, capacidade) VALUES
('Parque das Estrelas - SP', '2025-11-15', 5000),
('Arena Aurora - RJ', '2025-11-20', 7000),
('Teatro Indie - BH', '2025-11-25', 3000),
('Praia do Som - FLN', '2025-11-28', 4500),
('Lagoa Festival - POA', '2025-12-01', 6000),
('Sky Dome - NY', '2025-12-05', 8000),
('Sunset Stage - LA', '2025-12-10', 7500),
('Berlin Open Air', '2025-12-12', 6500),
('Tokyo Dream Fest', '2025-12-15', 9000),
('London Indie Night', '2025-12-18', 8500);

-- Patrocinadores
INSERT INTO Patrocinador (nome, tipo) VALUES
('Galaxy Sound', 'Áudio'),
('Beat Energy', 'Bebida'),
('Urban Wear', 'Moda'),
('Wave Tech', 'Tecnologia'),
('Echo Records', 'Gravadora'),
('Sky Drinks', 'Bebida'),
('Planet Stage', 'Produção'),
('Indie World', 'Mídia'),
('Moon Lights', 'Iluminação'),
('Rhythm Travel', 'Turismo');

-- Relação Banda ↔ Shows
INSERT INTO Banda_Show (id_banda, id_show, ordem_apresentacao) VALUES
(1,1,1),(1,2,1),(2,1,2),(3,2,1),(4,2,2),
(5,3,1),(6,3,2),(7,4,1),(8,4,2),
(9,5,1),(10,5,2),(1,6,1),(4,6,2),
(2,7,1),(8,7,2),(3,8,1),(7,8,2),
(5,9,1),(9,9,2),(6,10,1),(10,10,2);

-- 4. Exemplos de CRUD

-- --- CREATE ---
-- Inserir nova banda
INSERT INTO Banda (nome, genero, pais_origem) VALUES ('Blue Horizon', 'Indie Rock', 'EUA');

-- Inserir novo show
INSERT INTO Shows (local, data_show, capacidade) VALUES ('Festival das Estrelas - RJ', '2025-12-22', 4000);

-- Relacionar banda e show
INSERT INTO Banda_Show (id_banda, id_show, ordem_apresentacao) VALUES (11, 11, 1);

-- --- READ ---
-- Listar todas as bandas com seus países
SELECT nome, pais_origem FROM Banda;

-- Listar todos os shows com bandas escaladas
SELECT S.local, S.data_show, B.nome AS Banda, BS.ordem_apresentacao
FROM Banda_Show BS
JOIN Banda B ON BS.id_banda = B.id_banda
JOIN Shows S ON BS.id_show = S.id_show
ORDER BY S.data_show, BS.ordem_apresentacao;

-- Quantidade de bandas por show
SELECT S.local, COUNT(BS.id_banda) AS qtd_bandas
FROM Shows S
LEFT JOIN Banda_Show BS ON S.id_show = BS.id_show
GROUP BY S.local
ORDER BY qtd_bandas DESC;

-- --- UPDATE ---
-- Alterar a capacidade de um show
UPDATE Shows
SET capacidade = 5500
WHERE local = 'Parque das Estrelas - SP';

-- --- DELETE ---
-- Remover uma banda e suas participações
DELETE FROM Banda_Show WHERE id_banda = 3;
DELETE FROM Banda WHERE id_banda = 3;

-- Bonus deletar tabelas
DROP TABLE Banda, Banda_Show, Patrocinador, Shows;
