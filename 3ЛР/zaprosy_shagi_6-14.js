//  ЛР3 — операции над данными (шаги 6–14) для базы getDriverLicense
//  Запуск: mongosh --file zaprosy_shagi_6-14.js
//  Либо каждую строку можно вставлять в Compass (Filter / mongosh внизу).

db = db.getSiblingDB("getDriverLicense");

// ========== 6. Контроль заполнения данными ==========
print("----- 6. Контроль заполнения -----");
db.getCollectionNames().sort().forEach(c => print(c + ": " + db[c].countDocuments()));

// ========== 7. Результат заполнения ==========
// (в Compass это просто список коллекций базы getDriverLicense — см. левую панель)

// ========== 9. Поиск — карточка кандидата по фамилии ==========
// (в примере — поиск сноуборда; у нас аналог — поиск кандидата)
print("----- 9. Поиск кандидата -----");
printjson(db.kandidat.findOne(
  { familiya: "Петров" },
  { _id: 0, imya: 1, familiya: 1, otchestvo: 1, telefon: 1, email: 1 }
));

// ========== 10. Добавление новых заявлений ==========
// (в примере — добавление новых сноубордов; у нас — новые заявления со встроенными этапами)
print("----- 10. Добавление новых заявлений -----");
printjson(db.zayavlenie.insertMany([
  {
    _id: 11, kandidat_id: 7, kategoriya_id: 3, sotrudnik_id: 3, status_id: 1,
    data_podachi: new Date("2026-10-18"), primechanie: "Подано через портал Госуслуг",
    etapy: [
      { etap_id: 1, status: "proyden", data_nachala: new Date("2026-10-18"), data_zaversheniya: new Date("2026-10-18"), komentariy: "Документы приняты" }
    ],
    zachisleniya: []
  },
  {
    _id: 12, kandidat_id: 2, kategoriya_id: 4, sotrudnik_id: 4, status_id: 1,
    data_podachi: new Date("2026-10-19"), primechanie: null,
    etapy: [
      { etap_id: 1, status: "proyden", data_nachala: new Date("2026-10-19"), data_zaversheniya: new Date("2026-10-19"), komentariy: "Документы приняты" }
    ],
    zachisleniya: []
  },
  {
    _id: 13, kandidat_id: 5, kategoriya_id: 5, sotrudnik_id: 3, status_id: 2,
    data_podachi: new Date("2026-10-20"), primechanie: "Требуется прицеп для практики",
    etapy: [
      { etap_id: 1, status: "proyden", data_nachala: new Date("2026-10-20"), data_zaversheniya: new Date("2026-10-20"), komentariy: "Документы приняты" }
    ],
    zachisleniya: []
  }
]));

// ========== 11. Добавление характеристик ==========
// (в примере — добавление характеристик сноуборду; у нас — признак медсправки и отметки к заявлению)
print("----- 11. Добавление характеристик -----");
printjson(db.zayavlenie.updateOne(
  { _id: 1 },
  {
    $set: { medspravka_poluchena: true, data_medkomissii: ISODate("2025-01-12") },
    $push: { otmetki: { data: ISODate("2025-05-13"), text: "ВУ выдано, категория B" } }
  }
));

// ========== 12. Вывод всех заявлений с датой подачи ==========
// (в примере — вывод всех сноубордов с датой изготовления; у нас — заявления с датой подачи
//  и, отдельно, удостоверения с датой выдачи)
print("----- 12. Заявления с датой подачи -----");
db.zayavlenie.find(
  {},
  { _id: 0, kandidat_id: 1, kategoriya_id: 1, data_podachi: 1, status_id: 1 }
).sort({ data_podachi: 1 }).forEach(d => printjson(d));

print("----- 12-б. Удостоверения с датой выдачи -----");
db.voditelskoe_udostoverenie.find(
  {},
  { _id: 0, nomer: 1, data_vydachi: 1, data_okonchaniya: 1 }
).sort({ data_vydachi: 1 }).forEach(d => printjson(d));

// ========== 13. Подсчёт: всего заявлений и кандидатов ==========
// (в примере — общее количество сноубордов и моделей)
print("----- 13. Подсчёт -----");
print("Заявлений (zayavlenie):       " + db.zayavlenie.countDocuments());
print("Кандидатов (kandidat):        " + db.kandidat.countDocuments());
print("Удостоверений (ВУ):           " + db.voditelskoe_udostoverenie.countDocuments());
print("Категории в заявлениях:       " + JSON.stringify(db.zayavlenie.distinct("kategoriya_id")));

// ========== 14. Удаление записи по номеру ==========
// (в примере — удаление сноуборда по серийному номеру; у нас — удаление ВУ по номеру)
print("----- 14. Удаление ВУ по номеру -----");
printjson(db.voditelskoe_udostoverenie.deleteOne({ nomer: "99 26 100007" }));
print("Удостоверений после удаления: " + db.voditelskoe_udostoverenie.countDocuments());

print("========== ГОТОВО ==========");
