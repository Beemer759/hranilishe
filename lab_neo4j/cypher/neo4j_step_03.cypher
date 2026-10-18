// Практические примеры: изменение и удаление узлов (SET, REMOVE, DELETE)

// SET — добавить свойство
MATCH (p:Person {name: "Боб"}) SET p.city = "Москва" RETURN p;

// SET — изменить свойство
MATCH (p:Person {name: "Кэрол"}) SET p.age = p.age + 1 RETURN p.name, p.age;

// REMOVE — удалить свойство
MATCH (p:Person {name: "Боб"}) REMOVE p.city RETURN p;

// DELETE — удалить узел
MATCH (p:Person {name: "Кэрол"}) DELETE p;

// проверка результата
MATCH (p:Person) RETURN count(p) AS осталось_персон;
