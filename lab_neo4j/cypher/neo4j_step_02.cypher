// Практические примеры: чтение данных (MATCH, WHERE, агрегаты)

// фильтр и сортировка
MATCH (p:Person) WHERE p.age > 26 RETURN p.name AS имя, p.age AS возраст ORDER BY p.age DESC;

// поиск по свойству
MATCH (p:Person {name: "Алиса"}) RETURN p;

// агрегация count
MATCH (p:Person) RETURN count(p) AS всего_персон;

// агрегации avg / max
MATCH (p:Person) RETURN avg(p.age) AS средний_возраст, max(p.age) AS максимум;
