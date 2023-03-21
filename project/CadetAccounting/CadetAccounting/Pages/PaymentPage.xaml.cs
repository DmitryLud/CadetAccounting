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
    public partial class PaymentPage : Page
    {
        public PaymentPage(int contractID)
        {
            InitializeComponent();

            DG.ItemsSource = CadetAccountingEntities.GetContext().Payments.Where(x=>x.ContractID==contractID).ToList();

            CancelBtn.Click += (s, e) => { Manager.MainFrame.GoBack(); };
            SaveBtn.Click += (s, e) => { Save(); };

        }

        private void Save()
        {
            try
            {
                if (CadetAccountingEntities.GetContext().SaveChanges() != 0)
                    MessageBox.Show("Данные успешно сохранены!", "Уведомление", MessageBoxButton.YesNo, MessageBoxImage.Information);
                Manager.MainFrame.Navigate(new MainPage());
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

    }
}
