using System;
using System.Windows.Forms;

namespace FestivalKatilimciTakipSistemi
{
    internal static class Program
    {
        [STAThread]
        static void Main()
        {
            ApplicationConfiguration.Initialize();
            Application.Run(new Formlar.FestivalForm());
        }
    }
}
