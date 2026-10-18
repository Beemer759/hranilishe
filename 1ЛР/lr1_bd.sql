SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `voditelskie_prava`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;
USE `voditelskie_prava`;

-- ---------------------------------------------------------------
-- Справочники
-- ---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `kategoriya_prav` (
  `id`              INT NOT NULL AUTO_INCREMENT,
  `kod`             VARCHAR(5) NOT NULL,
  `nazvanie`        VARCHAR(100) NOT NULL,
  `min_vozrast`     TINYINT NOT NULL,
  `opisanie`        VARCHAR(255) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `kategoriya_prav_kod_UNIQUE` (`kod` ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `tip_dokumenta` (
  `id`       INT NOT NULL AUTO_INCREMENT,
  `nazvanie` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `tip_dokumenta_nazvanie_UNIQUE` (`nazvanie` ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `status_zayavleniya` (
  `id`       INT NOT NULL AUTO_INCREMENT,
  `nazvanie` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `status_zayavleniya_nazvanie_UNIQUE` (`nazvanie` ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sposob_oplaty` (
  `id`       INT NOT NULL AUTO_INCREMENT,
  `nazvanie` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `sposob_oplaty_nazvanie_UNIQUE` (`nazvanie` ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `dolzhnost` (
  `id`       INT NOT NULL AUTO_INCREMENT,
  `nazvanie` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `dolzhnost_nazvanie_UNIQUE` (`nazvanie` ASC) VISIBLE
) ENGINE = InnoDB;

-- ---------------------------------------------------------------
-- Описание порядка получения прав (шаги процедуры)
-- ---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `etap_poryadka` (
  `id`            INT NOT NULL AUTO_INCREMENT,
  `kategoriya_id` INT NOT NULL,
  `nomer_shaga`   TINYINT NOT NULL,
  `nazvanie`      VARCHAR(100) NOT NULL,
  `opisanie`      VARCHAR(500) NULL,
  `organizatsiya` VARCHAR(100) NULL,
  `obyazatelnyy`  TINYINT(1) NOT NULL DEFAULT 1,
  `srok_dney`     SMALLINT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `etap_kategoriya_shag_UNIQUE` (`kategoriya_id` ASC, `nomer_shaga` ASC) VISIBLE,
  CONSTRAINT `fk_etap_kategoriya`
    FOREIGN KEY (`kategoriya_id`) REFERENCES `kategoriya_prav` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `etap_dokument` (
  `etap_id`         INT NOT NULL,
  `tip_dokumenta_id` INT NOT NULL,
  `obyazatelnyy`    TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`etap_id`, `tip_dokumenta_id`),
  INDEX `fk_etap_dokument_tip_idx` (`tip_dokumenta_id` ASC) VISIBLE,
  CONSTRAINT `fk_etap_dokument_etap`
    FOREIGN KEY (`etap_id`) REFERENCES `etap_poryadka` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_etap_dokument_tip`
    FOREIGN KEY (`tip_dokumenta_id`) REFERENCES `tip_dokumenta` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

-- ---------------------------------------------------------------
-- Кандидаты и сотрудники
-- ---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `kandidat` (
  `id`                INT NOT NULL AUTO_INCREMENT,
  `imya`              VARCHAR(45) NOT NULL,
  `familiya`          VARCHAR(45) NOT NULL,
  `otchestvo`         VARCHAR(45) NULL,
  `data_rozhdeniya`   DATE NOT NULL,
  `telefon`           VARCHAR(15) NOT NULL,
  `email`             VARCHAR(60) NULL,
  `adres`             VARCHAR(255) NULL,
  `data_registratsii` DATE NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `kandidat_telefon_UNIQUE` (`telefon` ASC) VISIBLE,
  UNIQUE INDEX `kandidat_email_UNIQUE`   (`email` ASC)   VISIBLE,
  INDEX `kandidat_familiya_idx` (`familiya` ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `dokument` (
  `id`               INT NOT NULL AUTO_INCREMENT,
  `kandidat_id`      INT NOT NULL,
  `tip_dokumenta_id` INT NOT NULL,
  `seriya`           VARCHAR(10) NULL,
  `nomer`            VARCHAR(20) NOT NULL,
  `kem_vydan`        VARCHAR(255) NULL,
  `data_vydachi`     DATE NULL,
  `data_okonchaniya` DATE NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `dokument_nomer_UNIQUE` (`tip_dokumenta_id` ASC, `seriya` ASC, `nomer` ASC) VISIBLE,
  INDEX `fk_dokument_kandidat_idx` (`kandidat_id` ASC) VISIBLE,
  CONSTRAINT `fk_dokument_kandidat`
    FOREIGN KEY (`kandidat_id`) REFERENCES `kandidat` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_dokument_tip`
    FOREIGN KEY (`tip_dokumenta_id`) REFERENCES `tip_dokumenta` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sotrudnik` (
  `id`           INT NOT NULL AUTO_INCREMENT,
  `imya`         VARCHAR(45) NOT NULL,
  `familiya`     VARCHAR(45) NOT NULL,
  `otchestvo`    VARCHAR(45) NULL,
  `telefon`      VARCHAR(15) NOT NULL,
  `email`        VARCHAR(60) NULL,
  `dolzhnost_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `sotrudnik_telefon_UNIQUE` (`telefon` ASC) VISIBLE,
  INDEX `fk_sotrudnik_dolzhnost_idx` (`dolzhnost_id` ASC) VISIBLE,
  CONSTRAINT `fk_sotrudnik_dolzhnost`
    FOREIGN KEY (`dolzhnost_id`) REFERENCES `dolzhnost` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

-- ---------------------------------------------------------------
-- Заявление и прохождение этапов
-- ---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `zayavlenie` (
  `id`            INT NOT NULL AUTO_INCREMENT,
  `kandidat_id`   INT NOT NULL,
  `kategoriya_id` INT NOT NULL,
  `sotrudnik_id`  INT NOT NULL,
  `status_id`     INT NOT NULL,
  `data_podachi`  DATE NOT NULL,
  `primechanie`   VARCHAR(255) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_zayavlenie_kandidat_idx`  (`kandidat_id` ASC)   VISIBLE,
  INDEX `fk_zayavlenie_kategoriya_idx` (`kategoriya_id` ASC) VISIBLE,
  INDEX `fk_zayavlenie_sotrudnik_idx` (`sotrudnik_id` ASC)  VISIBLE,
  INDEX `fk_zayavlenie_status_idx`    (`status_id` ASC)     VISIBLE,
  CONSTRAINT `fk_zayavlenie_kandidat`
    FOREIGN KEY (`kandidat_id`) REFERENCES `kandidat` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_zayavlenie_kategoriya`
    FOREIGN KEY (`kategoriya_id`) REFERENCES `kategoriya_prav` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_zayavlenie_sotrudnik`
    FOREIGN KEY (`sotrudnik_id`) REFERENCES `sotrudnik` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_zayavlenie_status`
    FOREIGN KEY (`status_id`) REFERENCES `status_zayavleniya` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `prokhozhdenie_etapa` (
  `zayavlenie_id`    INT NOT NULL,
  `etap_id`          INT NOT NULL,
  `status`           ENUM('ozhidaet','v_protsesse','proyden','ne_proyden') NOT NULL DEFAULT 'ozhidaet',
  `data_nachala`     DATE NULL,
  `data_zaversheniya` DATE NULL,
  `komentariy`       VARCHAR(255) NULL,
  PRIMARY KEY (`zayavlenie_id`, `etap_id`),
  INDEX `fk_prokhozhdenie_etap_idx` (`etap_id` ASC) VISIBLE,
  CONSTRAINT `fk_prokhozhdenie_zayavlenie`
    FOREIGN KEY (`zayavlenie_id`) REFERENCES `zayavlenie` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_prokhozhdenie_etap`
    FOREIGN KEY (`etap_id`) REFERENCES `etap_poryadka` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `meditsinskaya_spravka` (
  `id`               INT NOT NULL AUTO_INCREMENT,
  `kandidat_id`      INT NOT NULL,
  `nomer`            VARCHAR(30) NOT NULL,
  `meditsinskoe_uchrezhdenie` VARCHAR(150) NULL,
  `data_vydachi`     DATE NOT NULL,
  `data_okonchaniya` DATE NOT NULL,
  `dopusk`           TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `meditsinskaya_spravka_nomer_UNIQUE` (`nomer` ASC) VISIBLE,
  INDEX `fk_spravka_kandidat_idx` (`kandidat_id` ASC) VISIBLE,
  CONSTRAINT `fk_spravka_kandidat`
    FOREIGN KEY (`kandidat_id`) REFERENCES `kandidat` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

-- ---------------------------------------------------------------
-- Обучение и экзамены
-- ---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `gruppa_obucheniya` (
  `id`            INT NOT NULL AUTO_INCREMENT,
  `nazvanie`      VARCHAR(45) NOT NULL,
  `kategoriya_id` INT NOT NULL,
  `prepodavatel_id` INT NOT NULL,
  `data_nachala`  DATE NOT NULL,
  `data_okonchaniya` DATE NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `gruppa_nazvanie_UNIQUE` (`nazvanie` ASC) VISIBLE,
  INDEX `fk_gruppa_kategoriya_idx`   (`kategoriya_id` ASC)   VISIBLE,
  INDEX `fk_gruppa_prepodavatel_idx` (`prepodavatel_id` ASC) VISIBLE,
  CONSTRAINT `fk_gruppa_kategoriya`
    FOREIGN KEY (`kategoriya_id`) REFERENCES `kategoriya_prav` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_gruppa_prepodavatel`
    FOREIGN KEY (`prepodavatel_id`) REFERENCES `sotrudnik` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `zachislenie` (
  `zayavlenie_id`   INT NOT NULL,
  `gruppa_id`       INT NOT NULL,
  `instruktor_id`   INT NOT NULL,
  `chasov_teorii`   SMALLINT NOT NULL DEFAULT 0,
  `chasov_vozhdeniya` SMALLINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`zayavlenie_id`, `gruppa_id`),
  INDEX `fk_zachislenie_gruppa_idx`     (`gruppa_id` ASC)     VISIBLE,
  INDEX `fk_zachislenie_instruktor_idx` (`instruktor_id` ASC) VISIBLE,
  CONSTRAINT `fk_zachislenie_zayavlenie`
    FOREIGN KEY (`zayavlenie_id`) REFERENCES `zayavlenie` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_zachislenie_gruppa`
    FOREIGN KEY (`gruppa_id`) REFERENCES `gruppa_obucheniya` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_zachislenie_instruktor`
    FOREIGN KEY (`instruktor_id`) REFERENCES `sotrudnik` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `ekzamen` (
  `id`             INT NOT NULL AUTO_INCREMENT,
  `zayavlenie_id`  INT NOT NULL,
  `ekzamenator_id` INT NOT NULL,
  `tip_ekzamena`   ENUM('vnutrenniy','teoriya','ploshchadka','gorod') NOT NULL,
  `nomer_popytki`  TINYINT NOT NULL DEFAULT 1,
  `data_ekzamena`  DATETIME NOT NULL,
  `kolvo_oshibok`  TINYINT NULL,
  `sdan`           TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `ekzamen_popytka_UNIQUE` (`zayavlenie_id` ASC, `tip_ekzamena` ASC, `nomer_popytki` ASC) VISIBLE,
  INDEX `fk_ekzamen_ekzamenator_idx` (`ekzamenator_id` ASC) VISIBLE,
  CONSTRAINT `fk_ekzamen_zayavlenie`
    FOREIGN KEY (`zayavlenie_id`) REFERENCES `zayavlenie` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ekzamen_ekzamenator`
    FOREIGN KEY (`ekzamenator_id`) REFERENCES `sotrudnik` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

-- ---------------------------------------------------------------
-- Оплата и выдача удостоверения
-- ---------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `platezh` (
  `id`            INT NOT NULL AUTO_INCREMENT,
  `zayavlenie_id` INT NOT NULL,
  `sposob_id`     INT NOT NULL,
  `summa`         DECIMAL(10,2) NOT NULL,
  `data_platezha` DATETIME NOT NULL,
  `naznachenie`   ENUM('obuchenie','goshposhlina','peresdacha') NOT NULL DEFAULT 'obuchenie',
  PRIMARY KEY (`id`),
  INDEX `fk_platezh_zayavlenie_idx` (`zayavlenie_id` ASC) VISIBLE,
  INDEX `fk_platezh_sposob_idx`     (`sposob_id` ASC)     VISIBLE,
  CONSTRAINT `fk_platezh_zayavlenie`
    FOREIGN KEY (`zayavlenie_id`) REFERENCES `zayavlenie` (`id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_platezh_sposob`
    FOREIGN KEY (`sposob_id`) REFERENCES `sposob_oplaty` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `voditelskoe_udostoverenie` (
  `id`               INT NOT NULL AUTO_INCREMENT,
  `zayavlenie_id`    INT NOT NULL,
  `nomer`            VARCHAR(20) NOT NULL,
  `data_vydachi`     DATE NOT NULL,
  `data_okonchaniya` DATE NOT NULL,
  `podrazdelenie`    VARCHAR(150) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `udostoverenie_nomer_UNIQUE`     (`nomer` ASC)         VISIBLE,
  UNIQUE INDEX `udostoverenie_zayavlenie_UNIQUE` (`zayavlenie_id` ASC) VISIBLE,
  CONSTRAINT `fk_udostoverenie_zayavlenie`
    FOREIGN KEY (`zayavlenie_id`) REFERENCES `zayavlenie` (`id`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
