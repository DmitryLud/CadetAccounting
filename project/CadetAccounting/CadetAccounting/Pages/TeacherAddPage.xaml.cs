using CadetAccounting.DBModel;
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

namespace CadetAccounting.Pages
{
    public partial class TeacherAddPage : Page
    {
        private Teacher _current = new Teacher();
        public TeacherAddPage(Teacher selected = null)
        {
            InitializeComponent();
            if (selected != null)
            {
                _current = selected;
            }
            DataContext = _current;

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

            if (errors.Length > 0)
            {
                MessageBox.Show(errors.ToString(), "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            if (_current.ID == 0)
                CadetAccountingEntities.GetContext().Teachers.Add(_current);

            try
            {
                CadetAccountingEntities.GetContext().SaveChanges();
                MessageBox.Show("Данные успешно сохранены!", "Уведомление", MessageBoxButton.OK, MessageBoxImage.Information);
                Manager.MainFrame.Navigate(new TeacherPage());
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
    }
}
