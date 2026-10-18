SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `voditelskie_prava_dv`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;
USE `voditelskie_prava_dv`;

-- =====================================================================
-- HUBS
-- =====================================================================

CREATE TABLE IF NOT EXISTS `hub_kategoriya_prav` (
  `kategoriya_hk` CHAR(32) NOT NULL,
  `kod` VARCHAR(5) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`kategoriya_hk`),
  UNIQUE INDEX `hub_kategoriya_prav_bk_UNIQUE` (`kod` ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `hub_tip_dokumenta` (
  `tip_dokumenta_hk` CHAR(32) NOT NULL,
  `nazvanie` VARCHAR(60) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`tip_dokumenta_hk`),
  UNIQUE INDEX `hub_tip_dokumenta_bk_UNIQUE` (`nazvanie` ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `hub_dolzhnost` (
  `dolzhnost_hk` CHAR(32) NOT NULL,
  `nazvanie` VARCHAR(45) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`dolzhnost_hk`),
  UNIQUE INDEX `hub_dolzhnost_bk_UNIQUE` (`nazvanie` ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `hub_sotrudnik` (
  `sotrudnik_hk` CHAR(32) NOT NULL,
  `telefon` VARCHAR(15) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`sotrudnik_hk`),
  UNIQUE INDEX `hub_sotrudnik_bk_UNIQUE` (`telefon` ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `hub_kandidat` (
  `kandidat_hk` CHAR(32) NOT NULL,
  `telefon` VARCHAR(15) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`kandidat_hk`),
  UNIQUE INDEX `hub_kandidat_bk_UNIQUE` (`telefon` ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `hub_etap` (
  `etap_hk` CHAR(32) NOT NULL,
  `kategoriya_kod` VARCHAR(5) NOT NULL,
  `nomer_shaga` TINYINT NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`etap_hk`),
  UNIQUE INDEX `hub_etap_bk_UNIQUE` (`kategoriya_kod` ASC, `nomer_shaga` ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `hub_gruppa` (
  `gruppa_hk` CHAR(32) NOT NULL,
  `nazvanie` VARCHAR(45) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`gruppa_hk`),
  UNIQUE INDEX `hub_gruppa_bk_UNIQUE` (`nazvanie` ASC) VISIBLE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `hub_status` (
  `status_hk` CHAR(32) NOT NULL,
  `nazvanie` VARCHAR(30) NOT NULL,
  `tip_statusa` VARCHAR(20) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`status_hk`),
  UNIQUE INDEX `hub_status_bk_UNIQUE` (`nazvanie` ASC, `tip_statusa` ASC) VISIBLE
) ENGINE = InnoDB;

-- =====================================================================
-- LINKS
-- =====================================================================

CREATE TABLE IF NOT EXISTS `link_sotrudnik_dolzhnost` (
  `link_sotr_dolzh_hk` CHAR(32) NOT NULL,
  `sotrudnik_hk` CHAR(32) NOT NULL,
  `dolzhnost_hk` CHAR(32) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_sotr_dolzh_hk`),
  UNIQUE INDEX `link_sotrudnik_dolzhnost_uniq_UNIQUE`
    (`sotrudnik_hk` ASC, `dolzhnost_hk` ASC) VISIBLE,
  INDEX `fk_link_sotrudnik_dolzhnost_sotr_idx` (`sotrudnik_hk` ASC) VISIBLE,
  INDEX `fk_link_sotrudnik_dolzhnost_dolzh_idx` (`dolzhnost_hk` ASC) VISIBLE,
  CONSTRAINT `fk_link_sotrudnik_dolzhnost_sotr`
    FOREIGN KEY (`sotrudnik_hk`) REFERENCES `hub_sotrudnik` (`sotrudnik_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_link_sotrudnik_dolzhnost_dolzh`
    FOREIGN KEY (`dolzhnost_hk`) REFERENCES `hub_dolzhnost` (`dolzhnost_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `link_etap_dokument` (
  `link_etap_dok_hk` CHAR(32) NOT NULL,
  `etap_hk` CHAR(32) NOT NULL,
  `tip_dokumenta_hk` CHAR(32) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_etap_dok_hk`),
  UNIQUE INDEX `link_etap_dokument_uniq_UNIQUE`
    (`etap_hk` ASC, `tip_dokumenta_hk` ASC) VISIBLE,
  INDEX `fk_link_etap_dokument_etap_idx` (`etap_hk` ASC) VISIBLE,
  INDEX `fk_link_etap_dokument_tip_idx` (`tip_dokumenta_hk` ASC) VISIBLE,
  CONSTRAINT `fk_link_etap_dokument_etap`
    FOREIGN KEY (`etap_hk`) REFERENCES `hub_etap` (`etap_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_link_etap_dokument_tip`
    FOREIGN KEY (`tip_dokumenta_hk`) REFERENCES `hub_tip_dokumenta` (`tip_dokumenta_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `link_kandidat_dokument` (
  `link_kand_dok_hk` CHAR(32) NOT NULL,
  `kandidat_hk` CHAR(32) NOT NULL,
  `tip_dokumenta_hk` CHAR(32) NOT NULL,
  `seriya` VARCHAR(10) NOT NULL,
  `nomer` VARCHAR(20) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_kand_dok_hk`),
  UNIQUE INDEX `link_kandidat_dokument_uniq_UNIQUE`
    (`kandidat_hk` ASC, `tip_dokumenta_hk` ASC, `seriya` ASC, `nomer` ASC) VISIBLE,
  INDEX `fk_link_kandidat_dokument_kandidat_idx` (`kandidat_hk` ASC) VISIBLE,
  INDEX `fk_link_kandidat_dokument_tip_idx` (`tip_dokumenta_hk` ASC) VISIBLE,
  CONSTRAINT `fk_link_kandidat_dokument_kandidat`
    FOREIGN KEY (`kandidat_hk`) REFERENCES `hub_kandidat` (`kandidat_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_link_kandidat_dokument_tip`
    FOREIGN KEY (`tip_dokumenta_hk`) REFERENCES `hub_tip_dokumenta` (`tip_dokumenta_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `link_meditsinskaya_spravka` (
  `link_spravka_hk` CHAR(32) NOT NULL,
  `kandidat_hk` CHAR(32) NOT NULL,
  `nomer` VARCHAR(30) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_spravka_hk`),
  UNIQUE INDEX `link_meditsinskaya_spravka_uniq_UNIQUE`
    (`kandidat_hk` ASC, `nomer` ASC) VISIBLE,
  INDEX `fk_link_meditsinskaya_spravka_kandidat_idx` (`kandidat_hk` ASC) VISIBLE,
  CONSTRAINT `fk_link_meditsinskaya_spravka_kandidat`
    FOREIGN KEY (`kandidat_hk`) REFERENCES `hub_kandidat` (`kandidat_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `link_gruppa_obucheniya` (
  `link_gruppa_obuch_hk` CHAR(32) NOT NULL,
  `gruppa_hk` CHAR(32) NOT NULL,
  `kategoriya_hk` CHAR(32) NOT NULL,
  `prepodavatel_hk` CHAR(32) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_gruppa_obuch_hk`),
  UNIQUE INDEX `link_gruppa_obucheniya_uniq_UNIQUE`
    (`gruppa_hk` ASC, `kategoriya_hk` ASC, `prepodavatel_hk` ASC) VISIBLE,
  INDEX `fk_link_gruppa_obucheniya_gruppa_idx` (`gruppa_hk` ASC) VISIBLE,
  INDEX `fk_link_gruppa_obucheniya_kategoriya_idx` (`kategoriya_hk` ASC) VISIBLE,
  INDEX `fk_link_gruppa_obucheniya_prepodavatel_idx` (`prepodavatel_hk` ASC) VISIBLE,
  CONSTRAINT `fk_link_gruppa_obucheniya_gruppa`
    FOREIGN KEY (`gruppa_hk`) REFERENCES `hub_gruppa` (`gruppa_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_link_gruppa_obucheniya_kategoriya`
    FOREIGN KEY (`kategoriya_hk`) REFERENCES `hub_kategoriya_prav` (`kategoriya_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_link_gruppa_obucheniya_prepodavatel`
    FOREIGN KEY (`prepodavatel_hk`) REFERENCES `hub_sotrudnik` (`sotrudnik_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `link_zayavlenie` (
  `link_zayavlenie_hk` CHAR(32) NOT NULL,
  `kandidat_hk` CHAR(32) NOT NULL,
  `kategoriya_hk` CHAR(32) NOT NULL,
  `sotrudnik_hk` CHAR(32) NOT NULL,
  `status_hk` CHAR(32) NOT NULL,
  `nomer_zayavleniya` VARCHAR(20) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_zayavlenie_hk`),
  UNIQUE INDEX `link_zayavlenie_uniq_UNIQUE`
    (`kandidat_hk` ASC, `kategoriya_hk` ASC, `sotrudnik_hk` ASC, `status_hk` ASC, `nomer_zayavleniya` ASC) VISIBLE,
  INDEX `fk_link_zayavlenie_kandidat_idx` (`kandidat_hk` ASC) VISIBLE,
  INDEX `fk_link_zayavlenie_kategoriya_idx` (`kategoriya_hk` ASC) VISIBLE,
  INDEX `fk_link_zayavlenie_sotrudnik_idx` (`sotrudnik_hk` ASC) VISIBLE,
  INDEX `fk_link_zayavlenie_status_idx` (`status_hk` ASC) VISIBLE,
  CONSTRAINT `fk_link_zayavlenie_kandidat`
    FOREIGN KEY (`kandidat_hk`) REFERENCES `hub_kandidat` (`kandidat_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_link_zayavlenie_kategoriya`
    FOREIGN KEY (`kategoriya_hk`) REFERENCES `hub_kategoriya_prav` (`kategoriya_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_link_zayavlenie_sotrudnik`
    FOREIGN KEY (`sotrudnik_hk`) REFERENCES `hub_sotrudnik` (`sotrudnik_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_link_zayavlenie_status`
    FOREIGN KEY (`status_hk`) REFERENCES `hub_status` (`status_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `link_prokhozhdenie_etapa` (
  `link_prokhozhdenie_hk` CHAR(32) NOT NULL,
  `link_zayavlenie_hk` CHAR(32) NOT NULL,
  `etap_hk` CHAR(32) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_prokhozhdenie_hk`),
  UNIQUE INDEX `link_prokhozhdenie_etapa_uniq_UNIQUE`
    (`link_zayavlenie_hk` ASC, `etap_hk` ASC) VISIBLE,
  INDEX `fk_link_prokhozhdenie_etapa_zayavlenie_idx` (`link_zayavlenie_hk` ASC) VISIBLE,
  INDEX `fk_link_prokhozhdenie_etapa_etap_idx` (`etap_hk` ASC) VISIBLE,
  CONSTRAINT `fk_link_prokhozhdenie_etapa_zayavlenie`
    FOREIGN KEY (`link_zayavlenie_hk`) REFERENCES `link_zayavlenie` (`link_zayavlenie_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_link_prokhozhdenie_etapa_etap`
    FOREIGN KEY (`etap_hk`) REFERENCES `hub_etap` (`etap_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `link_zachislenie` (
  `link_zachislenie_hk` CHAR(32) NOT NULL,
  `link_zayavlenie_hk` CHAR(32) NOT NULL,
  `gruppa_hk` CHAR(32) NOT NULL,
  `instruktor_hk` CHAR(32) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_zachislenie_hk`),
  UNIQUE INDEX `link_zachislenie_uniq_UNIQUE`
    (`link_zayavlenie_hk` ASC, `gruppa_hk` ASC, `instruktor_hk` ASC) VISIBLE,
  INDEX `fk_link_zachislenie_zayavlenie_idx` (`link_zayavlenie_hk` ASC) VISIBLE,
  INDEX `fk_link_zachislenie_gruppa_idx` (`gruppa_hk` ASC) VISIBLE,
  INDEX `fk_link_zachislenie_instruktor_idx` (`instruktor_hk` ASC) VISIBLE,
  CONSTRAINT `fk_link_zachislenie_zayavlenie`
    FOREIGN KEY (`link_zayavlenie_hk`) REFERENCES `link_zayavlenie` (`link_zayavlenie_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_link_zachislenie_gruppa`
    FOREIGN KEY (`gruppa_hk`) REFERENCES `hub_gruppa` (`gruppa_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_link_zachislenie_instruktor`
    FOREIGN KEY (`instruktor_hk`) REFERENCES `hub_sotrudnik` (`sotrudnik_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `link_ekzamen` (
  `link_ekzamen_hk` CHAR(32) NOT NULL,
  `link_zayavlenie_hk` CHAR(32) NOT NULL,
  `ekzamenator_hk` CHAR(32) NOT NULL,
  `tip_ekzamena` VARCHAR(15) NOT NULL,
  `nomer_popytki` TINYINT NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_ekzamen_hk`),
  UNIQUE INDEX `link_ekzamen_uniq_UNIQUE`
    (`link_zayavlenie_hk` ASC, `ekzamenator_hk` ASC, `tip_ekzamena` ASC, `nomer_popytki` ASC) VISIBLE,
  INDEX `fk_link_ekzamen_zayavlenie_idx` (`link_zayavlenie_hk` ASC) VISIBLE,
  INDEX `fk_link_ekzamen_ekzamenator_idx` (`ekzamenator_hk` ASC) VISIBLE,
  CONSTRAINT `fk_link_ekzamen_zayavlenie`
    FOREIGN KEY (`link_zayavlenie_hk`) REFERENCES `link_zayavlenie` (`link_zayavlenie_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_link_ekzamen_ekzamenator`
    FOREIGN KEY (`ekzamenator_hk`) REFERENCES `hub_sotrudnik` (`sotrudnik_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `link_platezh` (
  `link_platezh_hk` CHAR(32) NOT NULL,
  `link_zayavlenie_hk` CHAR(32) NOT NULL,
  `nomer_platezha` VARCHAR(20) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_platezh_hk`),
  UNIQUE INDEX `link_platezh_uniq_UNIQUE`
    (`link_zayavlenie_hk` ASC, `nomer_platezha` ASC) VISIBLE,
  INDEX `fk_link_platezh_zayavlenie_idx` (`link_zayavlenie_hk` ASC) VISIBLE,
  CONSTRAINT `fk_link_platezh_zayavlenie`
    FOREIGN KEY (`link_zayavlenie_hk`) REFERENCES `link_zayavlenie` (`link_zayavlenie_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `link_udostoverenie` (
  `link_udostoverenie_hk` CHAR(32) NOT NULL,
  `link_zayavlenie_hk` CHAR(32) NOT NULL,
  `nomer` VARCHAR(20) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_udostoverenie_hk`),
  UNIQUE INDEX `link_udostoverenie_uniq_UNIQUE`
    (`link_zayavlenie_hk` ASC, `nomer` ASC) VISIBLE,
  INDEX `fk_link_udostoverenie_zayavlenie_idx` (`link_zayavlenie_hk` ASC) VISIBLE,
  CONSTRAINT `fk_link_udostoverenie_zayavlenie`
    FOREIGN KEY (`link_zayavlenie_hk`) REFERENCES `link_zayavlenie` (`link_zayavlenie_hk`)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

-- =====================================================================
-- SATELLITES
-- =====================================================================

CREATE TABLE IF NOT EXISTS `sat_kategoriya_prav` (
  `kategoriya_hk` CHAR(32) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `load_end_date` DATETIME NULL,
  `hash_diff`     CHAR(32) NOT NULL,
  `nazvanie`      VARCHAR(100) NOT NULL,
  `min_vozrast`   TINYINT NOT NULL,
  `opisanie`      VARCHAR(255) NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`kategoriya_hk`, `load_date`),
  CONSTRAINT `fk_sat_kategoriya_prav_parent`
    FOREIGN KEY (`kategoriya_hk`) REFERENCES `hub_kategoriya_prav` (`kategoriya_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_etap` (
  `etap_hk` CHAR(32) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `load_end_date` DATETIME NULL,
  `hash_diff`     CHAR(32) NOT NULL,
  `nazvanie`      VARCHAR(100) NOT NULL,
  `opisanie`      VARCHAR(500) NULL,
  `organizatsiya` VARCHAR(100) NULL,
  `obyazatelnyy`  TINYINT(1) NOT NULL DEFAULT 1,
  `srok_dney`     SMALLINT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`etap_hk`, `load_date`),
  CONSTRAINT `fk_sat_etap_parent`
    FOREIGN KEY (`etap_hk`) REFERENCES `hub_etap` (`etap_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_etap_dokument` (
  `link_etap_dok_hk` CHAR(32) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `load_end_date` DATETIME NULL,
  `hash_diff`     CHAR(32) NOT NULL,
  `obyazatelnyy`  TINYINT(1) NOT NULL DEFAULT 1,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_etap_dok_hk`, `load_date`),
  CONSTRAINT `fk_sat_etap_dokument_parent`
    FOREIGN KEY (`link_etap_dok_hk`) REFERENCES `link_etap_dokument` (`link_etap_dok_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_sotrudnik` (
  `sotrudnik_hk` CHAR(32) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `load_end_date` DATETIME NULL,
  `hash_diff`     CHAR(32) NOT NULL,
  `imya`          VARCHAR(45) NOT NULL,
  `familiya`      VARCHAR(45) NOT NULL,
  `otchestvo`     VARCHAR(45) NULL,
  `email`         VARCHAR(60) NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`sotrudnik_hk`, `load_date`),
  CONSTRAINT `fk_sat_sotrudnik_parent`
    FOREIGN KEY (`sotrudnik_hk`) REFERENCES `hub_sotrudnik` (`sotrudnik_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_kandidat` (
  `kandidat_hk` CHAR(32) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `load_end_date` DATETIME NULL,
  `hash_diff`     CHAR(32) NOT NULL,
  `imya`              VARCHAR(45) NOT NULL,
  `familiya`          VARCHAR(45) NOT NULL,
  `otchestvo`         VARCHAR(45) NULL,
  `data_rozhdeniya`   DATE NOT NULL,
  `email`             VARCHAR(60) NULL,
  `adres`             VARCHAR(255) NULL,
  `data_registratsii` DATE NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`kandidat_hk`, `load_date`),
  CONSTRAINT `fk_sat_kandidat_parent`
    FOREIGN KEY (`kandidat_hk`) REFERENCES `hub_kandidat` (`kandidat_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_dokument` (
  `link_kand_dok_hk` CHAR(32) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `load_end_date` DATETIME NULL,
  `hash_diff`     CHAR(32) NOT NULL,
  `kem_vydan`        VARCHAR(255) NULL,
  `data_vydachi`     DATE NULL,
  `data_okonchaniya` DATE NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_kand_dok_hk`, `load_date`),
  CONSTRAINT `fk_sat_dokument_parent`
    FOREIGN KEY (`link_kand_dok_hk`) REFERENCES `link_kandidat_dokument` (`link_kand_dok_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_meditsinskaya_spravka` (
  `link_spravka_hk` CHAR(32) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `load_end_date` DATETIME NULL,
  `hash_diff`     CHAR(32) NOT NULL,
  `meditsinskoe_uchrezhdenie` VARCHAR(150) NULL,
  `data_vydachi`     DATE NOT NULL,
  `data_okonchaniya` DATE NOT NULL,
  `dopusk`           TINYINT(1) NOT NULL DEFAULT 1,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_spravka_hk`, `load_date`),
  CONSTRAINT `fk_sat_meditsinskaya_spravka_parent`
    FOREIGN KEY (`link_spravka_hk`) REFERENCES `link_meditsinskaya_spravka` (`link_spravka_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_gruppa` (
  `gruppa_hk` CHAR(32) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `load_end_date` DATETIME NULL,
  `hash_diff`     CHAR(32) NOT NULL,
  `data_nachala`     DATE NOT NULL,
  `data_okonchaniya` DATE NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`gruppa_hk`, `load_date`),
  CONSTRAINT `fk_sat_gruppa_parent`
    FOREIGN KEY (`gruppa_hk`) REFERENCES `hub_gruppa` (`gruppa_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_zayavlenie` (
  `link_zayavlenie_hk` CHAR(32) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `load_end_date` DATETIME NULL,
  `hash_diff`     CHAR(32) NOT NULL,
  `data_podachi`  DATE NOT NULL,
  `primechanie`   VARCHAR(255) NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_zayavlenie_hk`, `load_date`),
  CONSTRAINT `fk_sat_zayavlenie_parent`
    FOREIGN KEY (`link_zayavlenie_hk`) REFERENCES `link_zayavlenie` (`link_zayavlenie_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_prokhozhdenie_etapa` (
  `link_prokhozhdenie_hk` CHAR(32) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `load_end_date` DATETIME NULL,
  `hash_diff`     CHAR(32) NOT NULL,
  `status`            ENUM('ozhidaet','v_protsesse','proyden','ne_proyden') NOT NULL DEFAULT 'ozhidaet',
  `data_nachala`      DATE NULL,
  `data_zaversheniya` DATE NULL,
  `komentariy`        VARCHAR(255) NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_prokhozhdenie_hk`, `load_date`),
  CONSTRAINT `fk_sat_prokhozhdenie_etapa_parent`
    FOREIGN KEY (`link_prokhozhdenie_hk`) REFERENCES `link_prokhozhdenie_etapa` (`link_prokhozhdenie_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_zachislenie` (
  `link_zachislenie_hk` CHAR(32) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `load_end_date` DATETIME NULL,
  `hash_diff`     CHAR(32) NOT NULL,
  `chasov_teorii`     SMALLINT NOT NULL DEFAULT 0,
  `chasov_vozhdeniya` SMALLINT NOT NULL DEFAULT 0,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_zachislenie_hk`, `load_date`),
  CONSTRAINT `fk_sat_zachislenie_parent`
    FOREIGN KEY (`link_zachislenie_hk`) REFERENCES `link_zachislenie` (`link_zachislenie_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_ekzamen` (
  `link_ekzamen_hk` CHAR(32) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `load_end_date` DATETIME NULL,
  `hash_diff`     CHAR(32) NOT NULL,
  `data_ekzamena` DATETIME NOT NULL,
  `kolvo_oshibok` TINYINT NULL,
  `sdan`          TINYINT(1) NOT NULL DEFAULT 0,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_ekzamen_hk`, `load_date`),
  CONSTRAINT `fk_sat_ekzamen_parent`
    FOREIGN KEY (`link_ekzamen_hk`) REFERENCES `link_ekzamen` (`link_ekzamen_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_platezh` (
  `link_platezh_hk` CHAR(32) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `load_end_date` DATETIME NULL,
  `hash_diff`     CHAR(32) NOT NULL,
  `summa`           DECIMAL(10,2) NOT NULL,
  `data_platezha`   DATETIME NOT NULL,
  `naznachenie`     ENUM('obuchenie','goshposhlina','peresdacha') NOT NULL DEFAULT 'obuchenie',
  `sposob_nazvanie` VARCHAR(30) NOT NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_platezh_hk`, `load_date`),
  CONSTRAINT `fk_sat_platezh_parent`
    FOREIGN KEY (`link_platezh_hk`) REFERENCES `link_platezh` (`link_platezh_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sat_udostoverenie` (
  `link_udostoverenie_hk` CHAR(32) NOT NULL,
  `load_date`     DATETIME NOT NULL,
  `load_end_date` DATETIME NULL,
  `hash_diff`     CHAR(32) NOT NULL,
  `data_vydachi`     DATE NOT NULL,
  `data_okonchaniya` DATE NOT NULL,
  `podrazdelenie`    VARCHAR(150) NULL,
  `record_source` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`link_udostoverenie_hk`, `load_date`),
  CONSTRAINT `fk_sat_udostoverenie_parent`
    FOREIGN KEY (`link_udostoverenie_hk`) REFERENCES `link_udostoverenie` (`link_udostoverenie_hk`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
