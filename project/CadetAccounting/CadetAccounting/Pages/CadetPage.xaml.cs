using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
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
    public partial class CadetPage : Page
    {
        private Cadet _current = new Cadet();
        public CadetPage(Cadet selected = null)
        {
            InitializeComponent();

            if (selected != null)
            {
                _current = selected;
            }
            DataContext = _current;

            GroupCB.ItemsSource = CadetAccountingEntities.GetContext().Groups.Where(x => x.Cadets.Count() < 30).ToList();

            SaveBtn.Click += (s, e) => { SaveData(); };
            CancelBtn.Click += (s, e) => { Manager.MainFrame.Navigate(new MainPage()); };

        }

        private void SaveData()
        {
            StringBuilder errors = new StringBuilder();
            if (string.IsNullOrWhiteSpace(_current.Surname))
                errors.AppendLine("Введите фамилию");
            if (string.IsNullOrWhiteSpace(_current.Name))
                errors.AppendLine("Введите имя");
            if (string.IsNullOrWhiteSpace(_current.Patronymic))
                errors.AppendLine("Введите отчество");
            if (string.IsNullOrWhiteSpace(_current.Phone) || !Regex.IsMatch(_current.Phone, @"\+375[0-9]{9}"))
                errors.AppendLine("Введите номер телефона");
            if (_current.Group == null)
                errors.AppendLine("Выберите группу");

            if (errors.Length > 0)
            {
                MessageBox.Show(errors.ToString(), "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            if (_current.ID == 0)
                CadetAccountingEntities.GetContext().Cadets.Add(_current);

            try
            {
                CadetAccountingEntities.GetContext().SaveChanges();
                if (MessageBox.Show("Данные успешно сохранены!\nХотите заключить договор?", "Уведомление", MessageBoxButton.YesNo, MessageBoxImage.Information) == MessageBoxResult.Yes)
                {
                    Manager.MainFrame.Navigate(new ContractPage(_current));
                    return;
                }
                Manager.MainFrame.Navigate(new MainPage());
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

    }
}
