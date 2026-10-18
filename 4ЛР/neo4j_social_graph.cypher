//  Социальный граф Neo4j: «Порядок получения водительских прав» (категория B)
//  Neo4j 5.x. Источник данных: MongoDB-база voditelskie_prava (файл voditelskie_prava.js)
//  Выполнять шаги по порядку (каждый оператор заканчивается «;»).
//
//  ТИПЫ УЗЛОВ (метки) И ИХ ХАРАКТЕРИСТИКИ
//  Person:Kandidat    — человек, проходящий порядок получения прав.
//      id, imya, familiya, otchestvo, data_rozhdeniya (date), telefon, email, adres, data_registratsii (date)
//  Person:Sotrudnik   — работник автошколы (администратор, преподаватель, инструктор, экзаменатор и др.).
//      id, imya, familiya, otchestvo, telefon, email
//  Dolzhnost          — должность. id, nazvanie
//  Gruppa             — учебная группа. id, nazvanie, data_nachala (date), data_okonchaniya (date, может быть null)
//  KategoriyaPrav     — категория прав. id, kod, nazvanie, min_vozrast, opisanie
//  Etap               — шаг порядка получения прав.
//      id, nomer_shaga, nazvanie, opisanie, organizatsiya, srok_dney, obyazatelnyy, trebuemye_dokumenty (список строк)
//  Udostoverenie      — выданное водительское удостоверение.
//      id, nomer, data_vydachi (date), data_okonchaniya (date), podrazdelenie
//
//  ТИПЫ СВЯЗЕЙ И ИХ ХАРАКТЕРИСТИКИ
//  (Sotrudnik)-[:ZANIMAET]->(Dolzhnost)                       — без свойств
//  (Sotrudnik)-[:PREPODAET]->(Gruppa)                         — без свойств
//  (Sotrudnik)-[:INSTRUKTOR_DLYA {chasov_vozhdeniya}]->(Kandidat)
//  (Sotrudnik)-[:PRINYAL_ZAYAVLENIE {data_podachi, status, primechanie}]->(Kandidat)
//  (Sotrudnik)-[:PRINIMAL_EKZAMEN {tip_ekzamena, nomer_popytki, data_ekzamena, kolvo_oshibok, sdan}]->(Kandidat)
//  (Kandidat)-[:OBUCHAETSYA_V {chasov_teorii, chasov_vozhdeniya}]->(Gruppa)
//  (Kandidat)-[:PODAL_NA {data_podachi}]->(KategoriyaPrav)
//  (Kandidat)-[:ODNOGRUPPNIK_S {gruppa}]->(Kandidat)          — социальная связь, выводится запросом из OBUCHAETSYA_V
//  (Kandidat)-[:NA_ETAPE {status, data_nachala}]->(Etap)      — текущий этап заявления
//  (Gruppa)-[:DLYA_KATEGORII]->(KategoriyaPrav)               — без свойств
//  (Etap)-[:SLEDUYUSHCHIY_ETAP]->(Etap)                       — порядок шагов, без свойств
//  (Udostoverenie)-[:VYDANO]->(Kandidat)                      — без свойств
//
//  Итого: 55 узлов, 125 связей.

// ============================================================
// Шаг 0. Ограничения уникальности
// ============================================================
CREATE CONSTRAINT kandidat_id IF NOT EXISTS FOR (n:Kandidat) REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT sotrudnik_id IF NOT EXISTS FOR (n:Sotrudnik) REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT dolzhnost_id IF NOT EXISTS FOR (n:Dolzhnost) REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT gruppa_id IF NOT EXISTS FOR (n:Gruppa) REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT kategoriyaprav_id IF NOT EXISTS FOR (n:KategoriyaPrav) REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT etap_id IF NOT EXISTS FOR (n:Etap) REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT udostoverenie_id IF NOT EXISTS FOR (n:Udostoverenie) REQUIRE n.id IS UNIQUE;

// ============================================================
// Шаг 1. Справочные узлы: Dolzhnost, KategoriyaPrav, Etap и цепочка этапов
// ============================================================
UNWIND [
  {id: 1, nazvanie: "Директор"},
  {id: 2, nazvanie: "Менеджер"},
  {id: 3, nazvanie: "Администратор"},
  {id: 4, nazvanie: "Преподаватель ПДД"},
  {id: 5, nazvanie: "Инструктор по вождению"},
  {id: 6, nazvanie: "Экзаменатор"},
  {id: 7, nazvanie: "Бухгалтер"},
  {id: 8, nazvanie: "Секретарь"}
] AS r
CREATE (n:Dolzhnost)
SET n = r;

UNWIND [
  {id: 3, kod: "B", nazvanie: "Легковые автомобили", min_vozrast: 18, opisanie: "Автомобили до 3500 кг и не более 8 пассажирских мест"}
] AS r
CREATE (n:KategoriyaPrav)
SET n = r;

UNWIND [
  {id: 1, nomer_shaga: 1, nazvanie: "Подача заявления и документов", opisanie: "Кандидат подаёт заявление и пакет документов в автошколу; сотрудник проверяет комплектность.", organizatsiya: "Автошкола", srok_dney: 1, obyazatelnyy: true, trebuemye_dokumenty: ["Паспорт РФ", "Заявление", "Фотография 3x4"]},
  {id: 2, nomer_shaga: 2, nazvanie: "Прохождение медицинской комиссии", opisanie: "Получение медицинской справки установленного образца у врачей-специалистов.", organizatsiya: "Медицинское учреждение", srok_dney: 5, obyazatelnyy: true, trebuemye_dokumenty: ["Паспорт РФ"]},
  {id: 3, nomer_shaga: 3, nazvanie: "Зачисление в группу обучения", opisanie: "Заключение договора и зачисление кандидата в учебную группу категории B.", organizatsiya: "Автошкола", srok_dney: 3, obyazatelnyy: true, trebuemye_dokumenty: ["Паспорт РФ", "Медицинская справка"]},
  {id: 4, nomer_shaga: 4, nazvanie: "Теоретическое обучение", opisanie: "Изучение правил дорожного движения, основ безопасного управления и устройства автомобиля (130 ч).", organizatsiya: "Автошкола", srok_dney: 60, obyazatelnyy: true, trebuemye_dokumenty: []},
  {id: 5, nomer_shaga: 5, nazvanie: "Практическое обучение вождению", opisanie: "Занятия по вождению с инструктором на площадке и в городе (56 ч).", organizatsiya: "Автошкола", srok_dney: 90, obyazatelnyy: true, trebuemye_dokumenty: ["Медицинская справка"]},
  {id: 6, nomer_shaga: 6, nazvanie: "Внутренний экзамен в автошколе", opisanie: "Итоговая аттестация; по результатам выдаётся свидетельство об окончании автошколы.", organizatsiya: "Автошкола", srok_dney: 3, obyazatelnyy: true, trebuemye_dokumenty: []},
  {id: 7, nomer_shaga: 7, nazvanie: "Оплата госпошлины", opisanie: "Оплата государственной пошлины за экзамены и выдачу водительского удостоверения.", organizatsiya: "Госуслуги / банк", srok_dney: 1, obyazatelnyy: true, trebuemye_dokumenty: ["Паспорт РФ"]},
  {id: 8, nomer_shaga: 8, nazvanie: "Теоретический экзамен в ГИБДД", opisanie: "Компьютерный экзамен по ПДД: 20 вопросов, допускается не более двух ошибок.", organizatsiya: "МРЭО ГИБДД", srok_dney: 30, obyazatelnyy: true, trebuemye_dokumenty: ["Паспорт РФ", "Медицинская справка", "Свидетельство об окончании автошколы", "Квитанция об уплате госпошлины"]},
  {id: 9, nomer_shaga: 9, nazvanie: "Практический экзамен в ГИБДД", opisanie: "Экзамен на закрытой площадке (первоначальные навыки) и в условиях города.", organizatsiya: "МРЭО ГИБДД", srok_dney: 30, obyazatelnyy: true, trebuemye_dokumenty: ["Паспорт РФ", "Свидетельство об окончании автошколы"]},
  {id: 10, nomer_shaga: 10, nazvanie: "Получение водительского удостоверения", opisanie: "Выдача удостоверения после успешной сдачи всех экзаменов.", organizatsiya: "МРЭО ГИБДД", srok_dney: 5, obyazatelnyy: true, trebuemye_dokumenty: ["Паспорт РФ", "Медицинская справка"]}
] AS r
CREATE (n:Etap)
SET n = r;

MATCH (a:Etap), (b:Etap)
WHERE b.nomer_shaga = a.nomer_shaga + 1
CREATE (a)-[:SLEDUYUSHCHIY_ETAP]->(b);

// ============================================================
// Шаг 2. Сотрудники (Person:Sotrudnik) и связь ZANIMAET
// ============================================================
UNWIND [
  {id: 1, imya: "Алексей", familiya: "Кузнецов", otchestvo: "Петрович", telefon: "+79101112233", email: "alexey@avtoshkola.ru"},
  {id: 2, imya: "Наталья", familiya: "Попова", otchestvo: "Ивановна", telefon: "+79102223344", email: "natalya@avtoshkola.ru"},
  {id: 3, imya: "Виктор", familiya: "Сидоров", otchestvo: "Алексеевич", telefon: "+79103334455", email: "viktor@avtoshkola.ru"},
  {id: 4, imya: "Татьяна", familiya: "Белова", otchestvo: "Сергеевна", telefon: "+79104445566", email: "tatyana@avtoshkola.ru"},
  {id: 5, imya: "Михаил", familiya: "Громов", otchestvo: "Олегович", telefon: "+79105556677", email: "mikhail@avtoshkola.ru"},
  {id: 6, imya: "Ирина", familiya: "Крылова", otchestvo: "Викторовна", telefon: "+79106667788", email: "irina@avtoshkola.ru"},
  {id: 7, imya: "Андрей", familiya: "Титов", otchestvo: "Николаевич", telefon: "+79107778899", email: "andrey@gibdd-exam.ru"},
  {id: 8, imya: "Светлана", familiya: "Егорова", otchestvo: "Андреевна", telefon: "+79108889900", email: "svetlana@gibdd-exam.ru"},
  {id: 9, imya: "Роман", familiya: "Фомин", otchestvo: "Дмитриевич", telefon: "+79109990011", email: "roman@avtoshkola.ru"},
  {id: 10, imya: "Юлия", familiya: "Зайцева", otchestvo: "Павловна", telefon: "+79110001122", email: "yulia@avtoshkola.ru"}
] AS r
CREATE (n:Person:Sotrudnik)
SET n = r;

UNWIND [
  {a: 1, b: 1},
  {a: 2, b: 2},
  {a: 3, b: 3},
  {a: 4, b: 4},
  {a: 5, b: 5},
  {a: 6, b: 5},
  {a: 7, b: 6},
  {a: 8, b: 6},
  {a: 9, b: 7},
  {a: 10, b: 8}
] AS r
MATCH (a:Sotrudnik {id: r.a}), (b:Dolzhnost {id: r.b})
CREATE (a)-[:ZANIMAET]->(b);

// ============================================================
// Шаг 3. Кандидаты (Person:Kandidat) и группы обучения
// ============================================================
UNWIND [
  {id: 1, imya: "Иван", familiya: "Петров", otchestvo: "Сергеевич", data_rozhdeniya: "1990-05-12", telefon: "+79201112233", email: "ivan.petrov@mail.ru", adres: "Москва, ул. Ленина, 10, кв. 15", data_registratsii: "2025-01-08"},
  {id: 2, imya: "Анна", familiya: "Смирнова", otchestvo: "Ивановна", data_rozhdeniya: "2001-08-22", telefon: "+79202223344", email: "anna.smirnova@mail.ru", adres: "Москва, Невский пр., 25, кв. 7", data_registratsii: "2025-01-08"},
  {id: 3, imya: "Сергей", familiya: "Иванов", otchestvo: "Петрович", data_rozhdeniya: "1999-03-15", telefon: "+79203334455", email: "sergey.ivanov@mail.ru", adres: "Москва, ул. Баумана, 7, кв. 41", data_registratsii: "2025-05-06"},
  {id: 4, imya: "Мария", familiya: "Козлова", otchestvo: "Андреевна", data_rozhdeniya: "2002-12-01", telefon: "+79204445566", email: "maria.kozlova@mail.ru", adres: "Москва, Красный пр., 100, кв. 3", data_registratsii: "2025-05-07"},
  {id: 5, imya: "Дмитрий", familiya: "Орлов", otchestvo: "Викторович", data_rozhdeniya: "2003-07-19", telefon: "+79205556677", email: "dmitry.orlov@mail.ru", adres: "Москва, ул. Ленина, 24, кв. 88", data_registratsii: "2026-01-06"},
  {id: 6, imya: "Ольга", familiya: "Новикова", otchestvo: "Сергеевна", data_rozhdeniya: "1996-02-28", telefon: "+79206667788", email: "olga.novikova@mail.ru", adres: "Москва, Тверская ул., 15, кв. 12", data_registratsii: "2026-01-07"},
  {id: 7, imya: "Павел", familiya: "Морозов", otchestvo: "Игоревич", data_rozhdeniya: "2004-09-09", telefon: "+79207778899", email: "pavel.morozov@mail.ru", adres: "Москва, Курортная ул., 33, кв. 5", data_registratsii: "2026-05-06"},
  {id: 8, imya: "Елена", familiya: "Волкова", otchestvo: "Дмитриевна", data_rozhdeniya: "2000-11-11", telefon: "+79208889900", email: "elena.volkova@mail.ru", adres: "Москва, Арбат, 5, кв. 20", data_registratsii: "2026-07-01"},
  {id: 9, imya: "Артём", familiya: "Соколов", otchestvo: "Олегович", data_rozhdeniya: "2005-04-04", telefon: "+79209990011", email: "artem.sokolov@mail.ru", adres: "Москва, Светланская ул., 9, кв. 61", data_registratsii: "2026-09-02"},
  {id: 10, imya: "Ксения", familiya: "Лебедева", otchestvo: "Павловна", data_rozhdeniya: "2007-06-30", telefon: "+79210001122", email: "ksenia.lebedeva@mail.ru", adres: "Москва, Красная ул., 155, кв. 34", data_registratsii: "2026-10-12"}
] AS r
CREATE (n:Person:Kandidat)
SET n = r, n.data_rozhdeniya = date(r.data_rozhdeniya), n.data_registratsii = date(r.data_registratsii);

UNWIND [
  {id: 1, nazvanie: "B-25-01", data_nachala: "2025-01-13", data_okonchaniya: "2025-04-14"},
  {id: 2, nazvanie: "B-25-02", data_nachala: "2025-05-12", data_okonchaniya: "2025-08-11"},
  {id: 3, nazvanie: "B-25-03", data_nachala: "2025-09-01", data_okonchaniya: "2025-12-01"},
  {id: 4, nazvanie: "B-26-01", data_nachala: "2026-01-12", data_okonchaniya: "2026-04-13"},
  {id: 5, nazvanie: "B-26-02", data_nachala: "2026-03-02", data_okonchaniya: "2026-06-01"},
  {id: 6, nazvanie: "B-26-03", data_nachala: "2026-05-11", data_okonchaniya: "2026-08-10"},
  {id: 7, nazvanie: "B-26-04", data_nachala: "2026-07-06", data_okonchaniya: "2026-10-05"},
  {id: 8, nazvanie: "B-26-05", data_nachala: "2026-09-07", data_okonchaniya: null},
  {id: 9, nazvanie: "B-26-06", data_nachala: "2026-11-02", data_okonchaniya: null},
  {id: 10, nazvanie: "B-26-07", data_nachala: "2026-12-07", data_okonchaniya: null}
] AS r
CREATE (n:Gruppa)
SET n = r, n.data_nachala = date(r.data_nachala), n.data_okonchaniya = date(r.data_okonchaniya);

UNWIND [
  {a: 1, b: 3},
  {a: 2, b: 3},
  {a: 3, b: 3},
  {a: 4, b: 3},
  {a: 5, b: 3},
  {a: 6, b: 3},
  {a: 7, b: 3},
  {a: 8, b: 3},
  {a: 9, b: 3},
  {a: 10, b: 3}
] AS r
MATCH (a:Gruppa {id: r.a}), (b:KategoriyaPrav {id: r.b})
CREATE (a)-[:DLYA_KATEGORII]->(b);

UNWIND [
  {a: 4, b: 1},
  {a: 4, b: 2},
  {a: 4, b: 3},
  {a: 4, b: 4},
  {a: 4, b: 5},
  {a: 4, b: 6},
  {a: 4, b: 7},
  {a: 4, b: 8},
  {a: 4, b: 9},
  {a: 4, b: 10}
] AS r
MATCH (a:Sotrudnik {id: r.a}), (b:Gruppa {id: r.b})
CREATE (a)-[:PREPODAET]->(b);

// ============================================================
// Шаг 4. Связи кандидатов: обучение, инструктор, приём заявления, категория
// ============================================================
UNWIND [
  {a: 1, b: 1, chasov_teorii: 130, chasov_vozhdeniya: 56},
  {a: 2, b: 1, chasov_teorii: 130, chasov_vozhdeniya: 56},
  {a: 3, b: 2, chasov_teorii: 130, chasov_vozhdeniya: 56},
  {a: 4, b: 2, chasov_teorii: 130, chasov_vozhdeniya: 56},
  {a: 5, b: 4, chasov_teorii: 130, chasov_vozhdeniya: 56},
  {a: 6, b: 4, chasov_teorii: 130, chasov_vozhdeniya: 14},
  {a: 7, b: 6, chasov_teorii: 130, chasov_vozhdeniya: 56},
  {a: 8, b: 7, chasov_teorii: 130, chasov_vozhdeniya: 56},
  {a: 9, b: 8, chasov_teorii: 90, chasov_vozhdeniya: 12},
  {a: 10, b: 9, chasov_teorii: 0, chasov_vozhdeniya: 0}
] AS r
MATCH (a:Kandidat {id: r.a}), (b:Gruppa {id: r.b})
CREATE (a)-[:OBUCHAETSYA_V {chasov_teorii: r.chasov_teorii, chasov_vozhdeniya: r.chasov_vozhdeniya}]->(b);

UNWIND [
  {a: 5, b: 1, chasov_vozhdeniya: 56},
  {a: 6, b: 2, chasov_vozhdeniya: 56},
  {a: 5, b: 3, chasov_vozhdeniya: 56},
  {a: 6, b: 4, chasov_vozhdeniya: 56},
  {a: 5, b: 5, chasov_vozhdeniya: 56},
  {a: 6, b: 6, chasov_vozhdeniya: 14},
  {a: 5, b: 7, chasov_vozhdeniya: 56},
  {a: 6, b: 8, chasov_vozhdeniya: 56},
  {a: 5, b: 9, chasov_vozhdeniya: 12},
  {a: 6, b: 10, chasov_vozhdeniya: 0}
] AS r
MATCH (a:Sotrudnik {id: r.a}), (b:Kandidat {id: r.b})
CREATE (a)-[:INSTRUKTOR_DLYA {chasov_vozhdeniya: r.chasov_vozhdeniya}]->(b);

UNWIND [
  {a: 3, b: 1, data_podachi: "2025-01-08", status: "Права выданы", primechanie: null},
  {a: 3, b: 2, data_podachi: "2025-01-08", status: "Права выданы", primechanie: null},
  {a: 2, b: 3, data_podachi: "2025-05-06", status: "Права выданы", primechanie: "Пересдача теоретического экзамена"},
  {a: 3, b: 4, data_podachi: "2025-05-07", status: "Права выданы", primechanie: null},
  {a: 3, b: 5, data_podachi: "2026-01-06", status: "Права выданы", primechanie: null},
  {a: 2, b: 6, data_podachi: "2026-01-07", status: "Приостановлено", primechanie: "Приостановлено по заявлению кандидата"},
  {a: 3, b: 7, data_podachi: "2026-05-06", status: "Права выданы", primechanie: null},
  {a: 3, b: 8, data_podachi: "2026-07-01", status: "Сдача экзаменов", primechanie: null},
  {a: 2, b: 9, data_podachi: "2026-09-02", status: "Идёт обучение", primechanie: null},
  {a: 3, b: 10, data_podachi: "2026-10-12", status: "Документы приняты", primechanie: null}
] AS r
MATCH (a:Sotrudnik {id: r.a}), (b:Kandidat {id: r.b})
CREATE (a)-[:PRINYAL_ZAYAVLENIE {data_podachi: date(r.data_podachi), status: r.status, primechanie: r.primechanie}]->(b);

UNWIND [
  {a: 1, b: 3, data_podachi: "2025-01-08"},
  {a: 2, b: 3, data_podachi: "2025-01-08"},
  {a: 3, b: 3, data_podachi: "2025-05-06"},
  {a: 4, b: 3, data_podachi: "2025-05-07"},
  {a: 5, b: 3, data_podachi: "2026-01-06"},
  {a: 6, b: 3, data_podachi: "2026-01-07"},
  {a: 7, b: 3, data_podachi: "2026-05-06"},
  {a: 8, b: 3, data_podachi: "2026-07-01"},
  {a: 9, b: 3, data_podachi: "2026-09-02"},
  {a: 10, b: 3, data_podachi: "2026-10-12"}
] AS r
MATCH (a:Kandidat {id: r.a}), (b:KategoriyaPrav {id: r.b})
CREATE (a)-[:PODAL_NA {data_podachi: date(r.data_podachi)}]->(b);

// ============================================================
// Шаг 5. Социальные связи: однокашники и текущий этап
// ============================================================
MATCH (a:Kandidat)-[:OBUCHAETSYA_V]->(g:Gruppa)<-[:OBUCHAETSYA_V]-(b:Kandidat)
WHERE a.id < b.id
CREATE (a)-[:ODNOGRUPPNIK_S {gruppa: g.nazvanie}]->(b);

UNWIND [
  {a: 1, b: 10, status: "proyden", data_nachala: "2025-05-13"},
  {a: 2, b: 10, status: "proyden", data_nachala: "2025-05-13"},
  {a: 3, b: 10, status: "proyden", data_nachala: "2025-09-09"},
  {a: 4, b: 10, status: "proyden", data_nachala: "2025-09-09"},
  {a: 5, b: 10, status: "proyden", data_nachala: "2026-05-12"},
  {a: 6, b: 5, status: "v_protsesse", data_nachala: "2026-02-02"},
  {a: 7, b: 10, status: "proyden", data_nachala: "2026-09-08"},
  {a: 8, b: 9, status: "ozhidaet", data_nachala: null},
  {a: 9, b: 4, status: "v_protsesse", data_nachala: "2026-09-07"},
  {a: 10, b: 3, status: "ozhidaet", data_nachala: null}
] AS r
MATCH (a:Kandidat {id: r.a}), (b:Etap {id: r.b})
CREATE (a)-[:NA_ETAPE {status: r.status, data_nachala: date(r.data_nachala)}]->(b);

// ============================================================
// Шаг 6. Экзамены и водительские удостоверения
// ============================================================
UNWIND [
  {a: 4, b: 1, tip_ekzamena: "vnutrenniy", nomer_popytki: 1, data_ekzamena: "2025-04-08T10:00:00", kolvo_oshibok: 1, sdan: true},
  {a: 7, b: 1, tip_ekzamena: "teoriya", nomer_popytki: 1, data_ekzamena: "2025-04-21T10:00:00", kolvo_oshibok: 0, sdan: true},
  {a: 8, b: 1, tip_ekzamena: "ploshchadka", nomer_popytki: 1, data_ekzamena: "2025-05-05T11:00:00", kolvo_oshibok: 0, sdan: true},
  {a: 8, b: 1, tip_ekzamena: "gorod", nomer_popytki: 1, data_ekzamena: "2025-05-12T11:00:00", kolvo_oshibok: 2, sdan: true},
  {a: 4, b: 2, tip_ekzamena: "vnutrenniy", nomer_popytki: 1, data_ekzamena: "2025-04-08T10:00:00", kolvo_oshibok: 0, sdan: true},
  {a: 7, b: 2, tip_ekzamena: "teoriya", nomer_popytki: 1, data_ekzamena: "2025-04-21T10:00:00", kolvo_oshibok: 1, sdan: true},
  {a: 8, b: 2, tip_ekzamena: "ploshchadka", nomer_popytki: 1, data_ekzamena: "2025-05-05T11:00:00", kolvo_oshibok: 1, sdan: true},
  {a: 8, b: 2, tip_ekzamena: "gorod", nomer_popytki: 1, data_ekzamena: "2025-05-12T11:00:00", kolvo_oshibok: 1, sdan: true},
  {a: 4, b: 3, tip_ekzamena: "vnutrenniy", nomer_popytki: 1, data_ekzamena: "2025-08-05T10:00:00", kolvo_oshibok: 2, sdan: true},
  {a: 7, b: 3, tip_ekzamena: "teoriya", nomer_popytki: 1, data_ekzamena: "2025-08-18T10:00:00", kolvo_oshibok: 4, sdan: false},
  {a: 7, b: 3, tip_ekzamena: "teoriya", nomer_popytki: 2, data_ekzamena: "2025-08-25T10:00:00", kolvo_oshibok: 1, sdan: true},
  {a: 8, b: 3, tip_ekzamena: "ploshchadka", nomer_popytki: 1, data_ekzamena: "2025-09-01T11:00:00", kolvo_oshibok: 0, sdan: true},
  {a: 8, b: 3, tip_ekzamena: "gorod", nomer_popytki: 1, data_ekzamena: "2025-09-08T11:00:00", kolvo_oshibok: 3, sdan: true},
  {a: 4, b: 4, tip_ekzamena: "vnutrenniy", nomer_popytki: 1, data_ekzamena: "2025-08-05T10:00:00", kolvo_oshibok: 0, sdan: true},
  {a: 7, b: 4, tip_ekzamena: "teoriya", nomer_popytki: 1, data_ekzamena: "2025-08-18T10:00:00", kolvo_oshibok: 0, sdan: true},
  {a: 8, b: 4, tip_ekzamena: "ploshchadka", nomer_popytki: 1, data_ekzamena: "2025-09-01T11:00:00", kolvo_oshibok: 0, sdan: true},
  {a: 8, b: 4, tip_ekzamena: "gorod", nomer_popytki: 1, data_ekzamena: "2025-09-08T11:00:00", kolvo_oshibok: 0, sdan: true},
  {a: 4, b: 5, tip_ekzamena: "vnutrenniy", nomer_popytki: 1, data_ekzamena: "2026-04-07T10:00:00", kolvo_oshibok: 1, sdan: true},
  {a: 7, b: 5, tip_ekzamena: "teoriya", nomer_popytki: 1, data_ekzamena: "2026-04-20T10:00:00", kolvo_oshibok: 2, sdan: true},
  {a: 8, b: 5, tip_ekzamena: "ploshchadka", nomer_popytki: 1, data_ekzamena: "2026-05-04T11:00:00", kolvo_oshibok: 1, sdan: true},
  {a: 8, b: 5, tip_ekzamena: "gorod", nomer_popytki: 1, data_ekzamena: "2026-05-11T11:00:00", kolvo_oshibok: 2, sdan: true},
  {a: 4, b: 7, tip_ekzamena: "vnutrenniy", nomer_popytki: 1, data_ekzamena: "2026-08-04T10:00:00", kolvo_oshibok: 0, sdan: true},
  {a: 7, b: 7, tip_ekzamena: "teoriya", nomer_popytki: 1, data_ekzamena: "2026-08-17T10:00:00", kolvo_oshibok: 1, sdan: true},
  {a: 8, b: 7, tip_ekzamena: "ploshchadka", nomer_popytki: 1, data_ekzamena: "2026-08-31T11:00:00", kolvo_oshibok: 0, sdan: true},
  {a: 8, b: 7, tip_ekzamena: "gorod", nomer_popytki: 1, data_ekzamena: "2026-09-07T11:00:00", kolvo_oshibok: 1, sdan: true},
  {a: 4, b: 8, tip_ekzamena: "vnutrenniy", nomer_popytki: 1, data_ekzamena: "2026-09-29T10:00:00", kolvo_oshibok: 1, sdan: true},
  {a: 7, b: 8, tip_ekzamena: "teoriya", nomer_popytki: 1, data_ekzamena: "2026-10-12T10:00:00", kolvo_oshibok: 0, sdan: true}
] AS r
MATCH (a:Sotrudnik {id: r.a}), (b:Kandidat {id: r.b})
CREATE (a)-[:PRINIMAL_EKZAMEN {tip_ekzamena: r.tip_ekzamena, nomer_popytki: r.nomer_popytki, data_ekzamena: datetime(r.data_ekzamena), kolvo_oshibok: r.kolvo_oshibok, sdan: r.sdan}]->(b);

UNWIND [
  {id: 1, nomer: "99 25 100001", data_vydachi: "2025-05-13", data_okonchaniya: "2035-05-13", podrazdelenie: "МРЭО ГИБДД №1 ГУ МВД России по г. Москве"},
  {id: 2, nomer: "99 25 100002", data_vydachi: "2025-05-13", data_okonchaniya: "2035-05-13", podrazdelenie: "МРЭО ГИБДД №2 ГУ МВД России по г. Москве"},
  {id: 3, nomer: "99 25 100003", data_vydachi: "2025-09-09", data_okonchaniya: "2035-09-09", podrazdelenie: "МРЭО ГИБДД №3 ГУ МВД России по г. Москве"},
  {id: 4, nomer: "99 25 100004", data_vydachi: "2025-09-09", data_okonchaniya: "2035-09-09", podrazdelenie: "МРЭО ГИБДД №1 ГУ МВД России по г. Москве"},
  {id: 5, nomer: "99 26 100005", data_vydachi: "2026-05-12", data_okonchaniya: "2036-05-12", podrazdelenie: "МРЭО ГИБДД №2 ГУ МВД России по г. Москве"},
  {id: 6, nomer: "99 26 100007", data_vydachi: "2026-09-08", data_okonchaniya: "2036-09-08", podrazdelenie: "МРЭО ГИБДД №1 ГУ МВД России по г. Москве"}
] AS r
CREATE (n:Udostoverenie)
SET n = r, n.data_vydachi = date(r.data_vydachi), n.data_okonchaniya = date(r.data_okonchaniya);

UNWIND [
  {a: 1, b: 1},
  {a: 2, b: 2},
  {a: 3, b: 3},
  {a: 4, b: 4},
  {a: 5, b: 5},
  {a: 6, b: 7}
] AS r
MATCH (a:Udostoverenie {id: r.a}), (b:Kandidat {id: r.b})
CREATE (a)-[:VYDANO]->(b);

// ============================================================
// Проверка результата
// ============================================================
// Проверка: количество узлов по меткам
MATCH (n) RETURN labels(n) AS metki, count(*) AS kolichestvo ORDER BY kolichestvo DESC;

// Проверка: количество связей по типам
MATCH ()-[r]->() RETURN type(r) AS tip_svyazi, count(*) AS kolichestvo ORDER BY kolichestvo DESC;

// Итого: узлов и связей
MATCH (n) WITH count(n) AS uzlov
MATCH ()-[r]->() RETURN uzlov, count(r) AS svyazey;

// Социальный граф целиком
MATCH (p:Person)-[r]-(q:Person) RETURN p, r, q;

// Однокашники и их инструкторы
MATCH (a:Kandidat)-[o:ODNOGRUPPNIK_S]->(b:Kandidat)
OPTIONAL MATCH (i:Sotrudnik)-[:INSTRUKTOR_DLYA]->(a)
RETURN a.familiya, b.familiya, o.gruppa, i.familiya AS instruktor_pervogo;

// Кандидаты, получившие права, и принимавшие у них экзамены
MATCH (u:Udostoverenie)-[:VYDANO]->(k:Kandidat)<-[e:PRINIMAL_EKZAMEN]-(s:Sotrudnik)
RETURN k.familiya, s.familiya, e.tip_ekzamena, e.nomer_popytki, e.sdan ORDER BY k.familiya, e.data_ekzamena;

// Кандидаты, которые ещё не получили права, и их текущий этап
MATCH (k:Kandidat)-[ne:NA_ETAPE]->(et:Etap)
WHERE NOT (:Udostoverenie)-[:VYDANO]->(k)
RETURN k.familiya, et.nomer_shaga, et.nazvanie, ne.status;

// Путь по порядку получения прав
MATCH p = (:Etap {nomer_shaga: 1})-[:SLEDUYUSHCHIY_ETAP*]->(:Etap {nomer_shaga: 10})
RETURN [x IN nodes(p) | x.nazvanie] AS poryadok;
