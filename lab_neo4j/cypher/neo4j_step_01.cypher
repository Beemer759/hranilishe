// Практические примеры: создание узлов (CREATE)

// очистка базы перед началом
MATCH (n) DETACH DELETE n;

// создание одного узла
CREATE (a:Person {name: "Алиса", age: 30}) RETURN a;

// создание двух узлов одним запросом
CREATE (b:Person {name: "Боб", age: 25}), (c:Person {name: "Кэрол", age: 28}) RETURN b, c;

// чтение всех узлов
MATCH (p:Person) RETURN p.name, p.age;
