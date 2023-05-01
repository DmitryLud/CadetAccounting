using CadetAccounting.DBModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace CadetAccounting.Pages
{
    public partial class TeacherPage : Page
    {
        public TeacherPage()
        {
            InitializeComponent();

            DG.ItemsSource = CadetAccountingEntities.GetContext().Teachers.ToList();

            AddBtn.Click += (s, e) => { Manager.MainFrame.Navigate(new TeacherAddPage()); };
            EditBtn.Click += (s, e) => { Manager.MainFrame.Navigate(new TeacherAddPage(DG.SelectedItem as Teacher)); };
            CancelBtn.Click += (s, e) => { Manager.MainFrame.Navigate(new MainPage()); };

        }
    }
}
