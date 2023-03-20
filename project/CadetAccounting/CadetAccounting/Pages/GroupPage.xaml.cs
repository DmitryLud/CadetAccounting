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
    public partial class GroupPage : Page
    {
        private Group _current = new Group();
        public GroupPage(Group selected = null)
        {
            InitializeComponent();

            _current.DateStart = DateTime.Now;
            _current.DateEnd = _current.DateStart.AddDays(103);

            if (selected != null)
            {
                _current = selected;
            }
            DataContext = _current;

            LicenseCB.ItemsSource = CadetAccountingEntities.GetContext().LicenseCategories.ToList();

            SaveBtn.Click += (s, e) => { SaveData(); };
            CancelBtn.Click += (s, e) => { Manager.MainFrame.Navigate(new MainPage()); };

        }

        private void SaveData()
        {
            StringBuilder errors = new StringBuilder();
            if (string.IsNullOrWhiteSpace(_current.Name))
                errors.AppendLine("Введите название группы");
            if (CadetAccountingEntities.GetContext().Groups.Where(x=>x.Name == _current.Name).Count() != 0)
                errors.AppendLine("Группа с таким именем уже существует");
            if (_current.DateStart == null)
                errors.AppendLine("Введите дату начала");
            if (_current.DateEnd == null || _current.DateEnd < _current.DateStart)
                errors.AppendLine("Введите корректную дату окончания");
            if (_current.LicenseCategory == null)
                errors.AppendLine("Выберите категорию прав");

            if (errors.Length > 0)
            {
                MessageBox.Show(errors.ToString(), "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            if (_current.ID == 0)
                CadetAccountingEntities.GetContext().Groups.Add(_current);

            try
            {
                CadetAccountingEntities.GetContext().SaveChanges();
                MessageBox.Show("Данные успешно сохранены!", "Уведомление", MessageBoxButton.OK, MessageBoxImage.Information);
                Manager.MainFrame.Navigate(new MainPage());
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
    }
}
