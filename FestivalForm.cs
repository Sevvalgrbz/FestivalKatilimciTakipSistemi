using FestivalKatilimciTakipSistemi.VeritabaniKatmani;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;

namespace FestivalKatilimciTakipSistemi.Formlar
{
    public class FestivalForm : Form
    {
        KayitIslemleri kayit = new KayitIslemleri();
        TabControl anaSekme = new TabControl();

        public FestivalForm()
        {
            Text = "Festival Katılımcı Takip Sistemi";
            Width = 1120;
            Height = 700;
            StartPosition = FormStartPosition.CenterScreen;

            anaSekme.Dock = DockStyle.Fill;
            Controls.Add(anaSekme);

            SayfalariHazirla();
        }

        void SayfalariHazirla()
        {
            SayfaEkle("Katılımcılar", "sp_KatilimciListele", "sp_KatilimciEkle", "sp_KatilimciGuncelle", "sp_KatilimciSil",
                new string[] { "p_katilimci_id", "p_ad", "p_soyad", "p_tc_no", "p_telefon", "p_eposta", "p_sehir" },
                new string[] { "Katılımcı ID", "Ad", "Soyad", "TC No", "Telefon", "E-posta", "Şehir" },
                0, new int[] { 1, 2, 3, 4, 5, 6 }, new int[] { 0, 1, 2, 4, 5, 6 });

            SayfaEkle("Etkinlikler", "sp_EtkinlikListele", "sp_EtkinlikEkle", "sp_EtkinlikGuncelle", "sp_EtkinlikSil",
                new string[] { "p_etkinlik_id", "p_etkinlik_adi", "p_sahne_adi", "p_etkinlik_tarihi", "p_baslangic_saati", "p_kapasite", "p_aciklama" },
                new string[] { "Etkinlik ID", "Etkinlik Adı", "Sahne Adı", "Tarih", "Başlangıç Saati", "Kapasite", "Açıklama" },
                0, new int[] { 1, 2, 3, 4, 5, 6 }, new int[] { 0, 1, 2, 3, 4, 5, 6 });

            SayfaEkle("Bilet Türleri", "sp_BiletTuruListele", "sp_BiletTuruEkle", "sp_BiletTuruGuncelle", "sp_BiletTuruSil",
                new string[] { "p_bilet_tur_id", "p_tur_adi", "p_fiyat", "p_aciklama" },
                new string[] { "Bilet Tür ID", "Tür Adı", "Fiyat", "Açıklama" },
                0, new int[] { 1, 2, 3 }, new int[] { 0, 1, 2, 3 });

            SayfaEkle("Biletler", "sp_BiletListele", "sp_BiletEkle", "sp_BiletGuncelle", "sp_BiletSil",
                new string[] { "p_bilet_id", "p_katilimci_id", "p_etkinlik_id", "p_bilet_tur_id", "p_bilet_kodu", "p_durum" },
                new string[] { "Bilet ID", "Katılımcı ID", "Etkinlik ID", "Bilet Tür ID", "Bilet Kodu", "Durum" },
                0, new int[] { 1, 2, 3, 4 }, new int[] { 0, 1, 2, 3, 4, 5 });

            SayfaEkle("Görevliler", "sp_GorevliListele", "sp_GorevliEkle", "sp_GorevliGuncelle", "sp_GorevliSil",
                new string[] { "p_gorevli_id", "p_ad", "p_soyad", "p_gorev", "p_telefon" },
                new string[] { "Görevli ID", "Ad", "Soyad", "Görev", "Telefon" },
                0, new int[] { 1, 2, 3, 4 }, new int[] { 0, 1, 2, 3, 4 });

            SayfaEkle("Katılım Kayıtları", "sp_KatilimKaydiListele", "sp_KatilimKaydiEkle", "sp_KatilimKaydiGuncelle", "sp_KatilimKaydiSil",
                new string[] { "p_kayit_id", "p_bilet_id", "p_gorevli_id", "p_giris_saati", "p_kontrol_durumu" },
                new string[] { "Kayıt ID", "Bilet ID", "Görevli ID", "Giriş Saati", "Kontrol Durumu" },
                0, new int[] { 1, 2, 3, 4 }, new int[] { 0, 2, 3, 4 });

            SayfaEkle("Ödemeler", "sp_OdemeListele", "sp_OdemeEkle", "sp_OdemeGuncelle", "sp_OdemeSil",
                new string[] { "p_odeme_id", "p_bilet_id", "p_tutar", "p_odeme_turu", "p_durum" },
                new string[] { "Ödeme ID", "Bilet ID", "Tutar", "Ödeme Türü", "Durum" },
                0, new int[] { 1, 2, 3 }, new int[] { 0, 2, 3, 4 });
        }

        void SayfaEkle(string baslik, string listeleYordam, string ekleYordam, string guncelleYordam, string silYordam,
            string[] parametreler, string[] etiketler, int idSirasi, int[] ekleAlanlari, int[] guncelleAlanlari)
        {
            TabPage sayfa = new TabPage(baslik);
            Panel sol = new Panel();
            DataGridView grid = new DataGridView();
            Dictionary<string, TextBox> kutular = new Dictionary<string, TextBox>();

            sol.Dock = DockStyle.Left;
            sol.Width = 310;
            sol.Padding = new Padding(10);

            grid.Dock = DockStyle.Fill;
            grid.ReadOnly = true;
            grid.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
            grid.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;

            int y = 10;

            Label baslikYazi = new Label();
            baslikYazi.Text = baslik + " İşlemleri";
            baslikYazi.Font = new Font("Segoe UI", 11, FontStyle.Bold);
            baslikYazi.Left = 10;
            baslikYazi.Top = y;
            baslikYazi.Width = 280;
            sol.Controls.Add(baslikYazi);
            y += 35;

            for (int i = 0; i < parametreler.Length; i++)
            {
                Label lbl = new Label();
                lbl.Text = etiketler[i];
                lbl.Left = 10;
                lbl.Top = y;
                lbl.Width = 280;
                sol.Controls.Add(lbl);
                y += 22;

                TextBox txt = new TextBox();
                txt.Left = 10;
                txt.Top = y;
                txt.Width = 275;

                if (i == idSirasi)
                {
                    txt.Enabled = false;
                }

                sol.Controls.Add(txt);
                kutular.Add(parametreler[i], txt);
                y += 32;
            }

            Button btnEkle = YeniButon("Ekle", 10, y);
            Button btnGuncelle = YeniButon("Güncelle", 105, y);
            Button btnSil = YeniButon("Sil", 200, y);
            y += 38;
            Button btnListele = YeniButon("Listele", 10, y, 275);

            sol.Controls.Add(btnEkle);
            sol.Controls.Add(btnGuncelle);
            sol.Controls.Add(btnSil);
            sol.Controls.Add(btnListele);

            sayfa.Controls.Add(grid);
            sayfa.Controls.Add(sol);
            anaSekme.TabPages.Add(sayfa);

            btnListele.Click += (s, e) => Listele(grid, listeleYordam);

            btnEkle.Click += (s, e) =>
            {
                try
                {
                    kayit.YordamCalistir(ekleYordam, DegerleriHazirla(parametreler, kutular, ekleAlanlari));
                    MessageBox.Show("Kayıt eklendi.");
                    Listele(grid, listeleYordam);
                }
                catch (Exception hata)
                {
                    MessageBox.Show(hata.Message);
                }
            };

            btnGuncelle.Click += (s, e) =>
            {
                try
                {
                    kayit.YordamCalistir(guncelleYordam, DegerleriHazirla(parametreler, kutular, guncelleAlanlari));
                    MessageBox.Show("Kayıt güncellendi.");
                    Listele(grid, listeleYordam);
                }
                catch (Exception hata)
                {
                    MessageBox.Show(hata.Message);
                }
            };

            btnSil.Click += (s, e) =>
            {
                try
                {
                    Dictionary<string, object> veri = new Dictionary<string, object>();
                    veri.Add(parametreler[idSirasi], kutular[parametreler[idSirasi]].Text);
                    kayit.YordamCalistir(silYordam, veri);
                    MessageBox.Show("Kayıt silindi.");
                    Listele(grid, listeleYordam);
                }
                catch (Exception hata)
                {
                    MessageBox.Show(hata.Message);
                }
            };

            grid.CellClick += (s, e) =>
            {
                if (e.RowIndex < 0) return;

                for (int i = 0; i < parametreler.Length; i++)
                {
                    string kolon = parametreler[i].Replace("p_", "");

                    if (grid.Columns.Contains(kolon))
                    {
                        kutular[parametreler[i]].Text = grid.Rows[e.RowIndex].Cells[kolon].Value.ToString();
                    }
                }
            };

            Listele(grid, listeleYordam);
        }

        Button YeniButon(string yazi, int x, int y, int genislik = 85)
        {
            Button btn = new Button();
            btn.Text = yazi;
            btn.Left = x;
            btn.Top = y;
            btn.Width = genislik;
            btn.Height = 30;
            return btn;
        }

        void Listele(DataGridView grid, string yordamAdi)
        {
            try
            {
                grid.DataSource = kayit.VerileriGetir(yordamAdi);
            }
            catch (Exception hata)
            {
                MessageBox.Show("Listeleme hatası: " + hata.Message);
            }
        }

        Dictionary<string, object> DegerleriHazirla(string[] parametreler, Dictionary<string, TextBox> kutular, int[] kullanilacaklar)
        {
            Dictionary<string, object> degerler = new Dictionary<string, object>();

            foreach (int sira in kullanilacaklar)
            {
                degerler.Add(parametreler[sira], kutular[parametreler[sira]].Text.Trim());
            }

            return degerler;
        }
    }
}
