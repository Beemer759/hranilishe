// Анализ социального графа

// число узлов-персонажей
MATCH (p:Person) RETURN count(p) AS персонажей;

// число связей
MATCH ()-[r]->() RETURN count(r) AS связей;

// степень узлов (топ-10)
MATCH (p:Person)-[r]-() RETURN p.name AS персонаж, count(r) AS степень ORDER BY степень DESC LIMIT 10;

// друзья Бориса
MATCH (a:Person {name:"Борис Крамер"})-[:FRIEND]-(f:Person) RETURN f.name AS друг;

// конфликты
MATCH (a:Person)-[:ENEMY]->(b:Person) RETURN a.name AS кто, b.name AS против_кого;

// состав групп
MATCH (p:Person)-[:MEMBER_OF]->(g:Group) RETURN g.name AS группа, collect(p.name) AS участники;

// романтические связи
MATCH (p:Person)-[:LOVES]->(q:Person) RETURN p.name AS влюблён, q.name AS в_кого;

// кратчайший путь между персонажами
MATCH path = shortestPath((a:Person {name:"Анна Соколова"})-[*]-(b:Person {name:"Дина Орлова"})) RETURN [n IN nodes(path) | n.name] AS путь, length(path) AS длина;

// персонажи старше 40 лет
MATCH (p:Person) WHERE p.age >= 40 RETURN p.name AS имя, p.role AS роль, p.age AS возраст ORDER BY p.age DESC;
