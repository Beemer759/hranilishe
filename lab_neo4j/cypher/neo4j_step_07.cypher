// Социальный граф: связи между персонажами

// очистка связей
MATCH (n:Person)-[r]-() DELETE r;

//   FAMILY: Борис Крамер -> Вера Крамер
MATCH (a {name:"Борис Крамер"}), (b {name:"Вера Крамер"}) CREATE (a)-[:FAMILY {relation: "супруги"}]->(b);

//   FAMILY: Марк Волков -> Ирина Волкова
MATCH (a {name:"Марк Волков"}), (b {name:"Ирина Волкова"}) CREATE (a)-[:FAMILY {relation: "брат и сестра"}]->(b);

//   FAMILY: Глеб Орлов -> Дина Орлова
MATCH (a {name:"Глеб Орлов"}), (b {name:"Дина Орлова"}) CREATE (a)-[:FAMILY {relation: "брат и сестра"}]->(b);

//   FAMILY: Егор Морозов -> Лидия Морозова
MATCH (a {name:"Егор Морозов"}), (b {name:"Лидия Морозова"}) CREATE (a)-[:FAMILY {relation: "супруги"}]->(b);

//   FRIEND: Анна Соколова -> Борис Крамер
MATCH (a {name:"Анна Соколова"}), (b {name:"Борис Крамер"}) CREATE (a)-[:FRIEND {since: 2015}]->(b);

//   FRIEND: Анна Соколова -> Захар Титов
MATCH (a {name:"Анна Соколова"}), (b {name:"Захар Титов"}) CREATE (a)-[:FRIEND {since: 2018}]->(b);

//   FRIEND: Глеб Орлов -> Захар Титов
MATCH (a {name:"Глеб Орлов"}), (b {name:"Захар Титов"}) CREATE (a)-[:FRIEND {since: 2019}]->(b);

//   FRIEND: Кирилл Попов -> Борис Крамер
MATCH (a {name:"Кирилл Попов"}), (b {name:"Борис Крамер"}) CREATE (a)-[:FRIEND {since: 2010}]->(b);

//   FRIEND: Дина Орлова -> Ирина Волкова
MATCH (a {name:"Дина Орлова"}), (b {name:"Ирина Волкова"}) CREATE (a)-[:FRIEND {since: 2021}]->(b);

//   FRIEND: Вера Крамер -> Ирина Волкова
MATCH (a {name:"Вера Крамер"}), (b {name:"Ирина Волкова"}) CREATE (a)-[:FRIEND {since: 2016}]->(b);

//   ENEMY: Егор Морозов -> Борис Крамер
MATCH (a {name:"Егор Морозов"}), (b {name:"Борис Крамер"}) CREATE (a)-[:ENEMY {reason: "старое дело"}]->(b);

//   ENEMY: Егор Морозов -> Анна Соколова
MATCH (a {name:"Егор Морозов"}), (b {name:"Анна Соколова"}) CREATE (a)-[:ENEMY {reason: "публикация"}]->(b);

//   ENEMY: Жанна Лебедева -> Анна Соколова
MATCH (a {name:"Жанна Лебедева"}), (b {name:"Анна Соколова"}) CREATE (a)-[:ENEMY {reason: "скандал"}]->(b);

//   LOVES: Марк Волков -> Дина Орлова
MATCH (a {name:"Марк Волков"}), (b {name:"Дина Орлова"}) CREATE (a)-[:LOVES {since: 2022}]->(b);

//   LOVES: Захар Титов -> Ирина Волкова
MATCH (a {name:"Захар Титов"}), (b {name:"Ирина Волкова"}) CREATE (a)-[:LOVES {since: 2020}]->(b);

//   LOVES: Кирилл Попов -> Дина Орлова
MATCH (a {name:"Кирилл Попов"}), (b {name:"Дина Орлова"}) CREATE (a)-[:LOVES {since: 2023}]->(b);

//   COLLEAGUE: Борис Крамер -> Кирилл Попов
MATCH (a {name:"Борис Крамер"}), (b {name:"Кирилл Попов"}) CREATE (a)-[:COLLEAGUE {place: "отдел полиции"}]->(b);

//   COLLEAGUE: Жанна Лебедева -> Егор Морозов
MATCH (a {name:"Жанна Лебедева"}), (b {name:"Егор Морозов"}) CREATE (a)-[:COLLEAGUE {place: "фирма Морозова"}]->(b);

//   COLLEAGUE: Захар Титов -> Марк Волков
MATCH (a {name:"Захар Титов"}), (b {name:"Марк Волков"}) CREATE (a)-[:COLLEAGUE {place: "клуб «Полночь»"}]->(b);

//   COLLEAGUE: Борис Крамер -> Жанна Лебедева
MATCH (a {name:"Борис Крамер"}), (b {name:"Жанна Лебедева"}) CREATE (a)-[:COLLEAGUE {place: "городской суд"}]->(b);

//   KNOWS: Анна Соколова -> Глеб Орлов
MATCH (a {name:"Анна Соколова"}), (b {name:"Глеб Орлов"}) CREATE (a)-[:KNOWS]->(b);

//   KNOWS: Анна Соколова -> Жанна Лебедева
MATCH (a {name:"Анна Соколова"}), (b {name:"Жанна Лебедева"}) CREATE (a)-[:KNOWS]->(b);

//   KNOWS: Борис Крамер -> Захар Титов
MATCH (a {name:"Борис Крамер"}), (b {name:"Захар Титов"}) CREATE (a)-[:KNOWS]->(b);

//   KNOWS: Глеб Орлов -> Кирилл Попов
MATCH (a {name:"Глеб Орлов"}), (b {name:"Кирилл Попов"}) CREATE (a)-[:KNOWS]->(b);

//   KNOWS: Егор Морозов -> Лидия Морозова
MATCH (a {name:"Егор Морозов"}), (b {name:"Лидия Морозова"}) CREATE (a)-[:KNOWS]->(b);

//   KNOWS: Ирина Волкова -> Анна Соколова
MATCH (a {name:"Ирина Волкова"}), (b {name:"Анна Соколова"}) CREATE (a)-[:KNOWS]->(b);

//   KNOWS: Марк Волков -> Анна Соколова
MATCH (a {name:"Марк Волков"}), (b {name:"Анна Соколова"}) CREATE (a)-[:KNOWS]->(b);

//   KNOWS: Вера Крамер -> Анна Соколова
MATCH (a {name:"Вера Крамер"}), (b {name:"Анна Соколова"}) CREATE (a)-[:KNOWS]->(b);

//   MEMBER_OF: Борис Крамер -> Следственная группа
MATCH (a {name:"Борис Крамер"}), (b {name:"Следственная группа"}) CREATE (a)-[:MEMBER_OF {role: "руководитель"}]->(b);

//   MEMBER_OF: Кирилл Попов -> Следственная группа
MATCH (a {name:"Кирилл Попов"}), (b {name:"Следственная группа"}) CREATE (a)-[:MEMBER_OF {role: "оперативник"}]->(b);

//   MEMBER_OF: Анна Соколова -> Следственная группа
MATCH (a {name:"Анна Соколова"}), (b {name:"Следственная группа"}) CREATE (a)-[:MEMBER_OF {role: "консультант"}]->(b);

//   MEMBER_OF: Борис Крамер -> Семья Крамер
MATCH (a {name:"Борис Крамер"}), (b {name:"Семья Крамер"}) CREATE (a)-[:MEMBER_OF {role: "глава семьи"}]->(b);

//   MEMBER_OF: Вера Крамер -> Семья Крамер
MATCH (a {name:"Вера Крамер"}), (b {name:"Семья Крамер"}) CREATE (a)-[:MEMBER_OF {role: "супруга"}]->(b);

//   MEMBER_OF: Ирина Волкова -> Семья Крамер
MATCH (a {name:"Ирина Волкова"}), (b {name:"Семья Крамер"}) CREATE (a)-[:MEMBER_OF {role: "подруга семьи"}]->(b);

//   MEMBER_OF: Захар Титов -> Клуб «Полночь»
MATCH (a {name:"Захар Титов"}), (b {name:"Клуб «Полночь»"}) CREATE (a)-[:MEMBER_OF {role: "бармен"}]->(b);

//   MEMBER_OF: Марк Волков -> Клуб «Полночь»
MATCH (a {name:"Марк Волков"}), (b {name:"Клуб «Полночь»"}) CREATE (a)-[:MEMBER_OF {role: "музыкант"}]->(b);

//   MEMBER_OF: Глеб Орлов -> Клуб «Полночь»
MATCH (a {name:"Глеб Орлов"}), (b {name:"Клуб «Полночь»"}) CREATE (a)-[:MEMBER_OF {role: "гость"}]->(b);
