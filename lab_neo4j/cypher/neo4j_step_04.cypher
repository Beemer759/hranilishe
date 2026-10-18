// Практические примеры: связи (создание, чтение, удаление)

// создание связи со свойством
MATCH (a:Person {name:"Алиса"}), (b:Person {name:"Боб"}) CREATE (a)-[:KNOWS {since: 2020}]->(b) RETURN a, b;

// создание обратной связи
MATCH (a:Person {name:"Алиса"}), (b:Person {name:"Боб"}) CREATE (b)-[:KNOWS {since: 2021}]->(a) RETURN a, b;

// чтение связей
MATCH (a:Person)-[r:KNOWS]->(b:Person) RETURN a.name AS от, b.name AS к, r.since AS с;

// удаление связей
MATCH (a:Person)-[r:KNOWS]->(b:Person) DELETE r;

// полная очистка перед построением социального графа
MATCH (n) DETACH DELETE n;
