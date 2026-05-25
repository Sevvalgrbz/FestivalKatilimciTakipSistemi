# Festival Katılımcı Takip Sistemi

Bu proje C# Windows Forms ve MySQL kullanılarak hazırlanmıştır.

## Kurulum

1. XAMPP Control Panel açılır.
2. Apache ve MySQL başlatılır.
3. Tarayıcıdan phpMyAdmin açılır:
   http://localhost/phpmyadmin
4. Üst menüden SQL veya İçe Aktar kısmı kullanılır.
5. `SqlDosyalari/festival_database.sql` dosyası çalıştırılır.
6. Visual Studio 2022 açılır.
7. `FestivalKatilimciTakipSistemi.csproj` dosyası açılır.
8. Üstteki Start butonuna basılarak uygulama çalıştırılır.

## Bağlantı Ayarı

Veritabanı bağlantısı `VeritabaniKatmani/MysqlBaglanti.cs` dosyasındadır.

Varsayılan bağlantı:

Server=localhost;Database=festival_takip;Uid=root;Pwd=;Charset=utf8mb4;

XAMPP kullanılıyorsa genelde root şifresi boş olduğu için bu bağlantı çalışır.
MySQL şifresi varsa `Pwd=;` kısmına şifre yazılmalıdır.

## Dosyalar

- `Formlar/FestivalForm.cs`: Uygulama ekranları
- `VeritabaniKatmani/MysqlBaglanti.cs`: MySQL bağlantısı
- `VeritabaniKatmani/KayitIslemleri.cs`: Stored procedure çağırma işlemleri
- `SqlDosyalari/festival_database.sql`: Veritabanı, tablolar, procedure, trigger ve örnek veriler

## Kısa Açıklama

Sistemde katılımcılar, etkinlikler, bilet türleri, biletler, görevliler, katılım kayıtları ve ödemeler takip edilmektedir.
Uygulama tarafında ekleme, güncelleme, silme ve listeleme işlemleri stored procedure ile yapılmaktadır.
