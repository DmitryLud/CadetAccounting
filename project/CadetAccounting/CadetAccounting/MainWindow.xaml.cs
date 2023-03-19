using System.Windows;
using CadetAccounting.Pages;

namespace CadetAccounting
{
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            Manager.MainFrame = MainFrame;

            CadetBtn.Click += (s, e) => { MainFrame.Navigate(new CadetPage()); };

        }
    }
}
