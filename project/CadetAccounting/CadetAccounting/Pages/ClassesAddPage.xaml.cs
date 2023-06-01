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
    public partial class ClassesAddPage : Page
    {
        private Class _current = new Class();
        private ClassesList classesList = new ClassesList();
        public ClassesAddPage(Group group, Class selected = null)
        {
            InitializeComponent();

            if (selected != null)
            {
                _current = selected;
            }

            DataContext = _current;
            classesList.Group = group;

            SaveBtn.Click += (s, e) => { SaveData(); };
            CancelBtn.Click += (s, e) => { Manager.MainFrame.Navigate(new MainPage()); };

        }
        private void SaveData()
        {
            StringBuilder errors = new StringBuilder();
            if (string.IsNullOrWhiteSpace(_current.Name))
                errors.AppendLine("Введите название темы занятия");
            if (_current.Date == null)
                errors.AppendLine("Введите дату");
            if (_current.RoomNumber <= 0)
                errors.AppendLine("Введите номер аудитории");

            if (errors.Length > 0)
            {
                MessageBox.Show(errors.ToString(), "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            classesList.Class = _current;

            if (_current.ID == 0)
                CadetAccountingEntities.GetContext().ClassesLists.Add(classesList);

            try
            {
                CadetAccountingEntities.GetContext().SaveChanges();
                MessageBox.Show("Данные успешно сохранены!", "Уведомление", MessageBoxButton.OK, MessageBoxImage.Information);
                Manager.MainFrame.Navigate(new ClassesPage());
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Ошибка", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
    }
}
