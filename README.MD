# Festival Indie (SQL)

## Descrição
Banco de dados relacional para gerenciar um festival indie com bandas, shows e patrocinadores. Inclui tabelas, dados de exemplo e operações CRUD básicas.
Estrutura do banco

### Tabelas principais:
    Banda (id_banda, nome, genero, pais_origem)
    Shows (id_show, local, data_show, capacidade)
    Patrocinador (id_patrocinador, nome, tipo)
    Banda_Show (associação muitos-para-muitos: id_banda, id_show, ordem_apresentacao)

## Instalação / Uso
  1. Crie o banco e use-o:
  
  ```sql
  CREATE DATABASE IF NOT EXISTS festival_indie;
  USE festival_indie;
  ```
  2. Crie as tabelas:
  ```sql
  CREATE TABLE IF NOT EXISTS Banda (
    id_banda INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    genero VARCHAR(30),
    pais_origem VARCHAR(30)
  );

  CREATE TABLE IF NOT EXISTS Shows (
      id_show INT AUTO_INCREMENT PRIMARY KEY,
      local VARCHAR(100) NOT NULL,
      data_show DATE NOT NULL,
      capacidade INT
  );

  CREATE TABLE IF NOT EXISTS Patrocinador (
      id_patrocinador INT AUTO_INCREMENT PRIMARY KEY,
      nome VARCHAR(50) NOT NULL,
      tipo VARCHAR(30)
  );

  CREATE TABLE IF NOT EXISTS Banda_Show (
      id_banda INT,
      id_show INT,
      ordem_apresentacao INT,
      PRIMARY KEY (id_banda, id_show),
      FOREIGN KEY (id_banda) REFERENCES Banda(id_banda) ON DELETE CASCADE,
      FOREIGN KEY (id_show) REFERENCES Shows(id_show) ON DELETE CASCADE
  );
  ```

  ## Dados de exemplo
Insira conjuntos fictícios já fornecidos (bandas, shows, patrocinadores e relações). Exemplo de inserção de bandas:
```sql
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
```
(Insira também os exemplos de Shows, Patrocinador e Banda_Show conforme o script original.)

## Exemplos de CRUD

1. CREATE
```sql
INSERT INTO Banda (nome, genero, pais_origem) VALUES ('Blue Horizon', 'Indie Rock', 'EUA');
INSERT INTO Shows (local, data_show, capacidade) VALUES ('Festival das Estrelas - RJ', '2025-12-22', 4000);
INSERT INTO Banda_Show (id_banda, id_show, ordem_apresentacao) VALUES (11, 11, 1);
```

2. READ
```sql
-- Todas as bandas com país
SELECT nome, pais_origem FROM Banda;

-- Shows com bandas escaladas
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
```

3. UPDATE
```sql
UPDATE Shows
SET capacidade = 5500
WHERE local = 'Parque das Estrelas - SP';
```

4. DELETE
```sql
-- Remover participações e banda
DELETE FROM Banda_Show WHERE id_banda = 3;
DELETE FROM Banda WHERE id_banda = 3;

-- Remover tabelas (cuidado: apaga tudo)
DROP TABLE Banda, Banda_Show, Patrocinador, Shows;
```

## Boas práticas e notas
  Use transações ao inserir múltiplas linhas dependentes (START TRANSACTION; ... COMMIT;) para garantir integridade.
  Índices: o PK basta para tabelas pequenas, mas considere índices em Shows(data_show) e Banda(nome) para consultas frequentes.
  Validação: aplicar restrições adicionais (NOT NULL, CHECK, UNIQUE) conforme regras de negócio reais.
  Remoção em cascata: a FK com ON DELETE CASCADE elimina relações automaticamente ao remover Banda ou Show.
  Datas: armazene em DATE ou DATETIME conforme necessidade de horário; usar timezone na aplicação.

## Exemplos de consultas avançadas
  Próximos shows com capacidade disponível (ex.: comparar capacidade com vendas — seria necessário tabela de ingressos/vendas).
  Agenda de uma banda (todos os shows de uma banda):

  ```sql
  SELECT S.local, S.data_show, BS.ordem_apresentacao
  FROM Banda_Show BS
  JOIN Shows S ON BS.id_show = S.id_show
  WHERE BS.id_banda = 1
  ORDER BY S.data_show;
  ```

  Caso queira uma "aulinha" melhor sobre sql veja [AQUI!](./Aulinha.md)





