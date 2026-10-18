/* ============================================================================
 * Лабораторная работа №1 по MongoDB. Тема: "Основы работы с MongoDB".
 * Автор: Колесников, группа 223-322
 * Дисциплина: "Хранилища данных"
 *
 * Скрипт содержит все команды лабораторной работы в том порядке, в котором
 * они выполнялись в клиенте mongosh. Запуск:  mongosh mongo_lab1.js
 * ==========================================================================*/

// --- Шаг 1. Подключение к серверу и обзор баз данных ------------------------
db                 // текущая база данных
db.version()       // версия сервера MongoDB
show databases     // список существующих баз данных
show collections   // список коллекций текущей базы

// --- Шаг 2. Создание БД sandbox, коллекции humans, вставка документов ------
use sandbox
db
show collections
db.humans.insertOne({name: "John", age: 44})
db.humans.insertOne({name: "Test", age: 35})
db.humans.find()

// --- Шаг 3. Добавление нескольких документов (insertMany) ------------------
db.humans.insertMany([
  {name: "Ann", age: 25},
  {name: "Mary", age: 22},
  {name: "Peter", age: 39}
])
db.humans.find().pretty()
db.humans.countDocuments()

// --- Шаг 4. Поиск с условиями ----------------------------------------------
db.humans.find({name: "John"})                    // точное совпадение
db.humans.find({age: {$lt: 30}})                  // меньше 30
db.humans.find({age: {$gte: 25, $lt: 40}})        // диапазон (логическое И)
db.humans.find({name: {$ne: "John"}})             // не равно
db.humans.find({$or: [{name: "Mary"}, {age: {$gt: 38}}]})   // логическое ИЛИ
db.humans.find({name: {$in: ["John", "Mary"]}})   // входит в список
db.humans.find({name: {$nin: ["John", "Mary"]}})  // не входит в список

// --- Шаг 5. Вложенные документы и массивы (коллекция sportsmen) ------------
use sportsmen
db.sportsmen.insertMany([
  {name: "Dominik Hašek",
   address: {city: "Пардубице", country: "Чехия"},
   clubs: [{clubName: "HC Pardubice", firstYear: 1980, lastYear: 1989},
           {clubName: "HC Spartak Moscow", firstYear: 2010, lastYear: 2011}]},
  {name: "Иван Петров",
   address: {city: "Москва", street: "Ленина", house: 15},
   clubs: [{clubName: "ХК Динамо", firstYear: 2012, lastYear: 2015},
           {clubName: "ХК ЦСКА", firstYear: 2015, lastYear: 2019}]},
  {name: "Пётр Смирнов",
   address: {city: "Санкт-Петербург"},
   clubs: [{clubName: "СКА", firstYear: 2016, lastYear: 2020}]}
])
db.sportsmen.find().pretty()

// --- Шаг 6. Поиск по вложенным полям и массивам ----------------------------
db.sportsmen.find({"clubs.0.clubName": "HC Pardubice"})       // первый элемент массива
db.sportsmen.find({"clubs.clubName": "HC Spartak Moscow"})    // любой элемент массива
db.sportsmen.find({"address.city": "Москва"})                 // поле вложенного документа
db.sportsmen.find({clubs: {$elemMatch: {firstYear: {$gte: 2012}}}})  // условие на элемент
db.sportsmen.find({clubs: {$size: 2}}, {name: 1, "clubs.clubName": 1, _id: 0}) // размер массива + проекция

// --- Шаг 7. Изменение документов -------------------------------------------
db.humans.updateOne({name: "John"}, {$set: {city: "Moscow"}})   // $set — задать поле
db.humans.updateMany({}, {$inc: {age: 1}})                      // $inc — увеличить на 1
db.humans.find({}, {name: 1, age: 1, city: 1, _id: 0})
db.humans.updateOne({name: "Mary"}, {$unset: {age: ""}})        // $unset — удалить поле
db.sportsmen.updateOne({name: "Dominik Hašek"},
    {$push: {clubs: {clubName: "HC Torino", firstYear: 2000, lastYear: 2001}}})  // $push — добавить в массив
db.sportsmen.find({name: "Dominik Hašek"}, {name: 1, "clubs.clubName": 1, _id: 0})

// --- Шаг 8. Удаление документов, коллекций и баз данных --------------------
db.humans.deleteMany({age: {$gt: 30}})   // удалить документы по условию
db.humans.deleteOne({name: "Mary"})      // удалить один документ
db.humans.countDocuments()
db.humans.find()
db.humans.drop()                         // удалить коллекцию
show collections
db.dropDatabase()                        // удалить текущую базу
use sportsmen
db.dropDatabase()
show databases
