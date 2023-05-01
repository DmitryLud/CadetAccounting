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
        private List<Teacher> teachers = CadetAccountingEntities.GetContext().Teachers.ToList();
        public GroupPage(Group selected = null)
        {
            InitializeComponent();

            _current.DateStart = DateTime.Now.AddDays(7);
            _current.DateEnd = _current.DateStart.AddDays(103);

            if (selected != null)
            {
                _current = selected;
            }
            DataContext = _current;

            LicenseCB.ItemsSource = CadetAccountingEntities.GetContext().LicenseCategories.ToList();
            TypeCB.ItemsSource = new List<String> { "Утренняя", "Вечерняя", "Выходного дня"};

            List<String> list = new List<String>();

            for (int i = 0; i < teachers.Count; i++)
            {
                list.Add(teachers[i].Surname + " " + teachers[i].Name[0] + ". " + teachers[i].Patronymic[0] + ".");
            }

            TeacherCB.ItemsSource = list;

            SaveBtn.Click += (s, e) => { SaveData(); };
            CancelBtn.Click += (s, e) => { Manager.MainFrame.Navigate(new MainPage()); };
            TeacherCB.SelectionChanged += (s, e) => { SelectedTeacher(); };

        }

        private void SelectedTeacher()
        {
            if (TeacherCB.SelectedValue == null) return;
            string[] teacher = TeacherCB.SelectedValue.ToString().Split(' ');

            for (int i = 0; i < teachers.Count; i++)
            {
                if(teachers[i].Surname == teacher[0] && teachers[i].Name[0] == teacher[1][0] && teachers[i].Patronymic[0] == teacher[2][0])
                {
                    _current.Teacher = teachers[i];
                }
            }
        }

        private void SaveData()
        {
            StringBuilder errors = new StringBuilder();
            if (string.IsNullOrWhiteSpace(_current.Name))
                errors.AppendLine("Введите название группы");
            if (string.IsNullOrWhiteSpace(_current.Type))
                errors.AppendLine("Выберите формат обучения");
            if (CadetAccountingEntities.GetContext().Groups.Where(x=>x.Name == _current.Name).Count() != 0)
                errors.AppendLine("Группа с таким именем уже существует");
            if (_current.DateStart == null || _current.DateStart <= DateTime.Now)
                errors.AppendLine("Введите корректную дату начала");
            if (_current.DateEnd == null || _current.DateEnd < _current.DateStart)
                errors.AppendLine("Введите корректную дату окончания");
            if (_current.LicenseCategory == null)
                errors.AppendLine("Выберите категорию прав");
            if (_current.Teacher == null)
                errors.AppendLine("Выберите преподавателя");

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
