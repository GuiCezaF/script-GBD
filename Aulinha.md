# Conceitos de banco de dados relacionais (aplicado ao "festival_indie")

## Entidades e relações (modelo relacional)
  - ``Tabela`` = coleção de registros (linhas) que representam uma entidade do mundo real.
      - Banda: armazena informações sobre cada banda (id_banda, nome, genero, pais_origem).
      - Shows: armazena cada evento (id_show, local, data_show, capacidade).
      - Patrocinador: armazena patrocinadores.
      - ``Banda_Show``: tabela de associação (tabela de junção) que liga Banda e Shows para modelar a relação muitos-para-muitos e guarda atributo adicional (ordem_apresentacao).
  - ``Chave primária`` (PRIMARY KEY): identifica unicamente cada linha (ex.: id_banda).
  -`` Chave estrangeira`` (FOREIGN KEY): referência para outra tabela (ex.: Banda_Show.id_banda → Banda.id_banda). Ajuda a garantir integridade referencial (não criar relação para uma banda inexistente).

## Por que usar uma tabela de associação (muitos-para-muitos)?

  Uma banda pode tocar em vários shows e um show recebe várias bandas. Relacionamento N:N não cabe em apenas duas tabelas sem redundância. A solução: criar Banda_Show que liga as duas e permite armazenar atributos desse vínculo (ex.: ordem_apresentacao).

## Operações CRUD (contexto)

  - ``CREATE``: inserir registros (INSERT INTO).
  - ``READ``: consultar dados (SELECT).
  - ``UPDATE``: alterar registros (UPDATE).
  - ``DELETE``: remover registros (DELETE).

## JOINs — conceito
JOIN é a operação que combina linhas de duas (ou mais) tabelas com base em uma condição de correspondência (normalmente igualdade entre chaves). JOINs permitem “ampliar” os dados trazendo colunas relacionadas.

Principais tipos com explicação, semântica e exemplo aplicado:

  ### INNER JOIN (ou apenas JOIN)

  - Semântica: retorna só as linhas que têm correspondência em ambas as tabelas.
  - Quando usar: quero só pares Banda–Show que existem na associação.
  - Exemplo: SELECT S.local, S.data_show, B.nome AS Banda, BS.ordem_apresentacao FROM Banda_Show BS JOIN Banda B ON BS.id_banda = B.id_banda JOIN Shows S ON BS.id_show = S.id_show; — Resultado: somente shows que têm bandas relacionadas (linhas da Banda_Show).

  ### LEFT JOIN (LEFT OUTER JOIN)

  - Semântica: retorna todas as linhas da tabela à esquerda; preenche com NULL as colunas da tabela à direita quando não há correspondência.
  - Quando usar: quero todos os shows, mesmo os que ainda não têm bandas escaladas.
  - Exemplo: SELECT S.local, S.data_show, B.nome FROM Shows S LEFT JOIN Banda_Show BS ON S.id_show = BS.id_show LEFT JOIN Banda B ON BS.id_banda = B.id_banda; — Resultado: shows sem bandas aparecem com Banda = NULL.

  ### RIGHT JOIN (RIGHT OUTER JOIN)

  - Semântica: espelho do LEFT JOIN — todas as linhas da tabela à direita, mesmo sem correspondência à esquerda.
  - Observação: nem todos os SGBDs o preferem; pode ser reescrito invertendo ordem e usando LEFT JOIN.
  - Exemplo (equivalente a LEFT JOIN invertendo ordem): SELECT B.nome, S.local FROM Banda B RIGHT JOIN Banda_Show BS ON B.id_banda = BS.id_banda RIGHT JOIN Shows S ON BS.id_show = S.id_show; — Raramente necessário; prefira LEFT JOIN por clareza.

  ## FULL OUTER JOIN

  - Semântica: retorna todas as linhas de ambas as tabelas; onde não há correspondência, preenche com NULL.
  - Nem todos os SGBDs (MySQL até versões antigas) suportam diretamente; pode-se simular com UNION de LEFT e RIGHT.
  - Uso: comparar duas fontes e querer tudo de ambas.

  ### CROSS JOIN

  - Semântica: produto cartesiano — todas as combinações possíveis entre linhas das duas tabelas.
  - Cuidado: cresce rapidamente; raramente útil sem filtro.
  - Exemplo: gerar todas as combinações Banda × Show (útil para gerar possibilidades antes de filtrar).

## Condições de junção vs. filtros (ON vs WHERE)
  ``ON`` define como as tabelas se conectam`` (ex.: ON BS.id_banda = B.id_banda)``.
  ``WHERE`` filtra o resultado final`` (ex.: WHERE S.data_show > '2025-11-20')``.
  ``Atenção``: com OUTER JOIN, mover condições para WHERE pode transformar o JOIN em comportamento semelhante a INNER JOIN (porque WHERE que exige colunas da tabela “externa” não-nulas remove linhas sem correspondência).

### Exemplo prático que mostra a diferença:

  Quero todos os shows e apenas bandas de um gênero específico:

  ```sql
    SELECT
      S.local,
      B.nome
    FROM Shows S
    LEFT JOIN Banda_Show BS ON S.id_show = BS.id_show
    LEFT JOIN Banda B ON BS.id_banda = B.id_banda 
      AND B.genero = 'Indie Rock';
  ```
  — Aqui o filtro de gênero fica no ON para preservar shows sem bandas desse gênero (aparecerão com NULL). Se eu colocasse AND B.genero = 'Indie Rock' no WHERE, shows sem bandas seriam removidos.

## Agregações com JOINs
  Pode combinar JOIN com GROUP BY para contar ou agregar exemplo.: quantidade de bandas por show
  ```sql
  SELECT
    S.local, COUNT(BS.id_banda) AS qtd_bandas
  FROM Shows S
  LEFT JOIN Banda_Show BS ON S.id_show = BS.id_show
  GROUP BY S.local
  ORDER BY qtd_bandas DESC;
  ```
  Nota: COUNT(coluna) conta valores não-NULL; usar COUNT(*) conta linhas (para LEFT JOIN, COUNT(BS.id_banda) = 0 quando não há correspondência).

## Boas práticas e performance
  - Use índices nas colunas de junção (id_banda, id_show) para acelerar JOINs.
  - Evite SELECT * em consultas grandes; traga só as colunas necessárias.
  - Para tabelas de associação com muitos registros, pense em particionamento ou filtros por data para consultas em tempo.
  - Cuidado com joins em cascata (muitas tabelas) — mantenha a lógica simples.
