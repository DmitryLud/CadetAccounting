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
    public partial class ContractPage : Page
    {
        private Contract _current = new Contract();
        public ContractPage(Cadet cadet)
        {
            InitializeComponent();

            _current.Cadet = cadet;
            _current.DateOfConclusion = DateTime.Now;

            DataContext = _current;

            CadetTBlock.Text += $"{_current.Cadet.Surname} {_current.Cadet.Name} {_current.Cadet.Patronymic}";
            DateTBlock.Text += $"{_current.DateOfConclusion.Day} {_current.DateOfConclusion.Month} {_current.DateOfConclusion.Year}"; 

            StepPriceTB.TextChanged += (s, e) => { SetTotal(); };
            StepCountTB.TextChanged += (s, e) => { SetTotal(); };

            SaveBtn.Click += (s, e) => { SaveData(); };
            CancelBtn.Click += (s, e) => { Manager.MainFrame.Navigate(new MainPage()); };

        }

        private void SetTotal()
        {
            decimal stepPrice;
            int stepCount;
            if (!decimal.TryParse(StepPriceTB.Text, out stepPrice) || !int.TryParse(StepCountTB.Text, out stepCount)) return;

            TotalTBlock.Text = "Итог: " + (stepPrice * stepCount).ToString();
            _current.TotalPrice = stepPrice * stepCount;
        }

        private void SaveData()
        {
            StringBuilder errors = new StringBuilder();
            if (_current.StepPrice<=0)
                errors.AppendLine("Введите стоимость этапа");
            if (_current.StepCount<=0)
                errors.AppendLine("Введите количество этапов");

            if (errors.Length > 0)
            {
                MessageBox.Show(errors.ToString(), "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            if (_current.ID == 0)
                CadetAccountingEntities.GetContext().Contracts.Add(_current);

            try
            {
                CadetAccountingEntities.GetContext().SaveChanges();
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
