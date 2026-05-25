using MySql.Data.MySqlClient;

namespace FestivalKatilimciTakipSistemi.VeritabaniKatmani
{
    public class MysqlBaglanti
    {
        public static MySqlConnection Baglan()
        {
            string adres = "Server=localhost;Database=festival_takip;Uid=root;Pwd=Sevval.1905;Charset=utf8mb4;";
            return new MySqlConnection(adres);
        }
    }
}
