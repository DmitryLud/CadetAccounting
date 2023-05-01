using System.IO;
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
            MainFrame.Navigate(new MainPage());

            PaymentBtn.Click += (s, e) => { MainFrame.Navigate(new MainPage()); };
            GroupBtn.Click += (s, e) => { MainFrame.Navigate(new GroupPage()); };
            CadetBtn.Click += (s, e) => { MainFrame.Navigate(new CadetPage()); };
            ReportBtn.Click += (s, e) => { MainFrame.Navigate(new ReportPage()); };
            SchedulesBtn.Click += (s, e) => { MainFrame.Navigate(new ClassesPage()); };
            TeacherBtn.Click += (s, e) => { MainFrame.Navigate(new TeacherPage()); };
            ReadMeBtn.Click += (s, e) => { System.Diagnostics.Process.Start(Directory.GetCurrentDirectory() + @"\readme.pdf"); };

        }
    }
}
