#soal_view 5-6
#5
CREATE OR REPLACE VIEW peminjamanbulan7 AS
SELECT * FROM peminjaman
WHERE SUBSTRING(kode,1,1)='3' AND MONTH(tgl_pinjam)='7';

DROP VIEW peminjamanbulan7;
#6
CREATE OR REPLACE VIEW dendadiatas10k AS
SELECT DISTINCT a.id,a.nama,p.denda
FROM peminjaman p,anggota a 
WHERE a.`id`=p.`Peminjam` AND p.denda>10000;

DROP VIEW dendadiatas10k;
SELECT * FROM dendadiatas10k;

#soalnested 5-6
#5
SELECT a.* FROM anggota a WHERE a.id IN
(SELECT p.peminjam
FROM peminjaman p 
WHERE SUBSTRING(p.`kode`,1,1)='1' 
AND MONTH(p.`tgl_pinjam`)='10' OR 
SUBSTRING(p.`kode`,1,1)='3');

#6
SELECT MAX(banyak) FROM 
(SELECT COUNT(a.id_rb) AS banyak
FROM anggota a 
WHERE a.`role`="pustakawan"
GROUP BY a.id_rb)
t;

#set 5-6 ganti
#5
SELECT a.nama,p.pustakawan,p.`kode`,p.`tgl_kembali` 
FROM peminjaman p,anggota a
WHERE YEAR(p.tgl_kembali)='2018'
AND a.`id`=p.`Pustakawan` 
AND SUBSTRING(p.kode,1,1)='2'
UNION
SELECT a.nama,p.pustakawan,p.`kode`,p.`tgl_kembali`
FROM peminjaman p,anggota a
WHERE YEAR(p.tgl_kembali)='2018' 
AND a.`id`=p.`Pustakawan`
AND SUBSTRING(p.kode,1,1)='3';
#6
SELECT DISTINCT a.`id`,p.`tgl_pinjam`,p.`tgl_kembali` 
FROM anggota a, peminjaman p 
WHERE a.`id`=p.`Peminjam` AND MONTH(p.`tgl_pinjam`)='05'
AND a.`id` IN(SELECT a.`id` 
FROM anggota a, peminjaman p 
WHERE a.`id`=p.`Peminjam` AND MONTH(p.`tgl_kembali`)='05');

#index u/ set | boljug dipakai jawaban
CREATE INDEX index_peminjam ON peminjaman(peminjam,denda);
CREATE INDEX index_tgl_pinjam ON peminjaman(tgl_pinjam);

#procedure 5-6
#5
DELIMITER$$
CREATE OR REPLACE PROCEDURE peminjam_majalah() 
BEGIN
  SELECT DISTINCT a.nama,a.id_rb
  FROM anggota a NATURAL JOIN peminjaman p
	NATURAL JOIN majalah m
  WHERE m.judul="Piye Kabare";
  END$$
DELIMITER;

CALL peminjam_majalah();
#6

#function 5-6
#5
DELIMITER$$
CREATE OR REPLACE FUNCTION `denda`(id INT) 
RETURNS INT
    DETERMINISTIC
BEGIN
  DECLARE banyak INT;
  SELECT SUM(p.denda) INTO banyak
  FROM peminjaman p
  WHERE p.peminjam=id;
  RETURN banyak;
  END$$

SELECT DISTINCT `denda`("201006") FROM peminjaman;
#6
DELIMITER$$
CREATE OR REPLACE FUNCTION `bukudirb`(id CHAR(3)) 
RETURNS CHAR(3)
    DETERMINISTIC
BEGIN
  DECLARE banyak CHAR(3);
  SELECT COUNT(u.id_rb)INTO banyak
  FROM umum u 
  WHERE u.id_rb=id;
  RETURN banyak;
  END$$

SELECT DISTINCT `bukudirb`("001") FROM umum;


