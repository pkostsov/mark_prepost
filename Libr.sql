--предлагаемый вариант реализован на субд oracle, но должен отработать и на других субд без дополнительных правок
CREATE USER TRADEIN1 IDENTIFIED BY TRADEIN1; --создаем пользователя (схему) 
--для определения количества книг достаточно сделать  поиск по количеству записей для уникального сочетания названия книги, автора, издательства и года издания. хранить эту 
--информацию в таблице экземпляров неправильно, так как не соответствует структуре, а заводить отдельную таблицу - накладно по расходам.
--SELECT COUNT(*) FROM TRADEIN1.BOOKS WHERE BOOKS.BOOK_NAME = '', BOOKS.AUTH_ID= '', BOOKS.PUBL_ID= '', BOOKS.PUBL_YEAR= ''
DROP TABLE TRADEIN1.BOOKS;
DROP TABLE TRADEIN1.BOOK_PLACE;
DROP TABLE TRADEIN1.READER_CARDS;
DROP TABLE TRADEIN1.AUTHORS;
DROP TABLE TRADEIN1.LANGS;
DROP TABLE TRADEIN1.PUBL_TYPE;
DROP TABLE TRADEIN1.PUBLISHERS;
DROP TABLE TRADEIN1.CITIES;
DROP TABLE TRADEIN1.KNOWL_AREA;
--создаем таблицу с авторами и переводчиками
--таблица хранит имена авторов, рецензентов и прочих, имеющих отношение к изданию. если автор писал в соавторстве, то для такого коллектива должна создаваться отдельная запись
--например: "Иванов И.И." и "Иванов И.И., Петров П.П." - две различные записи. Варианты, когда мы создаем составной ключ либо используем поле тегов, 
--переусложненные и рассматривать их в рамках тестового задания не имеет смысла.
CREATE TABLE TRADEIN1.AUTHORS(AUTH_ID NUMBER  PRIMARY KEY, --поле предполагается заполнять по триггеру, но для этого необходимо также создать последовательность. не реализовывал, т.к. в разных базах разные варианты
                                                            FIRST_NAME CHAR(100) NOT NULL,
                                                            FAMILY_NAME CHAR(100) NOT NULL,
                                                            THIRD_NAME CHAR(100),
                                                            BIRTH_DATE DATE
                                                            );
--вставка записей для оракла. за комментарием вставка для мс сервера. у них другой формат даты                                                           
INSERT INTO TRADEIN1.AUTHORS VALUES (1, 'Иванов', 'Иван', 'Иванович', TO_DATE('01.09.2003', 'DD.MM.YYYY')); --INSERT INTO TRADEIN1.AUTHORS VALUES (1, 'Иванов', 'Иван', 'Иванович', CONVERT(DATETIME, '01.09.2003', 104));
INSERT INTO TRADEIN1.AUTHORS VALUES (2, 'Петров', 'Петр', 'Петрович', TO_DATE('01.09.2003', 'DD.MM.YYYY'));    --INSERT INTO TRADEIN1.AUTHORS VALUES (1, 'Петров', 'Петр', 'Петрович',CONVERT(DATETIME, '01.09.2003', 104));                                                      
--справочник языков
CREATE TABLE TRADEIN1.LANGS(LANG_ID NUMBER PRIMARY KEY,
                                                                  LANG_NAME CHAR(100)
                                                                  ); 
--вносим записи в таблицу-справочник
INSERT INTO TRADEIN1.LANGS VALUES (1, 'Русский');
INSERT INTO TRADEIN1.LANGS VALUES (2, 'Английский');
COMMIT; --сохраняем записи
--справочник городов
CREATE  TABLE TRADEIN1.CITIES(CITY_ID NUMBER PRIMARY KEY,
                                                                  CITY_NAME CHAR(100));
INSERT INTO TRADEIN1.CITIES VALUES (1, 'Минск');
INSERT INTO TRADEIN1.CITIES VALUES (2, 'Москва');
COMMIT;                                                                  
--справочник типов публикаций
CREATE TABLE TRADEIN1.PUBL_TYPE(PUBL_ID NUMBER PRIMARY KEY,
                                                                           PUBL_NAME CHAR(100)) ;
INSERT INTO TRADEIN1.PUBL_TYPE VALUES (1, 'Справочник');
INSERT INTO TRADEIN1.PUBL_TYPE VALUES (2, 'Сборник');
INSERT INTO TRADEIN1.PUBL_TYPE VALUES (3, 'Монография');  
COMMIT; 
--справочник издательств
CREATE TABLE TRADEIN1.PUBLISHERS(PUBLISH_ID NUMBER PRIMARY KEY, 
                                                                            PUBLISH_NAME CHAR(100),
                                                                            PUBLISH_ADDR CHAR(100),
                                                                            CITY_ID NUMBER);
ALTER TABLE TRADEIN1.PUBLISHERS ADD CONSTRAINT FK_CITY_ID FOREIGN KEY (CITY_ID) REFERENCES TRADEIN1.CITIES(CITY_ID);             
INSERT INTO TRADEIN1.PUBLISHERS VALUES (1, 'Харвест', 'ул.Коммунистическая 32', 1);
INSERT INTO TRADEIN1.PUBLISHERS VALUES (2, 'Амико-Пресс', 'ул.Воронина 11', 2);
COMMIT;                                                      
--создаем таблицу справочник областей знаний
CREATE TABLE TRADEIN1.KNOWL_AREA(KNOWL_ID NUMBER PRIMARY KEY,
                                                                                 KNOWL_ANAME CHAR(100)
                                                                                 );
INSERT INTO TRADEIN1.KNOWL_AREA VALUES (1, 'Литература');
INSERT INTO TRADEIN1.KNOWL_AREA VALUES (2, 'Химия');  
COMMIT; 
--создаем таблицу для определения места хранения книги
CREATE TABLE TRADEIN1.BOOK_PLACE(PLACE_ID NUMBER PRIMARY KEY, --уникальный идентификатор места книги
                                                                               ROOM_ID NUMBER CONSTRAINT CH_ROOM_VAL CHECK (ROOM_ID < 11), --номер комнаты
                                                                               STAND_ID NUMBER CONSTRAINT CH_STAND_VAL CHECK (STAND_ID < 31), --номер стеллажа
                                                                               SHELF_ID NUMBER CONSTRAINT CH_SHELF_VAL CHECK (SHELF_ID < 51) --номер полки                                  
                                                                                );
--создаем таблицу для хранения каталога читательских билетов
CREATE TABLE TRADEIN1.READER_CARDS(READER_ID NUMBER PRIMARY KEY, --идентификатор читательского билета
                                                                                    READER_CARD CHAR(100) CHECK (COUNT(DISTINCT(READER_CARD))<4), --номер читательского билета (на случай если это некий составной код с символьными элементами
                                                                                    FIRST_NAME CHAR(100) NOT NULL, --фамилия читателя
                                                                                    FAMILY_NAME CHAR(100) NOT NULL, --имя читателя
                                                                                    THIRD_NAME CHAR(100), --отчество читателя
                                                                                    ADDRESS CHAR(100), --адрес читателя
                                                                                    PHONE CHAR(50), --телефон читателя
                                                                                    AGE NUMBER CHECK (AGE > 15) --дата рождения
                                                                                    );
--создаем таблицу хранилище экземпляров книг                                                                                                                    
CREATE TABLE TRADEIN1.BOOKS (BOOK_ID CHAR(100) PRIMARY KEY, --идентификатор экземпляра книги, он же инвентарный номер экземпляра
                                                                   BOOK_NAME CHAR(500),  --наименование книги
                                                                   AUTH_ID NUMBER,   --ссылка на автора
                                                                   TOME_NUM CHAR(10), --номер тома, или части. не использую тип намбер, т.к. номер тома может быть римский или составной
                                                                   ORIGINAL_LANG NUMBER,    --язык оригинала
                                                                   TRANSLATE_LANG NUMBER, --язык перевода   
                                                                   PUBL_ID NUMBER,                   --вид издания
                                                                   KNOWL_ID NUMBER,      --область знаний 
                                                                   TRANSLATOR_ID NUMBER, -- переводчик
                                                                   PUBLISH_ID NUMBER, --издательство
                                                                   PUBL_YEAR NUMBER,--год издания в цифре
                                                                   LIBRARY_CARD CHAR(100), --библиотечный шифр 
                                                                   PRICE CHAR(100), --цена экземпляра
                                                                   PLACE_ID NUMBER,  --ссылка на таблицу хранилище
                                                                   READER_ID NUMBER,    --ссылка на карточку читателя. если запись пустая, то книга в библиотеке
                                                                   READER_DATE DATE  --дата выдачи книги читателю (дата изъятия книги из хранилища)
                                                                   );
ALTER TABLE TRADEIN1.BOOKS ADD CONSTRAINT FK_AUTH_ID FOREIGN KEY (AUTH_ID) REFERENCES TRADEIN1.AUTHORS(AUTH_ID);
ALTER TABLE TRADEIN1.BOOKS ADD CONSTRAINT FK_OLANG_ID FOREIGN KEY (ORIGINAL_LANG) REFERENCES TRADEIN1.LANGS(LANG_ID);
ALTER TABLE TRADEIN1.BOOKS ADD CONSTRAINT FK_TLANG_ID FOREIGN KEY (TRANSLATE_LANG) REFERENCES TRADEIN1.LANGS(LANG_ID);
ALTER TABLE TRADEIN1.BOOKS ADD CONSTRAINT FK_PUBL_ID FOREIGN KEY (PUBL_ID) REFERENCES TRADEIN1.PUBL_TYPE(PUBL_ID);
ALTER TABLE TRADEIN1.BOOKS ADD CONSTRAINT FK_KNOWL_ID FOREIGN KEY (KNOWL_ID) REFERENCES TRADEIN1.KNOWL_AREA(KNOWL_ID);
ALTER TABLE TRADEIN1.BOOKS ADD CONSTRAINT FK_TRANSL_ID FOREIGN KEY (TRANSLATOR_ID) REFERENCES TRADEIN1.AUTHORS(AUTH_ID);
ALTER TABLE TRADEIN1.BOOKS ADD CONSTRAINT FK_PUBLISH_ID FOREIGN KEY (PUBLISH_ID) REFERENCES TRADEIN1.PUBLISHERS(PUBLISH_ID);
ALTER TABLE TRADEIN1.BOOKS ADD CONSTRAINT FK_PLACE_ID FOREIGN KEY (PLACE_ID) REFERENCES TRADEIN1.BOOK_PLACE(PLACE_ID);
ALTER TABLE TRADEIN1.BOOKS ADD CONSTRAINT FK_READER_ID FOREIGN KEY (READER_ID) REFERENCES TRADEIN1.READER_CARDS(READER_ID);
ALTER TABLE TRADEIN1.BOOKS MODIFY  READER_DATE DEFAULT SYSDATE; --ALTER TABLE TRADEIN1.BOOKS ADD CONSTRAINT CH_SYSDATE DEFAULT GETDATE() FOR READER_DATE;
ALTER TABLE TRADEIN1.BOOKS ADD CONSTRAINT CH_PUBL_YEAR CHECK (PUBL_YEAR > 1959);
