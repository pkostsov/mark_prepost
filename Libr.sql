--������������ ������� ���������� �� ���� oracle, �� ������ ���������� � �� ������ ���� ��� �������������� ������
CREATE USER TRADEIN1 IDENTIFIED BY TRADEIN1; --������� ������������ (�����) 
--��� ����������� ���������� ���� ���������� �������  ����� �� ���������� ������� ��� ����������� ��������� �������� �����, ������, ������������ � ���� �������. ������� ��� 
--���������� � ������� ����������� �����������, ��� ��� �� ������������� ���������, � �������� ��������� ������� - �������� �� ��������.
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
--������� ������� � �������� � �������������
--������� ������ ����� �������, ����������� � ������, ������� ��������� � �������. ���� ����� ����� � �����������, �� ��� ������ ���������� ������ ����������� ��������� ������
--��������: "������ �.�." � "������ �.�., ������ �.�." - ��� ��������� ������. ��������, ����� �� ������� ��������� ���� ���� ���������� ���� �����, 
--��������������� � ������������� �� � ������ ��������� ������� �� ����� ������.
CREATE TABLE TRADEIN1.AUTHORS(AUTH_ID NUMBER  PRIMARY KEY, --���� �������������� ��������� �� ��������, �� ��� ����� ���������� ����� ������� ������������������. �� ������������, �.�. � ������ ����� ������ ��������
                                                            FIRST_NAME CHAR(100) NOT NULL,
                                                            FAMILY_NAME CHAR(100) NOT NULL,
                                                            THIRD_NAME CHAR(100),
                                                            BIRTH_DATE DATE
                                                            );
--������� ������� ��� ������. �� ������������ ������� ��� �� �������. � ��� ������ ������ ����                                                           
INSERT INTO TRADEIN1.AUTHORS VALUES (1, '������', '����', '��������', TO_DATE('01.09.2003', 'DD.MM.YYYY')); --INSERT INTO TRADEIN1.AUTHORS VALUES (1, '������', '����', '��������', CONVERT(DATETIME, '01.09.2003', 104));
INSERT INTO TRADEIN1.AUTHORS VALUES (2, '������', '����', '��������', TO_DATE('01.09.2003', 'DD.MM.YYYY'));    --INSERT INTO TRADEIN1.AUTHORS VALUES (1, '������', '����', '��������',CONVERT(DATETIME, '01.09.2003', 104));                                                      
--���������� ������
CREATE TABLE TRADEIN1.LANGS(LANG_ID NUMBER PRIMARY KEY,
                                                                  LANG_NAME CHAR(100)
                                                                  ); 
--������ ������ � �������-����������
INSERT INTO TRADEIN1.LANGS VALUES (1, '�������');
INSERT INTO TRADEIN1.LANGS VALUES (2, '����������');
COMMIT; --��������� ������
--���������� �������
CREATE  TABLE TRADEIN1.CITIES(CITY_ID NUMBER PRIMARY KEY,
                                                                  CITY_NAME CHAR(100));
INSERT INTO TRADEIN1.CITIES VALUES (1, '�����');
INSERT INTO TRADEIN1.CITIES VALUES (2, '������');
COMMIT;                                                                  
--���������� ����� ����������
CREATE TABLE TRADEIN1.PUBL_TYPE(PUBL_ID NUMBER PRIMARY KEY,
                                                                           PUBL_NAME CHAR(100)) ;
INSERT INTO TRADEIN1.PUBL_TYPE VALUES (1, '����������');
INSERT INTO TRADEIN1.PUBL_TYPE VALUES (2, '�������');
INSERT INTO TRADEIN1.PUBL_TYPE VALUES (3, '����������');  
COMMIT; 
--���������� �����������
CREATE TABLE TRADEIN1.PUBLISHERS(PUBLISH_ID NUMBER PRIMARY KEY, 
                                                                            PUBLISH_NAME CHAR(100),
                                                                            PUBLISH_ADDR CHAR(100),
                                                                            CITY_ID NUMBER);
ALTER TABLE TRADEIN1.PUBLISHERS ADD CONSTRAINT FK_CITY_ID FOREIGN KEY (CITY_ID) REFERENCES TRADEIN1.CITIES(CITY_ID);             
INSERT INTO TRADEIN1.PUBLISHERS VALUES (1, '�������', '��.���������������� 32', 1);
INSERT INTO TRADEIN1.PUBLISHERS VALUES (2, '�����-�����', '��.�������� 11', 2);
COMMIT;                                                      
--������� ������� ���������� �������� ������
CREATE TABLE TRADEIN1.KNOWL_AREA(KNOWL_ID NUMBER PRIMARY KEY,
                                                                                 KNOWL_ANAME CHAR(100)
                                                                                 );
INSERT INTO TRADEIN1.KNOWL_AREA VALUES (1, '����������');
INSERT INTO TRADEIN1.KNOWL_AREA VALUES (2, '�����');  
COMMIT; 
--������� ������� ��� ����������� ����� �������� �����
CREATE TABLE TRADEIN1.BOOK_PLACE(PLACE_ID NUMBER PRIMARY KEY, --���������� ������������� ����� �����
                                                                               ROOM_ID NUMBER CONSTRAINT CH_ROOM_VAL CHECK (ROOM_ID < 11), --����� �������
                                                                               STAND_ID NUMBER CONSTRAINT CH_STAND_VAL CHECK (STAND_ID < 31), --����� ��������
                                                                               SHELF_ID NUMBER CONSTRAINT CH_SHELF_VAL CHECK (SHELF_ID < 51) --����� �����                                  
                                                                                );
--������� ������� ��� �������� �������� ������������ �������
CREATE TABLE TRADEIN1.READER_CARDS(READER_ID NUMBER PRIMARY KEY, --������������� ������������� ������
                                                                                    READER_CARD CHAR(100) CHECK (COUNT(DISTINCT(READER_CARD))<4), --����� ������������� ������ (�� ������ ���� ��� ����� ��������� ��� � ����������� ����������
                                                                                    FIRST_NAME CHAR(100) NOT NULL, --������� ��������
                                                                                    FAMILY_NAME CHAR(100) NOT NULL, --��� ��������
                                                                                    THIRD_NAME CHAR(100), --�������� ��������
                                                                                    ADDRESS CHAR(100), --����� ��������
                                                                                    PHONE CHAR(50), --������� ��������
                                                                                    AGE NUMBER CHECK (AGE > 15) --���� ��������
                                                                                    );
--������� ������� ��������� ����������� ����                                                                                                                    
CREATE TABLE TRADEIN1.BOOKS (BOOK_ID CHAR(100) PRIMARY KEY, --������������� ���������� �����, �� �� ����������� ����� ����������
                                                                   BOOK_NAME CHAR(500),  --������������ �����
                                                                   AUTH_ID NUMBER,   --������ �� ������
                                                                   TOME_NUM CHAR(10), --����� ����, ��� �����. �� ��������� ��� ������, �.�. ����� ���� ����� ���� ������� ��� ���������
                                                                   ORIGINAL_LANG NUMBER,    --���� ���������
                                                                   TRANSLATE_LANG NUMBER, --���� ��������   
                                                                   PUBL_ID NUMBER,                   --��� �������
                                                                   KNOWL_ID NUMBER,      --������� ������ 
                                                                   TRANSLATOR_ID NUMBER, -- ����������
                                                                   PUBLISH_ID NUMBER, --������������
                                                                   PUBL_YEAR NUMBER,--��� ������� � �����
                                                                   LIBRARY_CARD CHAR(100), --������������ ���� 
                                                                   PRICE CHAR(100), --���� ����������
                                                                   PLACE_ID NUMBER,  --������ �� ������� ���������
                                                                   READER_ID NUMBER,    --������ �� �������� ��������. ���� ������ ������, �� ����� � ����������
                                                                   READER_DATE DATE  --���� ������ ����� �������� (���� ������� ����� �� ���������)
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
