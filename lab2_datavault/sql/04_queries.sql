-- ============================================================================
--  Лабораторная работа №2. Вариант 6.
--  Часть 4. Типовые запросы к обеим моделям (демонстрация работоспособности).
--  Сопоставление результатов показывает эквивалентность моделей 3НФ и
--  Data Vault при одинаковых исходных данных.
-- ============================================================================

-- ---------------------------------------------------------------------------
-- ЗАПРОС 1 (3НФ). Учебный график группы 223-322:
-- день недели, пара, дисциплина, вид занятия, преподаватель, аудитория (с корпусом).
-- ---------------------------------------------------------------------------
SET search_path TO nf3, public;
SELECT d.nazvanie        AS disciplina,
       z.tip_zanyatiya,
       CASE z.den_nedeli WHEN 1 THEN 'пн' WHEN 2 THEN 'вт' WHEN 3 THEN 'ср'
                         WHEN 4 THEN 'чт' WHEN 5 THEN 'пт' END AS den,
       z.para,
       z.nedelya,
       p.fio             AS prepodavatel,
       k.nazvanie || ', ауд. ' || a.nomer AS auditoriya
FROM nf3.zanyatie z
JOIN nf3.disciplina  d ON d.disciplina_id  = z.disciplina_id
JOIN nf3.gruppa      g ON g.gruppa_id      = z.gruppa_id
JOIN nf3.prepodavatel p ON p.prepodavatel_id = z.prepodavatel_id
JOIN nf3.auditoriya  a ON a.auditoriya_id  = z.auditoriya_id
JOIN nf3.korpus      k ON k.korpus_id      = a.korpus_id
WHERE g.nazvanie = '223-322'
ORDER BY z.den_nedeli, z.para;

-- ---------------------------------------------------------------------------
-- ЗАПРОС 2 (3НФ). Нагрузка преподавателей: число занятий и суммарные часы.
-- ---------------------------------------------------------------------------
SELECT p.fio,
       count(*)                                        AS zanyatiy,
       count(*) * 2                                    AS chasov,   -- 1 занятие = 2 ак. часа
       count(*) FILTER (WHERE z.tip_zanyatiya = 'лекция') AS lekciy
FROM nf3.zanyatie z
JOIN nf3.prepodavatel p ON p.prepodavatel_id = z.prepodavatel_id
GROUP BY p.fio
ORDER BY zanyatiy DESC;

-- ---------------------------------------------------------------------------
-- ЗАПРОС 3 (3НФ). Какие группы и в каких аудиториях занимаются
-- в понедельник на первой паре (проверка ограничения уникальности слота).
-- ---------------------------------------------------------------------------
SELECT g.nazvanie AS gruppa, d.nazvanie AS disciplina, a.nomer, k.nazvanie AS korpus
FROM nf3.zanyatie z
JOIN nf3.gruppa g     ON g.gruppa_id = z.gruppa_id
JOIN nf3.disciplina d ON d.disciplina_id = z.disciplina_id
JOIN nf3.auditoriya a ON a.auditoriya_id = z.auditoriya_id
JOIN nf3.korpus k     ON k.korpus_id = a.korpus_id
WHERE z.den_nedeli = 1 AND z.para = 1
ORDER BY g.nazvanie;

-- ===========================================================================
--  Те же выборки в модели DATA VAULT (соединения через хэш-ключи).
-- ===========================================================================
SET search_path TO dv, public;

-- ---------------------------------------------------------------------------
-- ЗАПРОС 4 (Data Vault). Учебный граф группы 223-322 «собирается»
-- из хаба группы, ссылки-события, хабов дисциплины/преподавателя/аудитории
-- и сателлитов контекста.
-- ---------------------------------------------------------------------------
SELECT sd.nazvanie       AS disciplina,
       sz.tip_zanyatiya,
       CASE lz.den_nedeli WHEN 1 THEN 'пн' WHEN 2 THEN 'вт' WHEN 3 THEN 'ср'
                          WHEN 4 THEN 'чт' WHEN 5 THEN 'пт' END AS den,
       lz.para,
       lz.nedelya,
       sp.fio            AS prepodavatel,
       sa.korpus || ', ауд. ' || sa.nomer AS auditoriya
FROM dv.link_zanyatie lz
JOIN dv.hub_gruppa        hg ON hg.hash_gruppa       = lz.hash_gruppa
JOIN dv.hub_disciplina    hd ON hd.hash_disciplina   = lz.hash_disciplina
JOIN dv.hub_prepodavatel  hp ON hp.hash_prepodavatel = lz.hash_prepodavatel
JOIN dv.hub_auditoriya    ha ON ha.hash_auditoriya   = lz.hash_auditoriya
JOIN dv.sat_disciplina    sd ON sd.hash_disciplina   = hd.hash_disciplina
                            AND sd.load_end_date IS NULL          -- текущая версия
JOIN dv.sat_prepodavatel  sp ON sp.hash_prepodavatel = hp.hash_prepodavatel
                            AND sp.load_end_date IS NULL
JOIN dv.sat_auditoriya    sa ON sa.hash_auditoriya   = ha.hash_auditoriya
                            AND sa.load_end_date IS NULL
JOIN dv.sat_zanyatie      sz ON sz.hash_link         = lz.hash_link
                            AND sz.load_end_date IS NULL
WHERE hg.nazvanie = '223-322'
ORDER BY lz.den_nedeli, lz.para;

-- ---------------------------------------------------------------------------
-- ЗАПРОС 5 (Data Vault). Кто ведёт дисциплину «Хранилища данных»
-- и к какой кафедре она относится: хаб → ссылка → сателлит.
-- ---------------------------------------------------------------------------
SELECT sd.nazvanie AS disciplina,
       sp.fio      AS prepodavatel,
       sp.dolzhnost,
       sk.nazvanie AS kafedra
FROM dv.hub_disciplina hd
JOIN dv.sat_disciplina       sd ON sd.hash_disciplina  = hd.hash_disciplina
                               AND sd.load_end_date IS NULL
JOIN dv.link_zanyatie        lz ON lz.hash_disciplina  = hd.hash_disciplina
JOIN dv.sat_prepodavatel     sp ON sp.hash_prepodavatel = lz.hash_prepodavatel
                               AND sp.load_end_date IS NULL
JOIN dv.link_disciplina_kafedra lk ON lk.hash_disciplina = hd.hash_disciplina
JOIN dv.sat_kafedra          sk ON sk.hash_kafedra      = lk.hash_kafedra
                               AND sk.load_end_date IS NULL
WHERE hd.shifr = 'Б1.В.12'
GROUP BY sd.nazvanie, sp.fio, sp.dolzhnost, sk.nazvanie;

-- ---------------------------------------------------------------------------
-- ЗАПРОС 6 (Data Vault). Хранение ИСТОРИИ изменений в сателлите:
-- преподавателю 10743 присвоена новая должность. Старая запись закрывается
-- (load_end_date), добавляется новая версия. Обе версии читаются.
-- ---------------------------------------------------------------------------
UPDATE dv.sat_prepodavatel
SET load_end_date = now()
WHERE hash_prepodavatel = md5('10743') AND load_end_date IS NULL;

INSERT INTO dv.sat_prepodavatel (hash_prepodavatel, fio, dolzhnost, email, record_source)
VALUES (md5('10743'), 'Гаврилов Д.М.', 'заведующий кафедрой', 'gavrilov@students.ru', 'kadry_prepodavatelei');

SELECT fio, dolzhnost,
       to_char(load_date,     'DD.MM.YYYY HH24:MI:SS') AS zagruzheno,
       coalesce(to_char(load_end_date, 'DD.MM.YYYY HH24:MI:SS'), '(текущая версия)') AS okonchenie
FROM dv.sat_prepodavatel
WHERE hash_prepodavatel = md5('10743')
ORDER BY load_date;

-- ---------------------------------------------------------------------------
-- ЗАПРОС 7. Сверка двух моделей: количество занятий по группам
-- должно совпадать.
-- ---------------------------------------------------------------------------
SELECT nf3_gruppa, nf3_zanyatiya, dv_zanyatiya,
       CASE WHEN nf3_zanyatiya = dv_zanyatiya THEN 'OK' ELSE 'РАСХОЖДЕНИЕ' END AS sravnenie
FROM (
    SELECT g.nazvanie AS nf3_gruppa, count(*) AS nf3_zanyatiya
    FROM nf3.zanyatie z JOIN nf3.gruppa g ON g.gruppa_id = z.gruppa_id
    GROUP BY g.nazvanie) a
FULL JOIN (
    SELECT hg.nazvanie AS dv_gruppa, count(*) AS dv_zanyatiya
    FROM dv.link_zanyatie lz JOIN dv.hub_gruppa hg ON hg.hash_gruppa = lz.hash_gruppa
    GROUP BY hg.nazvanie) b ON a.nf3_gruppa = b.dv_gruppa
ORDER BY 1;
