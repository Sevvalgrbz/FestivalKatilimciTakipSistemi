CREATE DATABASE IF NOT EXISTS festival_takip CHARACTER SET utf8mb4 COLLATE utf8mb4_turkish_ci;
USE festival_takip;

CREATE TABLE IF NOT EXISTS katilimcilar (
    katilimci_id INT AUTO_INCREMENT PRIMARY KEY,
    ad VARCHAR(50) NOT NULL,
    soyad VARCHAR(50) NOT NULL,
    tc_no VARCHAR(11) NOT NULL UNIQUE,
    telefon VARCHAR(20) NOT NULL,
    eposta VARCHAR(100) UNIQUE,
    sehir VARCHAR(50) NOT NULL,
    kayit_tarihi DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS etkinlikler (
    etkinlik_id INT AUTO_INCREMENT PRIMARY KEY,
    etkinlik_adi VARCHAR(100) NOT NULL,
    sahne_adi VARCHAR(80) NOT NULL,
    etkinlik_tarihi DATE NOT NULL,
    baslangic_saati TIME NOT NULL,
    kapasite INT NOT NULL,
    aciklama VARCHAR(250),
    CHECK (kapasite > 0)
);

CREATE TABLE IF NOT EXISTS bilet_turleri (
    bilet_tur_id INT AUTO_INCREMENT PRIMARY KEY,
    tur_adi VARCHAR(50) NOT NULL UNIQUE,
    fiyat DECIMAL(10,2) NOT NULL,
    aciklama VARCHAR(250),
    CHECK (fiyat > 0)
);

CREATE TABLE IF NOT EXISTS biletler (
    bilet_id INT AUTO_INCREMENT PRIMARY KEY,
    katilimci_id INT NOT NULL,
    etkinlik_id INT NOT NULL,
    bilet_tur_id INT NOT NULL,
    bilet_kodu VARCHAR(30) NOT NULL UNIQUE,
    alis_tarihi DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    durum VARCHAR(20) NOT NULL DEFAULT 'Aktif',
    FOREIGN KEY (katilimci_id) REFERENCES katilimcilar(katilimci_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (etkinlik_id) REFERENCES etkinlikler(etkinlik_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (bilet_tur_id) REFERENCES bilet_turleri(bilet_tur_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CHECK (durum IN ('Aktif','İptal','Kullanıldı'))
);

CREATE TABLE IF NOT EXISTS gorevliler (
    gorevli_id INT AUTO_INCREMENT PRIMARY KEY,
    ad VARCHAR(50) NOT NULL,
    soyad VARCHAR(50) NOT NULL,
    gorev VARCHAR(60) NOT NULL,
    telefon VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS katilim_kayitlari (
    kayit_id INT AUTO_INCREMENT PRIMARY KEY,
    bilet_id INT NOT NULL UNIQUE,
    gorevli_id INT NOT NULL,
    giris_saati DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    kontrol_durumu VARCHAR(20) NOT NULL,
    FOREIGN KEY (bilet_id) REFERENCES biletler(bilet_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (gorevli_id) REFERENCES gorevliler(gorevli_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CHECK (kontrol_durumu IN ('Onaylandı','Reddedildi'))
);

CREATE TABLE IF NOT EXISTS odemeler (
    odeme_id INT AUTO_INCREMENT PRIMARY KEY,
    bilet_id INT NOT NULL,
    odeme_tarihi DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tutar DECIMAL(10,2) NOT NULL,
    odeme_turu VARCHAR(30) NOT NULL,
    durum VARCHAR(20) NOT NULL DEFAULT 'Ödendi',
    FOREIGN KEY (bilet_id) REFERENCES biletler(bilet_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CHECK (tutar > 0),
    CHECK (odeme_turu IN ('Nakit','Kredi Kartı','Havale')),
    CHECK (durum IN ('Ödendi','İade'))
);

DROP PROCEDURE IF EXISTS sp_KatilimciEkle;
DROP PROCEDURE IF EXISTS sp_KatilimciGuncelle;
DROP PROCEDURE IF EXISTS sp_KatilimciSil;
DROP PROCEDURE IF EXISTS sp_KatilimciListele;
DROP PROCEDURE IF EXISTS sp_EtkinlikEkle;
DROP PROCEDURE IF EXISTS sp_EtkinlikGuncelle;
DROP PROCEDURE IF EXISTS sp_EtkinlikSil;
DROP PROCEDURE IF EXISTS sp_EtkinlikListele;
DROP PROCEDURE IF EXISTS sp_BiletTuruEkle;
DROP PROCEDURE IF EXISTS sp_BiletTuruGuncelle;
DROP PROCEDURE IF EXISTS sp_BiletTuruSil;
DROP PROCEDURE IF EXISTS sp_BiletTuruListele;
DROP PROCEDURE IF EXISTS sp_BiletEkle;
DROP PROCEDURE IF EXISTS sp_BiletGuncelle;
DROP PROCEDURE IF EXISTS sp_BiletSil;
DROP PROCEDURE IF EXISTS sp_BiletListele;
DROP PROCEDURE IF EXISTS sp_GorevliEkle;
DROP PROCEDURE IF EXISTS sp_GorevliGuncelle;
DROP PROCEDURE IF EXISTS sp_GorevliSil;
DROP PROCEDURE IF EXISTS sp_GorevliListele;
DROP PROCEDURE IF EXISTS sp_KatilimKaydiEkle;
DROP PROCEDURE IF EXISTS sp_KatilimKaydiGuncelle;
DROP PROCEDURE IF EXISTS sp_KatilimKaydiSil;
DROP PROCEDURE IF EXISTS sp_KatilimKaydiListele;
DROP PROCEDURE IF EXISTS sp_OdemeEkle;
DROP PROCEDURE IF EXISTS sp_OdemeGuncelle;
DROP PROCEDURE IF EXISTS sp_OdemeSil;
DROP PROCEDURE IF EXISTS sp_OdemeListele;

DELIMITER $$

CREATE PROCEDURE sp_KatilimciEkle(IN p_ad VARCHAR(50), IN p_soyad VARCHAR(50), IN p_tc_no VARCHAR(11), IN p_telefon VARCHAR(20), IN p_eposta VARCHAR(100), IN p_sehir VARCHAR(50))
BEGIN
    INSERT INTO katilimcilar(ad, soyad, tc_no, telefon, eposta, sehir)
    VALUES(p_ad, p_soyad, p_tc_no, p_telefon, p_eposta, p_sehir);
END $$

CREATE PROCEDURE sp_KatilimciGuncelle(IN p_katilimci_id INT, IN p_ad VARCHAR(50), IN p_soyad VARCHAR(50), IN p_telefon VARCHAR(20), IN p_eposta VARCHAR(100), IN p_sehir VARCHAR(50))
BEGIN
    UPDATE katilimcilar SET ad=p_ad, soyad=p_soyad, telefon=p_telefon, eposta=p_eposta, sehir=p_sehir WHERE katilimci_id=p_katilimci_id;
END $$

CREATE PROCEDURE sp_KatilimciSil(IN p_katilimci_id INT)
BEGIN
    DELETE FROM katilimcilar WHERE katilimci_id=p_katilimci_id;
END $$

CREATE PROCEDURE sp_KatilimciListele()
BEGIN
    SELECT * FROM katilimcilar ORDER BY katilimci_id DESC;
END $$

CREATE PROCEDURE sp_EtkinlikEkle(IN p_etkinlik_adi VARCHAR(100), IN p_sahne_adi VARCHAR(80), IN p_etkinlik_tarihi DATE, IN p_baslangic_saati TIME, IN p_kapasite INT, IN p_aciklama VARCHAR(250))
BEGIN
    INSERT INTO etkinlikler(etkinlik_adi, sahne_adi, etkinlik_tarihi, baslangic_saati, kapasite, aciklama)
    VALUES(p_etkinlik_adi, p_sahne_adi, p_etkinlik_tarihi, p_baslangic_saati, p_kapasite, p_aciklama);
END $$

CREATE PROCEDURE sp_EtkinlikGuncelle(IN p_etkinlik_id INT, IN p_etkinlik_adi VARCHAR(100), IN p_sahne_adi VARCHAR(80), IN p_etkinlik_tarihi DATE, IN p_baslangic_saati TIME, IN p_kapasite INT, IN p_aciklama VARCHAR(250))
BEGIN
    UPDATE etkinlikler SET etkinlik_adi=p_etkinlik_adi, sahne_adi=p_sahne_adi, etkinlik_tarihi=p_etkinlik_tarihi, baslangic_saati=p_baslangic_saati, kapasite=p_kapasite, aciklama=p_aciklama WHERE etkinlik_id=p_etkinlik_id;
END $$

CREATE PROCEDURE sp_EtkinlikSil(IN p_etkinlik_id INT)
BEGIN
    DELETE FROM etkinlikler WHERE etkinlik_id=p_etkinlik_id;
END $$

CREATE PROCEDURE sp_EtkinlikListele()
BEGIN
    SELECT * FROM etkinlikler ORDER BY etkinlik_tarihi, baslangic_saati;
END $$

CREATE PROCEDURE sp_BiletTuruEkle(IN p_tur_adi VARCHAR(50), IN p_fiyat DECIMAL(10,2), IN p_aciklama VARCHAR(250))
BEGIN
    INSERT INTO bilet_turleri(tur_adi, fiyat, aciklama) VALUES(p_tur_adi, p_fiyat, p_aciklama);
END $$

CREATE PROCEDURE sp_BiletTuruGuncelle(IN p_bilet_tur_id INT, IN p_tur_adi VARCHAR(50), IN p_fiyat DECIMAL(10,2), IN p_aciklama VARCHAR(250))
BEGIN
    UPDATE bilet_turleri SET tur_adi=p_tur_adi, fiyat=p_fiyat, aciklama=p_aciklama WHERE bilet_tur_id=p_bilet_tur_id;
END $$

CREATE PROCEDURE sp_BiletTuruSil(IN p_bilet_tur_id INT)
BEGIN
    DELETE FROM bilet_turleri WHERE bilet_tur_id=p_bilet_tur_id;
END $$

CREATE PROCEDURE sp_BiletTuruListele()
BEGIN
    SELECT * FROM bilet_turleri ORDER BY bilet_tur_id DESC;
END $$

CREATE PROCEDURE sp_BiletEkle(IN p_katilimci_id INT, IN p_etkinlik_id INT, IN p_bilet_tur_id INT, IN p_bilet_kodu VARCHAR(30))
BEGIN
    INSERT INTO biletler(katilimci_id, etkinlik_id, bilet_tur_id, bilet_kodu)
    VALUES(p_katilimci_id, p_etkinlik_id, p_bilet_tur_id, p_bilet_kodu);
END $$

CREATE PROCEDURE sp_BiletGuncelle(IN p_bilet_id INT, IN p_katilimci_id INT, IN p_etkinlik_id INT, IN p_bilet_tur_id INT, IN p_bilet_kodu VARCHAR(30), IN p_durum VARCHAR(20))
BEGIN
    UPDATE biletler SET katilimci_id=p_katilimci_id, etkinlik_id=p_etkinlik_id, bilet_tur_id=p_bilet_tur_id, bilet_kodu=p_bilet_kodu, durum=p_durum WHERE bilet_id=p_bilet_id;
END $$

CREATE PROCEDURE sp_BiletSil(IN p_bilet_id INT)
BEGIN
    DELETE FROM biletler WHERE bilet_id=p_bilet_id;
END $$

CREATE PROCEDURE sp_BiletListele()
BEGIN
    SELECT b.bilet_id, b.bilet_kodu, CONCAT(k.ad,' ',k.soyad) AS katilimci, e.etkinlik_adi, bt.tur_adi, bt.fiyat, b.durum
    FROM biletler b
    INNER JOIN katilimcilar k ON b.katilimci_id=k.katilimci_id
    INNER JOIN etkinlikler e ON b.etkinlik_id=e.etkinlik_id
    INNER JOIN bilet_turleri bt ON b.bilet_tur_id=bt.bilet_tur_id
    ORDER BY b.bilet_id DESC;
END $$

CREATE PROCEDURE sp_GorevliEkle(IN p_ad VARCHAR(50), IN p_soyad VARCHAR(50), IN p_gorev VARCHAR(60), IN p_telefon VARCHAR(20))
BEGIN
    INSERT INTO gorevliler(ad, soyad, gorev, telefon) VALUES(p_ad, p_soyad, p_gorev, p_telefon);
END $$

CREATE PROCEDURE sp_GorevliGuncelle(IN p_gorevli_id INT, IN p_ad VARCHAR(50), IN p_soyad VARCHAR(50), IN p_gorev VARCHAR(60), IN p_telefon VARCHAR(20))
BEGIN
    UPDATE gorevliler SET ad=p_ad, soyad=p_soyad, gorev=p_gorev, telefon=p_telefon WHERE gorevli_id=p_gorevli_id;
END $$

CREATE PROCEDURE sp_GorevliSil(IN p_gorevli_id INT)
BEGIN
    DELETE FROM gorevliler WHERE gorevli_id=p_gorevli_id;
END $$

CREATE PROCEDURE sp_GorevliListele()
BEGIN
    SELECT * FROM gorevliler ORDER BY gorevli_id DESC;
END $$

CREATE PROCEDURE sp_KatilimKaydiEkle(IN p_bilet_id INT, IN p_gorevli_id INT, IN p_giris_saati DATETIME, IN p_kontrol_durumu VARCHAR(20))
BEGIN
    INSERT INTO katilim_kayitlari(bilet_id, gorevli_id, giris_saati, kontrol_durumu)
    VALUES(p_bilet_id, p_gorevli_id, p_giris_saati, p_kontrol_durumu);
END $$

CREATE PROCEDURE sp_KatilimKaydiGuncelle(IN p_kayit_id INT, IN p_gorevli_id INT, IN p_giris_saati DATETIME, IN p_kontrol_durumu VARCHAR(20))
BEGIN
    UPDATE katilim_kayitlari SET gorevli_id=p_gorevli_id, giris_saati=p_giris_saati, kontrol_durumu=p_kontrol_durumu WHERE kayit_id=p_kayit_id;
END $$

CREATE PROCEDURE sp_KatilimKaydiSil(IN p_kayit_id INT)
BEGIN
    DELETE FROM katilim_kayitlari WHERE kayit_id=p_kayit_id;
END $$

CREATE PROCEDURE sp_KatilimKaydiListele()
BEGIN
    SELECT kk.kayit_id, b.bilet_kodu, CONCAT(k.ad,' ',k.soyad) AS katilimci, CONCAT(g.ad,' ',g.soyad) AS gorevli, kk.giris_saati, kk.kontrol_durumu
    FROM katilim_kayitlari kk
    INNER JOIN biletler b ON kk.bilet_id=b.bilet_id
    INNER JOIN katilimcilar k ON b.katilimci_id=k.katilimci_id
    INNER JOIN gorevliler g ON kk.gorevli_id=g.gorevli_id
    ORDER BY kk.kayit_id DESC;
END $$

CREATE PROCEDURE sp_OdemeEkle(IN p_bilet_id INT, IN p_tutar DECIMAL(10,2), IN p_odeme_turu VARCHAR(30))
BEGIN
    INSERT INTO odemeler(bilet_id, tutar, odeme_turu) VALUES(p_bilet_id, p_tutar, p_odeme_turu);
END $$

CREATE PROCEDURE sp_OdemeGuncelle(IN p_odeme_id INT, IN p_tutar DECIMAL(10,2), IN p_odeme_turu VARCHAR(30), IN p_durum VARCHAR(20))
BEGIN
    UPDATE odemeler SET tutar=p_tutar, odeme_turu=p_odeme_turu, durum=p_durum WHERE odeme_id=p_odeme_id;
END $$

CREATE PROCEDURE sp_OdemeSil(IN p_odeme_id INT)
BEGIN
    DELETE FROM odemeler WHERE odeme_id=p_odeme_id;
END $$

CREATE PROCEDURE sp_OdemeListele()
BEGIN
    SELECT o.odeme_id, b.bilet_kodu, CONCAT(k.ad,' ',k.soyad) AS katilimci, o.tutar, o.odeme_turu, o.durum, o.odeme_tarihi
    FROM odemeler o
    INNER JOIN biletler b ON o.bilet_id=b.bilet_id
    INNER JOIN katilimcilar k ON b.katilimci_id=k.katilimci_id
    ORDER BY o.odeme_id DESC;
END $$

DROP TRIGGER IF EXISTS tg_KapasiteKontrol $$
CREATE TRIGGER tg_KapasiteKontrol
BEFORE INSERT ON biletler
FOR EACH ROW
BEGIN
    DECLARE satilan INT;
    DECLARE etkinlik_kapasite INT;

    SELECT COUNT(*) INTO satilan FROM biletler WHERE etkinlik_id=NEW.etkinlik_id AND durum <> 'İptal';
    SELECT kapasite INTO etkinlik_kapasite FROM etkinlikler WHERE etkinlik_id=NEW.etkinlik_id;

    IF satilan >= etkinlik_kapasite THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Bu etkinlik için kapasite dolmuştur.';
    END IF;
END $$

DROP TRIGGER IF EXISTS tg_GirisSonrasiBiletKullanildi $$
CREATE TRIGGER tg_GirisSonrasiBiletKullanildi
AFTER INSERT ON katilim_kayitlari
FOR EACH ROW
BEGIN
    IF NEW.kontrol_durumu='Onaylandı' THEN
        UPDATE biletler SET durum='Kullanıldı' WHERE bilet_id=NEW.bilet_id;
    END IF;
END $$

DROP TRIGGER IF EXISTS tg_IptalBileteOdemeEngelle $$
CREATE TRIGGER tg_IptalBileteOdemeEngelle
BEFORE INSERT ON odemeler
FOR EACH ROW
BEGIN
    DECLARE bilet_durumu VARCHAR(20);
    SELECT durum INTO bilet_durumu FROM biletler WHERE bilet_id=NEW.bilet_id;

    IF bilet_durumu='İptal' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='İptal edilmiş bilet için ödeme eklenemez.';
    END IF;
END $$

DELIMITER ;

CALL sp_KatilimciEkle('Ali','Yıldız','11111111111','05551111111','ali@mail.com','Bartın');
CALL sp_KatilimciEkle('Ayşe','Demir','22222222222','05552222222','ayse@mail.com','Ankara');
CALL sp_KatilimciEkle('Mehmet','Kara','33333333333','05553333333','mehmet@mail.com','İstanbul');
CALL sp_KatilimciEkle('Zeynep','Koç','44444444444','05554444444','zeynep@mail.com','İzmir');

CALL sp_EtkinlikEkle('Yaz Müzik Festivali','Ana Sahne','2026-07-10','20:00:00',500,'Akşam konser etkinliği');
CALL sp_EtkinlikEkle('Gençlik Konseri','Sahne 2','2026-07-11','18:30:00',300,'Gençlik konser programı');
CALL sp_EtkinlikEkle('DJ Performans Gecesi','Elektronik Sahne','2026-07-12','22:00:00',250,'DJ performans etkinliği');

CALL sp_BiletTuruEkle('Standart',750.00,'Normal giriş bileti');
CALL sp_BiletTuruEkle('VIP',1500.00,'Ön alan ve özel giriş');
CALL sp_BiletTuruEkle('Öğrenci',500.00,'Öğrenci indirimi');

CALL sp_GorevliEkle('Hasan','Aydın','Giriş Kontrol','05556667788');
CALL sp_GorevliEkle('Merve','Çelik','Bilet Kontrol','05557778899');
CALL sp_GorevliEkle('Emre','Şahin','Danışma','05558889900');

CALL sp_BiletEkle(1,1,1,'FEST-1001');
CALL sp_BiletEkle(2,1,2,'FEST-1002');
CALL sp_BiletEkle(3,2,3,'FEST-1003');
CALL sp_BiletEkle(4,3,1,'FEST-1004');

CALL sp_OdemeEkle(1,750.00,'Nakit');
CALL sp_OdemeEkle(2,1500.00,'Kredi Kartı');
CALL sp_OdemeEkle(3,500.00,'Havale');
CALL sp_OdemeEkle(4,750.00,'Nakit');

CALL sp_KatilimKaydiEkle(1,1,'2026-07-10 19:30:00','Onaylandı');
CALL sp_KatilimKaydiEkle(2,2,'2026-07-10 19:45:00','Onaylandı');
