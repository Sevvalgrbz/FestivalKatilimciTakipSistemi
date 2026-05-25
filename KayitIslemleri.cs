using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.Data;

namespace FestivalKatilimciTakipSistemi.VeritabaniKatmani
{
    public class KayitIslemleri
    {
        public DataTable VerileriGetir(string yordamAdi)
        {
            MySqlConnection baglanti = MysqlBaglanti.Baglan();
            MySqlCommand komut = new MySqlCommand(yordamAdi, baglanti);
            komut.CommandType = CommandType.StoredProcedure;

            MySqlDataAdapter adapter = new MySqlDataAdapter(komut);
            DataTable tablo = new DataTable();
            adapter.Fill(tablo);

            return tablo;
        }

        public void YordamCalistir(string yordamAdi, Dictionary<string, object> veriler)
        {
            MySqlConnection baglanti = MysqlBaglanti.Baglan();
            MySqlCommand komut = new MySqlCommand(yordamAdi, baglanti);
            komut.CommandType = CommandType.StoredProcedure;

            foreach (var veri in veriler)
            {
                komut.Parameters.AddWithValue(veri.Key, veri.Value);
            }

            baglanti.Open();
            komut.ExecuteNonQuery();
            baglanti.Close();
        }
    }
}
