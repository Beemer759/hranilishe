//  БД: voditelskie_prava — порядок получения водительских прав (категория B)
//  MongoDB 4.4+

db = db.getSiblingDB("getDriverLicense");

// ========== 1. KATEGORIYA_PRAV ==========
db.kategoriya_prav.insertMany([
  { _id: 1, kod: "A", nazvanie: "Мотоциклы", min_vozrast: 16, opisanie: "Мотоциклы с объёмом двигателя более 125 см³" },
  { _id: 2, kod: "A1", nazvanie: "Лёгкие мотоциклы", min_vozrast: 16, opisanie: "Мотоциклы до 125 см³ и мощностью до 11 кВт" },
  { _id: 3, kod: "B", nazvanie: "Легковые автомобили", min_vozrast: 18, opisanie: "Автомобили до 3500 кг и не более 8 пассажирских мест" },
  { _id: 4, kod: "BE", nazvanie: "Легковые автомобили с прицепом", min_vozrast: 18, opisanie: "Категория B с прицепом свыше 750 кг" },
  { _id: 5, kod: "C", nazvanie: "Грузовые автомобили", min_vozrast: 18, opisanie: "Грузовые автомобили свыше 3500 кг" },
  { _id: 6, kod: "CE", nazvanie: "Грузовые автомобили с прицепом", min_vozrast: 18, opisanie: "Категория C с прицепом свыше 750 кг" },
  { _id: 7, kod: "D", nazvanie: "Автобусы", min_vozrast: 21, opisanie: "Автобусы более 8 пассажирских мест" },
  { _id: 8, kod: "M", nazvanie: "Мопеды и скутеры", min_vozrast: 16, opisanie: "Мопеды и квадрициклы лёгкие" },
  { _id: 9, kod: "Tm", nazvanie: "Трамваи", min_vozrast: 21, opisanie: "Управление трамваем" },
  { _id: 10, kod: "Tb", nazvanie: "Троллейбусы", min_vozrast: 21, opisanie: "Управление троллейбусом" }
])

// ========== 2. TIP_DOKUMENTA ==========
db.tip_dokumenta.insertMany([
  { _id: 1, nazvanie: "Паспорт РФ" },
  { _id: 2, nazvanie: "Заявление" },
  { _id: 3, nazvanie: "Медицинская справка" },
  { _id: 4, nazvanie: "Фотография 3x4" },
  { _id: 5, nazvanie: "СНИЛС" },
  { _id: 6, nazvanie: "Свидетельство об окончании автошколы" },
  { _id: 7, nazvanie: "Квитанция об уплате госпошлины" },
  { _id: 8, nazvanie: "Согласие родителей" },
  { _id: 9, nazvanie: "Временное разрешение" },
  { _id: 10, nazvanie: "Водительское удостоверение (ранее выданное)" }
])

// ========== 3. STATUS_ZAYAVLENIYA ==========
db.status_zayavleniya.insertMany([
  { _id: 1, nazvanie: "Подано" },
  { _id: 2, nazvanie: "Документы приняты" },
  { _id: 3, nazvanie: "Идёт обучение" },
  { _id: 4, nazvanie: "Допущен к экзаменам" },
  { _id: 5, nazvanie: "Сдача экзаменов" },
  { _id: 6, nazvanie: "Экзамены сданы" },
  { _id: 7, nazvanie: "Права выданы" },
  { _id: 8, nazvanie: "Отклонено" },
  { _id: 9, nazvanie: "Приостановлено" },
  { _id: 10, nazvanie: "Отозвано" }
])

// ========== 4. SPOSOB_OPLATY ==========
db.sposob_oplaty.insertMany([
  { _id: 1, nazvanie: "Наличные" },
  { _id: 2, nazvanie: "Банковская карта" },
  { _id: 3, nazvanie: "СБП" },
  { _id: 4, nazvanie: "Онлайн-перевод" },
  { _id: 5, nazvanie: "QR-код" },
  { _id: 6, nazvanie: "Безналичный расчёт" },
  { _id: 7, nazvanie: "Госуслуги" },
  { _id: 8, nazvanie: "Рассрочка" },
  { _id: 9, nazvanie: "Подарочный сертификат" },
  { _id: 10, nazvanie: "Бонусные баллы" }
])

// ========== 5. DOLZHNOST ==========
db.dolzhnost.insertMany([
  { _id: 1, nazvanie: "Директор" },
  { _id: 2, nazvanie: "Менеджер" },
  { _id: 3, nazvanie: "Администратор" },
  { _id: 4, nazvanie: "Преподаватель ПДД" },
  { _id: 5, nazvanie: "Инструктор по вождению" },
  { _id: 6, nazvanie: "Экзаменатор" },
  { _id: 7, nazvanie: "Бухгалтер" },
  { _id: 8, nazvanie: "Секретарь" },
  { _id: 9, nazvanie: "Мастер производственного обучения" },
  { _id: 10, nazvanie: "Стажёр" }
])

// ========== 6. ETAP_PORYADKA ==========
db.etap_poryadka.insertMany([
  {
    _id: 1, kategoriya_id: 3, nomer_shaga: 1,
    nazvanie: "Подача заявления и документов",
    opisanie: "Кандидат подаёт заявление и пакет документов в автошколу; сотрудник проверяет комплектность.",
    organizatsiya: "Автошкола", obyazatelnyy: true, srok_dney: 1,
    dokumenty: [
      { tip_dokumenta_id: 1, obyazatelnyy: true },
      { tip_dokumenta_id: 2, obyazatelnyy: true },
      { tip_dokumenta_id: 4, obyazatelnyy: true },
      { tip_dokumenta_id: 5, obyazatelnyy: false }
    ]
  },
  {
    _id: 2, kategoriya_id: 3, nomer_shaga: 2,
    nazvanie: "Прохождение медицинской комиссии",
    opisanie: "Получение медицинской справки установленного образца у врачей-специалистов.",
    organizatsiya: "Медицинское учреждение", obyazatelnyy: true, srok_dney: 5,
    dokumenty: [
      { tip_dokumenta_id: 1, obyazatelnyy: true }
    ]
  },
  {
    _id: 3, kategoriya_id: 3, nomer_shaga: 3,
    nazvanie: "Зачисление в группу обучения",
    opisanie: "Заключение договора и зачисление кандидата в учебную группу категории B.",
    organizatsiya: "Автошкола", obyazatelnyy: true, srok_dney: 3,
    dokumenty: [
      { tip_dokumenta_id: 1, obyazatelnyy: true },
      { tip_dokumenta_id: 3, obyazatelnyy: true }
    ]
  },
  {
    _id: 4, kategoriya_id: 3, nomer_shaga: 4,
    nazvanie: "Теоретическое обучение",
    opisanie: "Изучение правил дорожного движения, основ безопасного управления и устройства автомобиля (130 ч).",
    organizatsiya: "Автошкола", obyazatelnyy: true, srok_dney: 60,
    dokumenty: []
  },
  {
    _id: 5, kategoriya_id: 3, nomer_shaga: 5,
    nazvanie: "Практическое обучение вождению",
    opisanie: "Занятия по вождению с инструктором на площадке и в городе (56 ч).",
    organizatsiya: "Автошкола", obyazatelnyy: true, srok_dney: 90,
    dokumenty: [
      { tip_dokumenta_id: 3, obyazatelnyy: true }
    ]
  },
  {
    _id: 6, kategoriya_id: 3, nomer_shaga: 6,
    nazvanie: "Внутренний экзамен в автошколе",
    opisanie: "Итоговая аттестация; по результатам выдаётся свидетельство об окончании автошколы.",
    organizatsiya: "Автошкола", obyazatelnyy: true, srok_dney: 3,
    dokumenty: []
  },
  {
    _id: 7, kategoriya_id: 3, nomer_shaga: 7,
    nazvanie: "Оплата госпошлины",
    opisanie: "Оплата государственной пошлины за экзамены и выдачу водительского удостоверения.",
    organizatsiya: "Госуслуги / банк", obyazatelnyy: true, srok_dney: 1,
    dokumenty: [
      { tip_dokumenta_id: 1, obyazatelnyy: true }
    ]
  },
  {
    _id: 8, kategoriya_id: 3, nomer_shaga: 8,
    nazvanie: "Теоретический экзамен в ГИБДД",
    opisanie: "Компьютерный экзамен по ПДД: 20 вопросов, допускается не более двух ошибок.",
    organizatsiya: "МРЭО ГИБДД", obyazatelnyy: true, srok_dney: 30,
    dokumenty: [
      { tip_dokumenta_id: 1, obyazatelnyy: true },
      { tip_dokumenta_id: 3, obyazatelnyy: true },
      { tip_dokumenta_id: 6, obyazatelnyy: true },
      { tip_dokumenta_id: 7, obyazatelnyy: true }
    ]
  },
  {
    _id: 9, kategoriya_id: 3, nomer_shaga: 9,
    nazvanie: "Практический экзамен в ГИБДД",
    opisanie: "Экзамен на закрытой площадке (первоначальные навыки) и в условиях города.",
    organizatsiya: "МРЭО ГИБДД", obyazatelnyy: true, srok_dney: 30,
    dokumenty: [
      { tip_dokumenta_id: 1, obyazatelnyy: true },
      { tip_dokumenta_id: 6, obyazatelnyy: true },
      { tip_dokumenta_id: 7, obyazatelnyy: false }
    ]
  },
  {
    _id: 10, kategoriya_id: 3, nomer_shaga: 10,
    nazvanie: "Получение водительского удостоверения",
    opisanie: "Выдача удостоверения после успешной сдачи всех экзаменов.",
    organizatsiya: "МРЭО ГИБДД", obyazatelnyy: true, srok_dney: 5,
    dokumenty: [
      { tip_dokumenta_id: 1, obyazatelnyy: true },
      { tip_dokumenta_id: 3, obyazatelnyy: true },
      { tip_dokumenta_id: 4, obyazatelnyy: false }
    ]
  }
])

// ========== 7. SOTRUDNIK ==========
db.sotrudnik.insertMany([
  { _id: 1, imya: "Алексей", familiya: "Кузнецов", otchestvo: "Петрович", telefon: "+79101112233", email: "alexey@avtoshkola.ru", dolzhnost_id: 1 },
  { _id: 2, imya: "Наталья", familiya: "Попова", otchestvo: "Ивановна", telefon: "+79102223344", email: "natalya@avtoshkola.ru", dolzhnost_id: 2 },
  { _id: 3, imya: "Виктор", familiya: "Сидоров", otchestvo: "Алексеевич", telefon: "+79103334455", email: "viktor@avtoshkola.ru", dolzhnost_id: 3 },
  { _id: 4, imya: "Татьяна", familiya: "Белова", otchestvo: "Сергеевна", telefon: "+79104445566", email: "tatyana@avtoshkola.ru", dolzhnost_id: 4 },
  { _id: 5, imya: "Михаил", familiya: "Громов", otchestvo: "Олегович", telefon: "+79105556677", email: "mikhail@avtoshkola.ru", dolzhnost_id: 5 },
  { _id: 6, imya: "Ирина", familiya: "Крылова", otchestvo: "Викторовна", telefon: "+79106667788", email: "irina@avtoshkola.ru", dolzhnost_id: 5 },
  { _id: 7, imya: "Андрей", familiya: "Титов", otchestvo: "Николаевич", telefon: "+79107778899", email: "andrey@gibdd-exam.ru", dolzhnost_id: 6 },
  { _id: 8, imya: "Светлана", familiya: "Егорова", otchestvo: "Андреевна", telefon: "+79108889900", email: "svetlana@gibdd-exam.ru", dolzhnost_id: 6 },
  { _id: 9, imya: "Роман", familiya: "Фомин", otchestvo: "Дмитриевич", telefon: "+79109990011", email: "roman@avtoshkola.ru", dolzhnost_id: 7 },
  { _id: 10, imya: "Юлия", familiya: "Зайцева", otchestvo: "Павловна", telefon: "+79110001122", email: "yulia@avtoshkola.ru", dolzhnost_id: 8 }
])

// ========== 8. KANDIDAT ==========
db.kandidat.insertMany([
  { _id: 1, imya: "Иван", familiya: "Петров", otchestvo: "Сергеевич", data_rozhdeniya: new Date("1990-05-12"), telefon: "+79201112233", email: "ivan.petrov@mail.ru", adres: "Москва, ул. Ленина, 10, кв. 15", data_registratsii: new Date("2025-01-08") },
  { _id: 2, imya: "Анна", familiya: "Смирнова", otchestvo: "Ивановна", data_rozhdeniya: new Date("2001-08-22"), telefon: "+79202223344", email: "anna.smirnova@mail.ru", adres: "Москва, Невский пр., 25, кв. 7", data_registratsii: new Date("2025-01-08") },
  { _id: 3, imya: "Сергей", familiya: "Иванов", otchestvo: "Петрович", data_rozhdeniya: new Date("1999-03-15"), telefon: "+79203334455", email: "sergey.ivanov@mail.ru", adres: "Москва, ул. Баумана, 7, кв. 41", data_registratsii: new Date("2025-05-06") },
  { _id: 4, imya: "Мария", familiya: "Козлова", otchestvo: "Андреевна", data_rozhdeniya: new Date("2002-12-01"), telefon: "+79204445566", email: "maria.kozlova@mail.ru", adres: "Москва, Красный пр., 100, кв. 3", data_registratsii: new Date("2025-05-07") },
  { _id: 5, imya: "Дмитрий", familiya: "Орлов", otchestvo: "Викторович", data_rozhdeniya: new Date("2003-07-19"), telefon: "+79205556677", email: "dmitry.orlov@mail.ru", adres: "Москва, ул. Ленина, 24, кв. 88", data_registratsii: new Date("2026-01-06") },
  { _id: 6, imya: "Ольга", familiya: "Новикова", otchestvo: "Сергеевна", data_rozhdeniya: new Date("1996-02-28"), telefon: "+79206667788", email: "olga.novikova@mail.ru", adres: "Москва, Тверская ул., 15, кв. 12", data_registratsii: new Date("2026-01-07") },
  { _id: 7, imya: "Павел", familiya: "Морозов", otchestvo: "Игоревич", data_rozhdeniya: new Date("2004-09-09"), telefon: "+79207778899", email: "pavel.morozov@mail.ru", adres: "Москва, Курортная ул., 33, кв. 5", data_registratsii: new Date("2026-05-06") },
  { _id: 8, imya: "Елена", familiya: "Волкова", otchestvo: "Дмитриевна", data_rozhdeniya: new Date("2000-11-11"), telefon: "+79208889900", email: "elena.volkova@mail.ru", adres: "Москва, Арбат, 5, кв. 20", data_registratsii: new Date("2026-07-01") },
  { _id: 9, imya: "Артём", familiya: "Соколов", otchestvo: "Олегович", data_rozhdeniya: new Date("2005-04-04"), telefon: "+79209990011", email: "artem.sokolov@mail.ru", adres: "Москва, Светланская ул., 9, кв. 61", data_registratsii: new Date("2026-09-02") },
  { _id: 10, imya: "Ксения", familiya: "Лебедева", otchestvo: "Павловна", data_rozhdeniya: new Date("2007-06-30"), telefon: "+79210001122", email: "ksenia.lebedeva@mail.ru", adres: "Москва, Красная ул., 155, кв. 34", data_registratsii: new Date("2026-10-12") }
])

// ========== 9. DOKUMENT ==========
db.dokument.insertMany([
  { _id: 1, kandidat_id: 1, tip_dokumenta_id: 1, seriya: "4510", nomer: "123456", kem_vydan: "ГУ МВД России по г. Москве", data_vydachi: new Date("2010-06-15"), data_okonchaniya: null },
  { _id: 2, kandidat_id: 2, tip_dokumenta_id: 1, seriya: "4521", nomer: "234567", kem_vydan: "ГУ МВД России по г. Москве", data_vydachi: new Date("2021-09-10"), data_okonchaniya: null },
  { _id: 3, kandidat_id: 3, tip_dokumenta_id: 1, seriya: "4519", nomer: "345678", kem_vydan: "ГУ МВД России по г. Москве", data_vydachi: new Date("2019-04-02"), data_okonchaniya: null },
  { _id: 4, kandidat_id: 4, tip_dokumenta_id: 1, seriya: "4522", nomer: "456789", kem_vydan: "ГУ МВД России по г. Москве", data_vydachi: new Date("2022-12-20"), data_okonchaniya: null },
  { _id: 5, kandidat_id: 5, tip_dokumenta_id: 1, seriya: "4523", nomer: "567890", kem_vydan: "ГУ МВД России по г. Москве", data_vydachi: new Date("2023-08-05"), data_okonchaniya: null },
  { _id: 6, kandidat_id: 6, tip_dokumenta_id: 1, seriya: "4516", nomer: "678901", kem_vydan: "ГУ МВД России по г. Москве", data_vydachi: new Date("2016-03-15"), data_okonchaniya: null },
  { _id: 7, kandidat_id: 7, tip_dokumenta_id: 1, seriya: "4524", nomer: "789012", kem_vydan: "ГУ МВД России по г. Москве", data_vydachi: new Date("2024-10-02"), data_okonchaniya: null },
  { _id: 8, kandidat_id: 8, tip_dokumenta_id: 1, seriya: "4520", nomer: "890123", kem_vydan: "ГУ МВД России по г. Москве", data_vydachi: new Date("2020-12-01"), data_okonchaniya: null },
  { _id: 9, kandidat_id: 9, tip_dokumenta_id: 1, seriya: "4519", nomer: "901234", kem_vydan: "ГУ МВД России по г. Москве", data_vydachi: new Date("2019-05-06"), data_okonchaniya: null },
  { _id: 10, kandidat_id: 10, tip_dokumenta_id: 1, seriya: "4521", nomer: "012345", kem_vydan: "ГУ МВД России по г. Москве", data_vydachi: new Date("2021-07-20"), data_okonchaniya: null }
])

// ========== 10. MEDITSINSKAYA_SPRAVKA ==========
db.meditsinskaya_spravka.insertMany([
  { _id: 1, kandidat_id: 1, nomer: "МС-2025-0101", meditsinskoe_uchrezhdenie: "ГБУЗ «ГП №12 ДЗМ»", data_vydachi: new Date("2025-01-12"), data_okonchaniya: new Date("2027-01-12"), dopusk: true },
  { _id: 2, kandidat_id: 2, nomer: "МС-2025-0102", meditsinskoe_uchrezhdenie: "ООО «Клиника Здоровье»", data_vydachi: new Date("2025-01-12"), data_okonchaniya: new Date("2027-01-12"), dopusk: true },
  { _id: 3, kandidat_id: 3, nomer: "МС-2025-0103", meditsinskoe_uchrezhdenie: "ГБУЗ «ГП №68 ДЗМ»", data_vydachi: new Date("2025-05-10"), data_okonchaniya: new Date("2027-05-10"), dopusk: true },
  { _id: 4, kandidat_id: 4, nomer: "МС-2025-0104", meditsinskoe_uchrezhdenie: "МЦ «Профосмотр»", data_vydachi: new Date("2025-05-11"), data_okonchaniya: new Date("2027-05-11"), dopusk: true },
  { _id: 5, kandidat_id: 5, nomer: "МС-2026-0105", meditsinskoe_uchrezhdenie: "ГБУЗ «ГП №107 ДЗМ»", data_vydachi: new Date("2026-01-10"), data_okonchaniya: new Date("2028-01-10"), dopusk: true },
  { _id: 6, kandidat_id: 6, nomer: "МС-2026-0106", meditsinskoe_uchrezhdenie: "ООО «Медцентр Альфа»", data_vydachi: new Date("2026-01-11"), data_okonchaniya: new Date("2028-01-11"), dopusk: true },
  { _id: 7, kandidat_id: 7, nomer: "МС-2026-0107", meditsinskoe_uchrezhdenie: "ГБУЗ «ГП №12 ДЗМ»", data_vydachi: new Date("2026-05-10"), data_okonchaniya: new Date("2028-05-10"), dopusk: true },
  { _id: 8, kandidat_id: 8, nomer: "МС-2026-0108", meditsinskoe_uchrezhdenie: "МЦ «Профосмотр»", data_vydachi: new Date("2026-07-05"), data_okonchaniya: new Date("2028-07-05"), dopusk: true },
  { _id: 9, kandidat_id: 9, nomer: "МС-2026-0109", meditsinskoe_uchrezhdenie: "ГБУЗ «ГП №68 ДЗМ»", data_vydachi: new Date("2026-09-06"), data_okonchaniya: new Date("2028-09-06"), dopusk: true },
  { _id: 10, kandidat_id: 10, nomer: "МС-2026-0110", meditsinskoe_uchrezhdenie: "ООО «Клиника Здоровье»", data_vydachi: new Date("2026-10-16"), data_okonchaniya: new Date("2028-10-16"), dopusk: true }
])

// ========== 11. GRUPPA_OBUCHENIYA ==========
db.gruppa_obucheniya.insertMany([
  { _id: 1, nazvanie: "B-25-01", kategoriya_id: 3, prepodavatel_id: 4, data_nachala: new Date("2025-01-13"), data_okonchaniya: new Date("2025-04-14") },
  { _id: 2, nazvanie: "B-25-02", kategoriya_id: 3, prepodavatel_id: 4, data_nachala: new Date("2025-05-12"), data_okonchaniya: new Date("2025-08-11") },
  { _id: 3, nazvanie: "B-25-03", kategoriya_id: 3, prepodavatel_id: 4, data_nachala: new Date("2025-09-01"), data_okonchaniya: new Date("2025-12-01") },
  { _id: 4, nazvanie: "B-26-01", kategoriya_id: 3, prepodavatel_id: 4, data_nachala: new Date("2026-01-12"), data_okonchaniya: new Date("2026-04-13") },
  { _id: 5, nazvanie: "B-26-02", kategoriya_id: 3, prepodavatel_id: 4, data_nachala: new Date("2026-03-02"), data_okonchaniya: new Date("2026-06-01") },
  { _id: 6, nazvanie: "B-26-03", kategoriya_id: 3, prepodavatel_id: 4, data_nachala: new Date("2026-05-11"), data_okonchaniya: new Date("2026-08-10") },
  { _id: 7, nazvanie: "B-26-04", kategoriya_id: 3, prepodavatel_id: 4, data_nachala: new Date("2026-07-06"), data_okonchaniya: new Date("2026-10-05") },
  { _id: 8, nazvanie: "B-26-05", kategoriya_id: 3, prepodavatel_id: 4, data_nachala: new Date("2026-09-07"), data_okonchaniya: null },
  { _id: 9, nazvanie: "B-26-06", kategoriya_id: 3, prepodavatel_id: 4, data_nachala: new Date("2026-11-02"), data_okonchaniya: null },
  { _id: 10, nazvanie: "B-26-07", kategoriya_id: 3, prepodavatel_id: 4, data_nachala: new Date("2026-12-07"), data_okonchaniya: null }
])

// ========== 12. ZAYAVLENIE ==========
db.zayavlenie.insertMany([
  {
    _id: 1, kandidat_id: 1, kategoriya_id: 3, sotrudnik_id: 3, status_id: 7,
    data_podachi: new Date("2025-01-08"), primechanie: null,
    etapy: [
      { etap_id: 1, status: "proyden", data_nachala: new Date("2025-01-08"), data_zaversheniya: new Date("2025-01-08"), komentariy: "Документы приняты" },
      { etap_id: 2, status: "proyden", data_nachala: new Date("2025-01-09"), data_zaversheniya: new Date("2025-01-12"), komentariy: "Справка получена" },
      { etap_id: 3, status: "proyden", data_nachala: new Date("2025-01-13"), data_zaversheniya: new Date("2025-01-13"), komentariy: "Договор заключён" },
      { etap_id: 4, status: "proyden", data_nachala: new Date("2025-01-13"), data_zaversheniya: new Date("2025-03-10"), komentariy: "Теоретический курс пройден" },
      { etap_id: 5, status: "proyden", data_nachala: new Date("2025-02-03"), data_zaversheniya: new Date("2025-04-07"), komentariy: "Практический курс пройден" },
      { etap_id: 6, status: "proyden", data_nachala: new Date("2025-04-08"), data_zaversheniya: new Date("2025-04-10"), komentariy: "Свидетельство выдано" },
      { etap_id: 7, status: "proyden", data_nachala: new Date("2025-04-11"), data_zaversheniya: new Date("2025-04-11"), komentariy: "Госпошлина оплачена" },
      { etap_id: 8, status: "proyden", data_nachala: new Date("2025-04-21"), data_zaversheniya: new Date("2025-04-21"), komentariy: "Теория сдана" },
      { etap_id: 9, status: "proyden", data_nachala: new Date("2025-05-05"), data_zaversheniya: new Date("2025-05-12"), komentariy: "Площадка и город сданы" },
      { etap_id: 10, status: "proyden", data_nachala: new Date("2025-05-13"), data_zaversheniya: new Date("2025-05-13"), komentariy: "Удостоверение выдано" }
    ],
    zachisleniya: [
      { gruppa_id: 1, instruktor_id: 5, chasov_teorii: 130, chasov_vozhdeniya: 56 }
    ]
  },
  {
    _id: 2, kandidat_id: 2, kategoriya_id: 3, sotrudnik_id: 3, status_id: 7,
    data_podachi: new Date("2025-01-08"), primechanie: null,
    etapy: [
      { etap_id: 1, status: "proyden", data_nachala: new Date("2025-01-08"), data_zaversheniya: new Date("2025-01-08"), komentariy: "Документы приняты" },
      { etap_id: 2, status: "proyden", data_nachala: new Date("2025-01-09"), data_zaversheniya: new Date("2025-01-12"), komentariy: "Справка получена" },
      { etap_id: 3, status: "proyden", data_nachala: new Date("2025-01-13"), data_zaversheniya: new Date("2025-01-13"), komentariy: "Договор заключён" },
      { etap_id: 4, status: "proyden", data_nachala: new Date("2025-01-13"), data_zaversheniya: new Date("2025-03-10"), komentariy: "Теоретический курс пройден" },
      { etap_id: 5, status: "proyden", data_nachala: new Date("2025-02-03"), data_zaversheniya: new Date("2025-04-07"), komentariy: "Практический курс пройден" },
      { etap_id: 6, status: "proyden", data_nachala: new Date("2025-04-08"), data_zaversheniya: new Date("2025-04-10"), komentariy: "Свидетельство выдано" },
      { etap_id: 7, status: "proyden", data_nachala: new Date("2025-04-11"), data_zaversheniya: new Date("2025-04-11"), komentariy: "Госпошлина оплачена" },
      { etap_id: 8, status: "proyden", data_nachala: new Date("2025-04-21"), data_zaversheniya: new Date("2025-04-21"), komentariy: "Теория сдана" },
      { etap_id: 9, status: "proyden", data_nachala: new Date("2025-05-05"), data_zaversheniya: new Date("2025-05-12"), komentariy: "Площадка и город сданы" },
      { etap_id: 10, status: "proyden", data_nachala: new Date("2025-05-13"), data_zaversheniya: new Date("2025-05-13"), komentariy: "Удостоверение выдано" }
    ],
    zachisleniya: [
      { gruppa_id: 1, instruktor_id: 6, chasov_teorii: 130, chasov_vozhdeniya: 56 }
    ]
  },
  {
    _id: 3, kandidat_id: 3, kategoriya_id: 3, sotrudnik_id: 2, status_id: 7,
    data_podachi: new Date("2025-05-06"), primechanie: "Пересдача теоретического экзамена",
    etapy: [
      { etap_id: 1, status: "proyden", data_nachala: new Date("2025-05-06"), data_zaversheniya: new Date("2025-05-06"), komentariy: "Документы приняты" },
      { etap_id: 2, status: "proyden", data_nachala: new Date("2025-05-07"), data_zaversheniya: new Date("2025-05-10"), komentariy: "Справка получена" },
      { etap_id: 3, status: "proyden", data_nachala: new Date("2025-05-12"), data_zaversheniya: new Date("2025-05-12"), komentariy: "Договор заключён" },
      { etap_id: 4, status: "proyden", data_nachala: new Date("2025-05-12"), data_zaversheniya: new Date("2025-07-07"), komentariy: "Теоретический курс пройден" },
      { etap_id: 5, status: "proyden", data_nachala: new Date("2025-06-02"), data_zaversheniya: new Date("2025-08-04"), komentariy: "Практический курс пройден" },
      { etap_id: 6, status: "proyden", data_nachala: new Date("2025-08-05"), data_zaversheniya: new Date("2025-08-07"), komentariy: "Свидетельство выдано" },
      { etap_id: 7, status: "proyden", data_nachala: new Date("2025-08-08"), data_zaversheniya: new Date("2025-08-08"), komentariy: "Госпошлина оплачена" },
      { etap_id: 8, status: "proyden", data_nachala: new Date("2025-08-18"), data_zaversheniya: new Date("2025-08-25"), komentariy: "Сдан со 2-й попытки" },
      { etap_id: 9, status: "proyden", data_nachala: new Date("2025-09-01"), data_zaversheniya: new Date("2025-09-08"), komentariy: "Площадка и город сданы" },
      { etap_id: 10, status: "proyden", data_nachala: new Date("2025-09-09"), data_zaversheniya: new Date("2025-09-09"), komentariy: "Удостоверение выдано" }
    ],
    zachisleniya: [
      { gruppa_id: 2, instruktor_id: 5, chasov_teorii: 130, chasov_vozhdeniya: 56 }
    ]
  },
  {
    _id: 4, kandidat_id: 4, kategoriya_id: 3, sotrudnik_id: 3, status_id: 7,
    data_podachi: new Date("2025-05-07"), primechanie: null,
    etapy: [
      { etap_id: 1, status: "proyden", data_nachala: new Date("2025-05-07"), data_zaversheniya: new Date("2025-05-07"), komentariy: "Документы приняты" },
      { etap_id: 2, status: "proyden", data_nachala: new Date("2025-05-08"), data_zaversheniya: new Date("2025-05-11"), komentariy: "Справка получена" },
      { etap_id: 3, status: "proyden", data_nachala: new Date("2025-05-12"), data_zaversheniya: new Date("2025-05-12"), komentariy: "Договор заключён" },
      { etap_id: 4, status: "proyden", data_nachala: new Date("2025-05-12"), data_zaversheniya: new Date("2025-07-07"), komentariy: "Теоретический курс пройден" },
      { etap_id: 5, status: "proyden", data_nachala: new Date("2025-06-02"), data_zaversheniya: new Date("2025-08-04"), komentariy: "Практический курс пройден" },
      { etap_id: 6, status: "proyden", data_nachala: new Date("2025-08-05"), data_zaversheniya: new Date("2025-08-07"), komentariy: "Свидетельство выдано" },
      { etap_id: 7, status: "proyden", data_nachala: new Date("2025-08-08"), data_zaversheniya: new Date("2025-08-08"), komentariy: "Госпошлина оплачена" },
      { etap_id: 8, status: "proyden", data_nachala: new Date("2025-08-18"), data_zaversheniya: new Date("2025-08-18"), komentariy: "Теория сдана" },
      { etap_id: 9, status: "proyden", data_nachala: new Date("2025-09-01"), data_zaversheniya: new Date("2025-09-08"), komentariy: "Площадка и город сданы" },
      { etap_id: 10, status: "proyden", data_nachala: new Date("2025-09-09"), data_zaversheniya: new Date("2025-09-09"), komentariy: "Удостоверение выдано" }
    ],
    zachisleniya: [
      { gruppa_id: 2, instruktor_id: 6, chasov_teorii: 130, chasov_vozhdeniya: 56 }
    ]
  },
  {
    _id: 5, kandidat_id: 5, kategoriya_id: 3, sotrudnik_id: 3, status_id: 7,
    data_podachi: new Date("2026-01-06"), primechanie: null,
    etapy: [
      { etap_id: 1, status: "proyden", data_nachala: new Date("2026-01-06"), data_zaversheniya: new Date("2026-01-06"), komentariy: "Документы приняты" },
      { etap_id: 2, status: "proyden", data_nachala: new Date("2026-01-07"), data_zaversheniya: new Date("2026-01-10"), komentariy: "Справка получена" },
      { etap_id: 3, status: "proyden", data_nachala: new Date("2026-01-12"), data_zaversheniya: new Date("2026-01-12"), komentariy: "Договор заключён" },
      { etap_id: 4, status: "proyden", data_nachala: new Date("2026-01-12"), data_zaversheniya: new Date("2026-03-09"), komentariy: "Теоретический курс пройден" },
      { etap_id: 5, status: "proyden", data_nachala: new Date("2026-02-02"), data_zaversheniya: new Date("2026-04-06"), komentariy: "Практический курс пройден" },
      { etap_id: 6, status: "proyden", data_nachala: new Date("2026-04-07"), data_zaversheniya: new Date("2026-04-09"), komentariy: "Свидетельство выдано" },
      { etap_id: 7, status: "proyden", data_nachala: new Date("2026-04-10"), data_zaversheniya: new Date("2026-04-10"), komentariy: "Госпошлина оплачена" },
      { etap_id: 8, status: "proyden", data_nachala: new Date("2026-04-20"), data_zaversheniya: new Date("2026-04-20"), komentariy: "Теория сдана" },
      { etap_id: 9, status: "proyden", data_nachala: new Date("2026-05-04"), data_zaversheniya: new Date("2026-05-11"), komentariy: "Площадка и город сданы" },
      { etap_id: 10, status: "proyden", data_nachala: new Date("2026-05-12"), data_zaversheniya: new Date("2026-05-12"), komentariy: "Удостоверение выдано" }
    ],
    zachisleniya: [
      { gruppa_id: 4, instruktor_id: 5, chasov_teorii: 130, chasov_vozhdeniya: 56 }
    ]
  },
  {
    _id: 6, kandidat_id: 6, kategoriya_id: 3, sotrudnik_id: 2, status_id: 9,
    data_podachi: new Date("2026-01-07"), primechanie: "Приостановлено по заявлению кандидата",
    etapy: [
      { etap_id: 1, status: "proyden", data_nachala: new Date("2026-01-07"), data_zaversheniya: new Date("2026-01-07"), komentariy: "Документы приняты" },
      { etap_id: 2, status: "proyden", data_nachala: new Date("2026-01-08"), data_zaversheniya: new Date("2026-01-11"), komentariy: "Справка получена" },
      { etap_id: 3, status: "proyden", data_nachala: new Date("2026-01-12"), data_zaversheniya: new Date("2026-01-12"), komentariy: "Договор заключён" },
      { etap_id: 4, status: "proyden", data_nachala: new Date("2026-01-12"), data_zaversheniya: new Date("2026-03-09"), komentariy: "Теоретический курс пройден" },
      { etap_id: 5, status: "v_protsesse", data_nachala: new Date("2026-02-02"), data_zaversheniya: null, komentariy: "Приостановлено по заявлению кандидата" },
      { etap_id: 6, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, komentariy: null },
      { etap_id: 7, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, komentariy: null },
      { etap_id: 8, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, komentariy: null },
      { etap_id: 9, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, komentariy: null },
      { etap_id: 10, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, komentariy: null }
    ],
    zachisleniya: [
      { gruppa_id: 4, instruktor_id: 6, chasov_teorii: 130, chasov_vozhdeniya: 14 }
    ]
  },
  {
    _id: 7, kandidat_id: 7, kategoriya_id: 3, sotrudnik_id: 3, status_id: 7,
    data_podachi: new Date("2026-05-06"), primechanie: null,
    etapy: [
      { etap_id: 1, status: "proyden", data_nachala: new Date("2026-05-06"), data_zaversheniya: new Date("2026-05-06"), komentariy: "Документы приняты" },
      { etap_id: 2, status: "proyden", data_nachala: new Date("2026-05-07"), data_zaversheniya: new Date("2026-05-10"), komentariy: "Справка получена" },
      { etap_id: 3, status: "proyden", data_nachala: new Date("2026-05-11"), data_zaversheniya: new Date("2026-05-11"), komentariy: "Договор заключён" },
      { etap_id: 4, status: "proyden", data_nachala: new Date("2026-05-11"), data_zaversheniya: new Date("2026-07-06"), komentariy: "Теоретический курс пройден" },
      { etap_id: 5, status: "proyden", data_nachala: new Date("2026-06-01"), data_zaversheniya: new Date("2026-08-03"), komentariy: "Практический курс пройден" },
      { etap_id: 6, status: "proyden", data_nachala: new Date("2026-08-04"), data_zaversheniya: new Date("2026-08-06"), komentariy: "Свидетельство выдано" },
      { etap_id: 7, status: "proyden", data_nachala: new Date("2026-08-07"), data_zaversheniya: new Date("2026-08-07"), komentariy: "Госпошлина оплачена" },
      { etap_id: 8, status: "proyden", data_nachala: new Date("2026-08-17"), data_zaversheniya: new Date("2026-08-17"), komentariy: "Теория сдана" },
      { etap_id: 9, status: "proyden", data_nachala: new Date("2026-08-31"), data_zaversheniya: new Date("2026-09-07"), komentariy: "Площадка и город сданы" },
      { etap_id: 10, status: "proyden", data_nachala: new Date("2026-09-08"), data_zaversheniya: new Date("2026-09-08"), komentariy: "Удостоверение выдано" }
    ],
    zachisleniya: [
      { gruppa_id: 6, instruktor_id: 5, chasov_teorii: 130, chasov_vozhdeniya: 56 }
    ]
  },
  {
    _id: 8, kandidat_id: 8, kategoriya_id: 3, sotrudnik_id: 3, status_id: 5,
    data_podachi: new Date("2026-07-01"), primechanie: null,
    etapy: [
      { etap_id: 1, status: "proyden", data_nachala: new Date("2026-07-01"), data_zaversheniya: new Date("2026-07-01"), komentariy: "Документы приняты" },
      { etap_id: 2, status: "proyden", data_nachala: new Date("2026-07-02"), data_zaversheniya: new Date("2026-07-05"), komentariy: "Справка получена" },
      { etap_id: 3, status: "proyden", data_nachala: new Date("2026-07-06"), data_zaversheniya: new Date("2026-07-06"), komentariy: "Договор заключён" },
      { etap_id: 4, status: "proyden", data_nachala: new Date("2026-07-06"), data_zaversheniya: new Date("2026-08-31"), komentariy: "Теоретический курс пройден" },
      { etap_id: 5, status: "proyden", data_nachala: new Date("2026-07-27"), data_zaversheniya: new Date("2026-09-28"), komentariy: "Практический курс пройден" },
      { etap_id: 6, status: "proyden", data_nachala: new Date("2026-09-29"), data_zaversheniya: new Date("2026-10-01"), komentariy: "Свидетельство выдано" },
      { etap_id: 7, status: "proyden", data_nachala: new Date("2026-10-02"), data_zaversheniya: new Date("2026-10-02"), komentariy: "Госпошлина оплачена" },
      { etap_id: 8, status: "proyden", data_nachala: new Date("2026-10-12"), data_zaversheniya: new Date("2026-10-12"), komentariy: "Теория сдана" },
      { etap_id: 9, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, komentariy: "Запись на площадку на 2026-10-26" },
      { etap_id: 10, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, komentariy: null }
    ],
    zachisleniya: [
      { gruppa_id: 7, instruktor_id: 6, chasov_teorii: 130, chasov_vozhdeniya: 56 }
    ]
  },
  {
    _id: 9, kandidat_id: 9, kategoriya_id: 3, sotrudnik_id: 2, status_id: 3,
    data_podachi: new Date("2026-09-02"), primechanie: null,
    etapy: [
      { etap_id: 1, status: "proyden", data_nachala: new Date("2026-09-02"), data_zaversheniya: new Date("2026-09-02"), komentariy: "Документы приняты" },
      { etap_id: 2, status: "proyden", data_nachala: new Date("2026-09-03"), data_zaversheniya: new Date("2026-09-06"), komentariy: "Справка получена" },
      { etap_id: 3, status: "proyden", data_nachala: new Date("2026-09-07"), data_zaversheniya: new Date("2026-09-07"), komentariy: "Договор заключён" },
      { etap_id: 4, status: "v_protsesse", data_nachala: new Date("2026-09-07"), data_zaversheniya: null, komentariy: "Обучение идёт" },
      { etap_id: 5, status: "v_protsesse", data_nachala: new Date("2026-09-28"), data_zaversheniya: null, komentariy: "Обучение идёт" },
      { etap_id: 6, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, komentariy: null },
      { etap_id: 7, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, komentariy: null },
      { etap_id: 8, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, komentariy: null },
      { etap_id: 9, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, komentariy: null },
      { etap_id: 10, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, komentariy: null }
    ],
    zachisleniya: [
      { gruppa_id: 8, instruktor_id: 5, chasov_teorii: 90, chasov_vozhdeniya: 12 }
    ]
  },
  {
    _id: 10, kandidat_id: 10, kategoriya_id: 3, sotrudnik_id: 3, status_id: 2,
    data_podachi: new Date("2026-10-12"), primechanie: null,
    etapy: [
      { etap_id: 1, status: "proyden", data_nachala: new Date("2026-10-12"), data_zaversheniya: new Date("2026-10-12"), komentariy: "Документы приняты" },
      { etap_id: 2, status: "proyden", data_nachala: new Date("2026-10-13"), data_zaversheniya: new Date("2026-10-16"), komentariy: "Справка получена" },
      { etap_id: 3, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, komentariy: "Старт группы 2026-11-02" },
      { etap_id: 4, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, komentariy: null },
      { etap_id: 5, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, komentariy: null },
      { etap_id: 6, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, komentariy: null },
      { etap_id: 7, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, komentariy: null },
      { etap_id: 8, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, komentariy: null },
      { etap_id: 9, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, komentariy: null },
      { etap_id: 10, status: "ozhidaet", data_nachala: null, data_zaversheniya: null, komentariy: null }
    ],
    zachisleniya: [
      { gruppa_id: 9, instruktor_id: 6, chasov_teorii: 0, chasov_vozhdeniya: 0 }
    ]
  }
])

// ========== 13. EKZAMEN ==========
db.ekzamen.insertMany([
  { _id: 1, zayavlenie_id: 1, ekzamenator_id: 4, tip_ekzamena: "vnutrenniy", nomer_popytki: 1, data_ekzamena: new Date("2025-04-08T10:00:00"), kolvo_oshibok: 1, sdan: true },
  { _id: 2, zayavlenie_id: 1, ekzamenator_id: 7, tip_ekzamena: "teoriya", nomer_popytki: 1, data_ekzamena: new Date("2025-04-21T10:00:00"), kolvo_oshibok: 0, sdan: true },
  { _id: 3, zayavlenie_id: 1, ekzamenator_id: 8, tip_ekzamena: "ploshchadka", nomer_popytki: 1, data_ekzamena: new Date("2025-05-05T11:00:00"), kolvo_oshibok: 0, sdan: true },
  { _id: 4, zayavlenie_id: 1, ekzamenator_id: 8, tip_ekzamena: "gorod", nomer_popytki: 1, data_ekzamena: new Date("2025-05-12T11:00:00"), kolvo_oshibok: 2, sdan: true },
  { _id: 5, zayavlenie_id: 2, ekzamenator_id: 4, tip_ekzamena: "vnutrenniy", nomer_popytki: 1, data_ekzamena: new Date("2025-04-08T10:00:00"), kolvo_oshibok: 0, sdan: true },
  { _id: 6, zayavlenie_id: 2, ekzamenator_id: 7, tip_ekzamena: "teoriya", nomer_popytki: 1, data_ekzamena: new Date("2025-04-21T10:00:00"), kolvo_oshibok: 1, sdan: true },
  { _id: 7, zayavlenie_id: 2, ekzamenator_id: 8, tip_ekzamena: "ploshchadka", nomer_popytki: 1, data_ekzamena: new Date("2025-05-05T11:00:00"), kolvo_oshibok: 1, sdan: true },
  { _id: 8, zayavlenie_id: 2, ekzamenator_id: 8, tip_ekzamena: "gorod", nomer_popytki: 1, data_ekzamena: new Date("2025-05-12T11:00:00"), kolvo_oshibok: 1, sdan: true },
  { _id: 9, zayavlenie_id: 3, ekzamenator_id: 4, tip_ekzamena: "vnutrenniy", nomer_popytki: 1, data_ekzamena: new Date("2025-08-05T10:00:00"), kolvo_oshibok: 2, sdan: true },
  { _id: 10, zayavlenie_id: 3, ekzamenator_id: 7, tip_ekzamena: "teoriya", nomer_popytki: 1, data_ekzamena: new Date("2025-08-18T10:00:00"), kolvo_oshibok: 4, sdan: false },
  { _id: 11, zayavlenie_id: 3, ekzamenator_id: 7, tip_ekzamena: "teoriya", nomer_popytki: 2, data_ekzamena: new Date("2025-08-25T10:00:00"), kolvo_oshibok: 1, sdan: true },
  { _id: 12, zayavlenie_id: 3, ekzamenator_id: 8, tip_ekzamena: "ploshchadka", nomer_popytki: 1, data_ekzamena: new Date("2025-09-01T11:00:00"), kolvo_oshibok: 0, sdan: true },
  { _id: 13, zayavlenie_id: 3, ekzamenator_id: 8, tip_ekzamena: "gorod", nomer_popytki: 1, data_ekzamena: new Date("2025-09-08T11:00:00"), kolvo_oshibok: 3, sdan: true },
  { _id: 14, zayavlenie_id: 4, ekzamenator_id: 4, tip_ekzamena: "vnutrenniy", nomer_popytki: 1, data_ekzamena: new Date("2025-08-05T10:00:00"), kolvo_oshibok: 0, sdan: true },
  { _id: 15, zayavlenie_id: 4, ekzamenator_id: 7, tip_ekzamena: "teoriya", nomer_popytki: 1, data_ekzamena: new Date("2025-08-18T10:00:00"), kolvo_oshibok: 0, sdan: true },
  { _id: 16, zayavlenie_id: 4, ekzamenator_id: 8, tip_ekzamena: "ploshchadka", nomer_popytki: 1, data_ekzamena: new Date("2025-09-01T11:00:00"), kolvo_oshibok: 0, sdan: true },
  { _id: 17, zayavlenie_id: 4, ekzamenator_id: 8, tip_ekzamena: "gorod", nomer_popytki: 1, data_ekzamena: new Date("2025-09-08T11:00:00"), kolvo_oshibok: 0, sdan: true },
  { _id: 18, zayavlenie_id: 5, ekzamenator_id: 4, tip_ekzamena: "vnutrenniy", nomer_popytki: 1, data_ekzamena: new Date("2026-04-07T10:00:00"), kolvo_oshibok: 1, sdan: true },
  { _id: 19, zayavlenie_id: 5, ekzamenator_id: 7, tip_ekzamena: "teoriya", nomer_popytki: 1, data_ekzamena: new Date("2026-04-20T10:00:00"), kolvo_oshibok: 2, sdan: true },
  { _id: 20, zayavlenie_id: 5, ekzamenator_id: 8, tip_ekzamena: "ploshchadka", nomer_popytki: 1, data_ekzamena: new Date("2026-05-04T11:00:00"), kolvo_oshibok: 1, sdan: true },
  { _id: 21, zayavlenie_id: 5, ekzamenator_id: 8, tip_ekzamena: "gorod", nomer_popytki: 1, data_ekzamena: new Date("2026-05-11T11:00:00"), kolvo_oshibok: 2, sdan: true },
  { _id: 22, zayavlenie_id: 7, ekzamenator_id: 4, tip_ekzamena: "vnutrenniy", nomer_popytki: 1, data_ekzamena: new Date("2026-08-04T10:00:00"), kolvo_oshibok: 0, sdan: true },
  { _id: 23, zayavlenie_id: 7, ekzamenator_id: 7, tip_ekzamena: "teoriya", nomer_popytki: 1, data_ekzamena: new Date("2026-08-17T10:00:00"), kolvo_oshibok: 1, sdan: true },
  { _id: 24, zayavlenie_id: 7, ekzamenator_id: 8, tip_ekzamena: "ploshchadka", nomer_popytki: 1, data_ekzamena: new Date("2026-08-31T11:00:00"), kolvo_oshibok: 0, sdan: true },
  { _id: 25, zayavlenie_id: 7, ekzamenator_id: 8, tip_ekzamena: "gorod", nomer_popytki: 1, data_ekzamena: new Date("2026-09-07T11:00:00"), kolvo_oshibok: 1, sdan: true },
  { _id: 26, zayavlenie_id: 8, ekzamenator_id: 4, tip_ekzamena: "vnutrenniy", nomer_popytki: 1, data_ekzamena: new Date("2026-09-29T10:00:00"), kolvo_oshibok: 1, sdan: true },
  { _id: 27, zayavlenie_id: 8, ekzamenator_id: 7, tip_ekzamena: "teoriya", nomer_popytki: 1, data_ekzamena: new Date("2026-10-12T10:00:00"), kolvo_oshibok: 0, sdan: true }
])

// ========== 14. PLATEZH ==========
db.platezh.insertMany([
  { _id: 1, zayavlenie_id: 1, sposob_id: 2, summa: 38000.00, data_platezha: new Date("2025-01-08T10:05:00"), naznachenie: "obuchenie" },
  { _id: 2, zayavlenie_id: 2, sposob_id: 3, summa: 19000.00, data_platezha: new Date("2025-01-08T10:05:00"), naznachenie: "obuchenie" },
  { _id: 3, zayavlenie_id: 2, sposob_id: 3, summa: 19000.00, data_platezha: new Date("2025-02-22T10:05:00"), naznachenie: "obuchenie" },
  { _id: 4, zayavlenie_id: 1, sposob_id: 7, summa: 2000.00, data_platezha: new Date("2025-04-11T12:00:00"), naznachenie: "goshposhlina" },
  { _id: 5, zayavlenie_id: 2, sposob_id: 7, summa: 2000.00, data_platezha: new Date("2025-04-11T12:00:00"), naznachenie: "goshposhlina" },
  { _id: 6, zayavlenie_id: 3, sposob_id: 1, summa: 38000.00, data_platezha: new Date("2025-05-07T10:05:00"), naznachenie: "obuchenie" },
  { _id: 7, zayavlenie_id: 4, sposob_id: 2, summa: 38000.00, data_platezha: new Date("2025-05-07T10:05:00"), naznachenie: "obuchenie" },
  { _id: 8, zayavlenie_id: 3, sposob_id: 7, summa: 2000.00, data_platezha: new Date("2025-08-08T12:00:00"), naznachenie: "goshposhlina" },
  { _id: 9, zayavlenie_id: 4, sposob_id: 7, summa: 2000.00, data_platezha: new Date("2025-08-08T12:00:00"), naznachenie: "goshposhlina" },
  { _id: 10, zayavlenie_id: 3, sposob_id: 7, summa: 400.00, data_platezha: new Date("2025-08-24T12:00:00"), naznachenie: "peresdacha" },
  { _id: 11, zayavlenie_id: 5, sposob_id: 3, summa: 40000.00, data_platezha: new Date("2026-01-06T10:05:00"), naznachenie: "obuchenie" },
  { _id: 12, zayavlenie_id: 6, sposob_id: 2, summa: 20000.00, data_platezha: new Date("2026-01-07T10:05:00"), naznachenie: "obuchenie" },
  { _id: 13, zayavlenie_id: 5, sposob_id: 7, summa: 2000.00, data_platezha: new Date("2026-04-10T12:00:00"), naznachenie: "goshposhlina" },
  { _id: 14, zayavlenie_id: 7, sposob_id: 4, summa: 40000.00, data_platezha: new Date("2026-05-06T10:05:00"), naznachenie: "obuchenie" },
  { _id: 15, zayavlenie_id: 8, sposob_id: 2, summa: 40000.00, data_platezha: new Date("2026-07-01T10:05:00"), naznachenie: "obuchenie" },
  { _id: 16, zayavlenie_id: 7, sposob_id: 7, summa: 2000.00, data_platezha: new Date("2026-08-07T12:00:00"), naznachenie: "goshposhlina" },
  { _id: 17, zayavlenie_id: 9, sposob_id: 3, summa: 20000.00, data_platezha: new Date("2026-09-02T10:05:00"), naznachenie: "obuchenie" },
  { _id: 18, zayavlenie_id: 9, sposob_id: 3, summa: 20000.00, data_platezha: new Date("2026-10-02T10:05:00"), naznachenie: "obuchenie" },
  { _id: 19, zayavlenie_id: 8, sposob_id: 7, summa: 2000.00, data_platezha: new Date("2026-10-02T12:00:00"), naznachenie: "goshposhlina" },
  { _id: 20, zayavlenie_id: 10, sposob_id: 5, summa: 40000.00, data_platezha: new Date("2026-10-12T10:05:00"), naznachenie: "obuchenie" }
])

// ========== 15. VODITELSKOE_UDOSTOVERENIE ==========
db.voditelskoe_udostoverenie.insertMany([
  { _id: 1, zayavlenie_id: 1, nomer: "99 25 100001", data_vydachi: new Date("2025-05-13"), data_okonchaniya: new Date("2035-05-13"), podrazdelenie: "МРЭО ГИБДД №1 ГУ МВД России по г. Москве" },
  { _id: 2, zayavlenie_id: 2, nomer: "99 25 100002", data_vydachi: new Date("2025-05-13"), data_okonchaniya: new Date("2035-05-13"), podrazdelenie: "МРЭО ГИБДД №2 ГУ МВД России по г. Москве" },
  { _id: 3, zayavlenie_id: 3, nomer: "99 25 100003", data_vydachi: new Date("2025-09-09"), data_okonchaniya: new Date("2035-09-09"), podrazdelenie: "МРЭО ГИБДД №3 ГУ МВД России по г. Москве" },
  { _id: 4, zayavlenie_id: 4, nomer: "99 25 100004", data_vydachi: new Date("2025-09-09"), data_okonchaniya: new Date("2035-09-09"), podrazdelenie: "МРЭО ГИБДД №1 ГУ МВД России по г. Москве" },
  { _id: 5, zayavlenie_id: 5, nomer: "99 26 100005", data_vydachi: new Date("2026-05-12"), data_okonchaniya: new Date("2036-05-12"), podrazdelenie: "МРЭО ГИБДД №2 ГУ МВД России по г. Москве" },
  { _id: 6, zayavlenie_id: 7, nomer: "99 26 100007", data_vydachi: new Date("2026-09-08"), data_okonchaniya: new Date("2036-09-08"), podrazdelenie: "МРЭО ГИБДД №1 ГУ МВД России по г. Москве" }
])

print("========== ИТОГ ==========")
db.getCollectionNames().forEach(function(c) {
  print(c + ": " + db[c].countDocuments());
})
print("==========================")
