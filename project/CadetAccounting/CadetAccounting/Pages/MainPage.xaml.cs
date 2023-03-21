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
using CadetAccounting.DBModel;

namespace CadetAccounting.Pages
{
    public partial class MainPage : Page
    {
        public MainPage()
        {
            InitializeComponent();

            DG.ItemsSource = CadetAccountingEntities.GetContext().Contracts.ToList();

            PaymentBtn.Click += (s, e) => { Manager.MainFrame.Navigate(new PaymentPage((DG.SelectedItem as Contract).ID)); };

        }



    }
}
