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

            PaymentBtn.Click += (s, e) => { MainFrame.Navigate(new MainPage()); };
            GroupBtn.Click += (s, e) => { MainFrame.Navigate(new GroupPage()); };
            CadetBtn.Click += (s, e) => { MainFrame.Navigate(new CadetPage()); };

        }
    }
}
