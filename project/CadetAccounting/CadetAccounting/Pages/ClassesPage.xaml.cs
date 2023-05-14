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
    public partial class ClassesPage : Page
    {
        public ClassesPage()
        {
            InitializeComponent();

            GroupCB.ItemsSource = CadetAccountingEntities.GetContext().Groups.ToList();

            AddBtn.Click += (s, e) => { Manager.MainFrame.Navigate(new ClassesAddPage(GroupCB.SelectedItem as Group)); };
            EditBtn.Click += (s, e) => { Manager.MainFrame.Navigate(new ClassesAddPage(GroupCB.SelectedItem as Group, (DG.SelectedItem as ClassesList).Class)); };
            CancelBtn.Click += (s, e) => { Manager.MainFrame.Navigate(new MainPage()); };
            ExportBtn.Click += (s, e) => { Export(); };

            GroupCB.SelectionChanged += (s, e) => { SelectedGroup(); };

        }

        private void Export()
        {
            string data = "";

            List<ClassesList> groups = new List<ClassesList>();

            for (int i = 0; i < DG.Items.Count; i++)
            {
                groups.Add(DG.Items[i] as ClassesList);
                
            }


            WordHelper.SaveClasses(groups);
        }

        private void SelectedGroup()
        {
            if (GroupCB.SelectedItem == null) return;
            string group = (GroupCB.SelectedItem as Group).Name;
            DG.ItemsSource = CadetAccountingEntities.GetContext().ClassesLists.Where(x => x.Group.Name == group).ToList();
            TypeTB.Text = (GroupCB.SelectedItem as Group).Type;
        }
    }
}
