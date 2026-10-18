// Социальный граф: узлы-персонажи (:Person)

// 12 персонажей с характеристиками
CREATE (p1:Person {name: "Анна Соколова", role: "журналист", age: 29, gender: "ж", city: "Москва", motivation: "найти правду"}),
       (p2:Person {name: "Борис Крамер", role: "детектив", age: 45, gender: "м", city: "Москва", motivation: "раскрыть дело"}),
       (p3:Person {name: "Вера Крамер", role: "врач", age: 41, gender: "ж", city: "Москва", motivation: "защитить семью"}),
       (p4:Person {name: "Глеб Орлов", role: "хакер", age: 23, gender: "м", city: "Казань", motivation: "доказать свой талант"}),
       (p5:Person {name: "Дина Орлова", role: "студентка", age: 20, gender: "ж", city: "Казань", motivation: "поступить в академию"}),
       (p6:Person {name: "Егор Морозов", role: "бизнесмен", age: 52, gender: "м", city: "Москва", motivation: "сохранить власть"}),
       (p7:Person {name: "Жанна Лебедева", role: "адвокат", age: 38, gender: "ж", city: "Москва", motivation: "выиграть процесс"}),
       (p8:Person {name: "Захар Титов", role: "бармен", age: 30, gender: "м", city: "Москва", motivation: "открыть свой бар"}),
       (p9:Person {name: "Ирина Волкова", role: "балерина", age: 26, gender: "ж", city: "Москва", motivation: "получить главную роль"}),
       (p10:Person {name: "Кирилл Попов", role: "полицейский", age: 33, gender: "м", city: "Москва", motivation: "выслужиться"}),
       (p11:Person {name: "Лидия Морозова", role: "галерист", age: 48, gender: "ж", city: "Москва", motivation: "сохранить репутацию"}),
       (p12:Person {name: "Марк Волков", role: "музыкант", age: 35, gender: "м", city: "Москва", motivation: "записать альбом"})
RETURN p1.name AS первый, p12.name AS последний;
