-- ============================================================================
--  Лабораторная работа №2. Хранилища данных. Вариант 6.
--  Тема: «Система учебного графика дисциплин факультета».
--  Часть 1. Модель базы данных в ТРЕТЬЕЙ НОРМАЛЬНОЙ ФОРМЕ (3НФ).
--
--  СУБД: PostgreSQL 18.4 (Windows).
--  Схема  : nf3
--  Назначение модели — оперативное (OLTP) ведение справочников факультета
--  и расписания занятий: кафедры, корпуса и аудитории, направления
--  подготовки, группы, преподаватели, дисциплины, занятия.
--
--  Признаки третьей нормальной формы:
--   1НФ — все атрибуты атомарны (нет повторяющихся групп, массивов);
--   2НФ — первичные ключи таблиц одноатомны, нет частичных зависимостей
--         (составные ключи не используются);
--   3НФ — нет транзитивных зависимостей неключевых атрибутов от
--         первичного ключа: справочники вынесены в отдельные таблицы
--         (Корпус — отдельно от Аудитории, Кафедра — отдельно от
--         Преподавателя/Дисциплины/Группы, Специальность — отдельно
--         от Группы). Каждый неключевой атрибут зависит только от PK.
-- ============================================================================

\echo '=== [3НФ] Создание схемы nf3 ==='
DROP SCHEMA IF EXISTS nf3 CASCADE;
CREATE SCHEMA nf3;
SET search_path TO nf3, public;

-- ----------------------------------------------------------------------------
-- Справочник кафедр факультета.
-- Бизнес-ключ — код кафедры («ИУ7», «ИД7» …), он неизменен и уникален.
-- ----------------------------------------------------------------------------
CREATE TABLE nf3.kafedra (
    kafedra_id  integer      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    kod_kafedry varchar(10)  NOT NULL UNIQUE,          -- код (шифр) кафедры
    nazvanie    varchar(150) NOT NULL,                 -- полное название кафедры
    telefon     varchar(20)                           -- телефон кафедры
);

COMMENT ON TABLE  nf3.kafedra              IS 'Справочник кафедр факультета';
COMMENT ON COLUMN nf3.kafedra.kafedra_id   IS 'Суррогатный первичный ключ';
COMMENT ON COLUMN nf3.kafedra.kod_kafedry  IS 'Бизнес-ключ: код кафедры (напр. ИУ7)';
COMMENT ON COLUMN nf3.kafedra.nazvanie     IS 'Полное наименование кафедры';
COMMENT ON COLUMN nf3.kafedra.telefon      IS 'Контактный телефон';

-- ----------------------------------------------------------------------------
-- Корпуса. Выделены в отдельную справочную таблицу, чтобы устранить
-- транзитивную зависимость «Аудитория → Корпус → Адрес» (требование 3НФ).
-- ----------------------------------------------------------------------------
CREATE TABLE nf3.korpus (
    korpus_id integer     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nazvanie  varchar(40) NOT NULL UNIQUE,             -- «Корпус А»
    adres     varchar(160) NOT NULL                    -- почтовый адрес корпуса
);

COMMENT ON TABLE  nf3.korpus        IS 'Справочник корпусов учебного корпуса (3НФ: устранена транзитивная зависимость Аудитория→Корпус→Адрес)';
COMMENT ON COLUMN nf3.korpus.adres  IS 'Адрес корпуса (зависит от корпуса, а не от аудитории)';

-- ----------------------------------------------------------------------------
-- Аудитории. Зависят только от PK; сведения о корпусе — по внешнему ключу.
-- ----------------------------------------------------------------------------
CREATE TABLE nf3.auditoriya (
    auditoriya_id integer     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nomer         varchar(10) NOT NULL,                -- номер аудитории
    tip           varchar(40) NOT NULL
                  CHECK (tip IN ('лекционная','компьютерный класс','аудитория для практик','лаборатория')),
    vmestimost    integer     NOT NULL CHECK (vmestimost > 0),
    korpus_id     integer     NOT NULL REFERENCES nf3.korpus(korpus_id),
    UNIQUE (korpus_id, nomer)                          -- номер уникален внутри корпуса
);

COMMENT ON TABLE  nf3.auditoriya IS 'Аудитории факультета (тип, вместимость, корпус)';

-- ----------------------------------------------------------------------------
-- Направления подготовки (специальности). Бизнес-ключ — кодификатор
-- направления по классификатору Минобрнауки.
-- ----------------------------------------------------------------------------
CREATE TABLE nf3.specialnost (
    specialnost_id integer      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    kodifikator    varchar(20)  NOT NULL UNIQUE,       -- шифр, напр. 09.03.04
    nazvanie       varchar(200) NOT NULL,
    uroven         varchar(20)  NOT NULL
                   CHECK (uroven IN ('бакалавриат','магистратура','специалитет'))
);

COMMENT ON TABLE nf3.specialnost IS 'Направления подготовки (специальности)';

-- ----------------------------------------------------------------------------
-- Учебные группы. Все сведения о направлении и выпускающей кафедре —
-- только по внешнему ключу (отсутствуют транзитивные зависимости).
-- ----------------------------------------------------------------------------
CREATE TABLE nf3.gruppa (
    gruppa_id       integer     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nazvanie        varchar(20) NOT NULL UNIQUE,       -- «223-322»
    kurs            smallint    NOT NULL CHECK (kurs BETWEEN 1 AND 6),
    god_postupleniya smallint   NOT NULL CHECK (god_postupleniya >= 2000),
    specialnost_id  integer     NOT NULL REFERENCES nf3.specialnost(specialnost_id),
    kafedra_id      integer     NOT NULL REFERENCES nf3.kafedra(kafedra_id)  -- выпускающая
);

COMMENT ON COLUMN nf3.gruppa.kafedra_id IS 'Выпускающая кафедра (FK, а не атрибут — требование 3НФ)';

-- ----------------------------------------------------------------------------
-- Преподаватели. Бизнес-ключ — табельный номер (уникален, неизменен).
-- Кафедра — только внешний ключ.
-- ----------------------------------------------------------------------------
CREATE TABLE nf3.prepodavatel (
    prepodavatel_id integer     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tab_nomer       varchar(12) NOT NULL UNIQUE,       -- табельный номер
    fio             varchar(120) NOT NULL,             -- фамилия И.О.Отч.
    dolzhnost       varchar(60)  NOT NULL,
    email           varchar(80)  NOT NULL UNIQUE,
    kafedra_id      integer      NOT NULL REFERENCES nf3.kafedra(kafedra_id)
);

COMMENT ON COLUMN nf3.prepodavatel.tab_nomer IS 'Бизнес-ключ: табельный номер преподавателя';

-- ----------------------------------------------------------------------------
-- Дисциплины учебного плана. Бизнес-ключ — кодификатор дисциплины.
-- ----------------------------------------------------------------------------
CREATE TABLE nf3.disciplina (
    disciplina_id integer      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    shifr         varchar(20)  NOT NULL UNIQUE,        -- кодификатор дисциплины
    nazvanie      varchar(200) NOT NULL,
    semestr       smallint     NOT NULL CHECK (semestr BETWEEN 1 AND 12),
    chasy_lek     smallint     NOT NULL DEFAULT 0 CHECK (chasy_lek  >= 0),
    chasy_prakt   smallint     NOT NULL DEFAULT 0 CHECK (chasy_prakt >= 0),
    chasy_lab     smallint     NOT NULL DEFAULT 0 CHECK (chasy_lab  >= 0),
    kafedra_id    integer      NOT NULL REFERENCES nf3.kafedra(kafedra_id)   -- ведущая кафедра
);

COMMENT ON TABLE nf3.disciplina IS 'Дисциплины учебного плана с объемом часов по видам занятий';

-- ----------------------------------------------------------------------------
-- Занятия учебного графика: связь «многие-ко-многим» между группой,
-- дисциплиной, преподавателем и аудиторией с атрибутами слота расписания.
-- (Промежуточная таблица 3НФ; все атрибуты зависят от PK целиком.)
-- ----------------------------------------------------------------------------
CREATE TABLE nf3.zanyatie (
    zanyatie_id    integer     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    disciplina_id  integer     NOT NULL REFERENCES nf3.disciplina(disciplina_id),
    gruppa_id      integer     NOT NULL REFERENCES nf3.gruppa(gruppa_id),
    prepodavatel_id integer    NOT NULL REFERENCES nf3.prepodavatel(prepodavatel_id),
    auditoriya_id  integer     NOT NULL REFERENCES nf3.auditoriya(auditoriya_id),
    den_nedeli     smallint    NOT NULL CHECK (den_nedeli BETWEEN 1 AND 7),  -- 1=понедельник
    para           smallint    NOT NULL CHECK (para BETWEEN 1 AND 6),
    nedelya        varchar(10) NOT NULL DEFAULT 'все'
                   CHECK (nedelya IN ('все','четная','нечетная')),
    tip_zanyatiya  varchar(15) NOT NULL
                   CHECK (tip_zanyatiya IN ('лекция','практика','лабораторная')),
    -- один и тот же слот не может быть занят дважды одной группой
    UNIQUE (gruppa_id, den_nedeli, para, nedelya)
);

COMMENT ON TABLE  nf3.zanyatie                IS 'Учебный график: занятие = группа × дисциплина × преподаватель × аудитория × слот';
COMMENT ON COLUMN nf3.zanyatie.den_nedeli     IS 'День недели: 1 — понедельник … 7 — воскресенье';
COMMENT ON COLUMN nf3.zanyatie.nedelya        IS 'Четность недели (все / четная / нечетная)';
COMMENT ON COLUMN nf3.zanyatie.tip_zanyatiya  IS 'Вид занятия: лекция, практика, лабораторная';

-- ----------------------------------------------------------------------------
-- Индексы для типовых запросов учебного графика
-- ----------------------------------------------------------------------------
CREATE INDEX idx_zanyatie_gruppa  ON nf3.zanyatie (gruppa_id, den_nedeli, para);
CREATE INDEX idx_zanyatie_prepod  ON nf3.zanyatie (prepodavatel_id);
CREATE INDEX idx_zanyatie_auditor ON nf3.zanyatie (auditoriya_id);
CREATE INDEX idx_gruppa_special   ON nf3.gruppa   (specialnost_id);

\echo '=== [3НФ] Таблицы схемы nf3 созданы ==='
\dt nf3.*
