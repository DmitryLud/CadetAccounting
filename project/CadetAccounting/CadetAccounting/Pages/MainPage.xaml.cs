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
            GroupCB.Items.Add("Все");

            foreach (var item in CadetAccountingEntities.GetContext().Groups.ToList())
            {
                GroupCB.Items.Add(item.Name);
            }

            PaymentBtn.Click += (s, e) => { Manager.MainFrame.Navigate(new PaymentPage((DG.SelectedItem as Contract).ID)); };
            ClearBtn.Click += (s, e) => { Clear(); };
            ContractBtn.Click += (s, e) => { WordHelper.ReplaceText(DG.SelectedItem as Contract); };

            GroupCB.SelectionChanged += (s, e) => { Filter(); };
            SearchTB.TextChanged += (s, e) => { Filter(); };
            DateTB.TextChanged += (s, e) => { Filter(); };
            StepsTB.TextChanged += (s, e) => { Filter(); };

        }

        private void Clear()
        {
            GroupCB.Text = null;
            DateTB.Text = null;
            StepsTB.Text = null;
            SearchTB.Text = null;
        }

        private void Filter()
        {
            DG.ItemsSource = CadetAccountingEntities.GetContext().Contracts.ToList();
            SelectedGroup();
            SelectedDate();
            SelectedStep();
            Search();
        }
        private void Search()
        {
            string text = SearchTB.Text;
            if (text == null) return;
            DG.ItemsSource = (DG.ItemsSource as List<Contract>).Where(x => x.StepCount.ToString().Contains(text) ||
                x.DateOfConclusion.ToString().Contains(text) ||
                x.Cadet.Surname.Contains(text) ||
                x.Cadet.Name.Contains(text) ||
                x.Cadet.Patronymic.Contains(text) ||
                x.Cadet.Group.Name.Contains(text)
            ).ToList();
        }
        private void SelectedStep()
        {
            int steps;
            if (!int.TryParse(StepsTB.Text, out steps)) return;
            DG.ItemsSource = (DG.ItemsSource as List<Contract>).Where(x => x.StepCount == steps).ToList();
        }

        private void SelectedDate()
        {
            DateTime date;
            if (!DateTime.TryParse(DateTB.Text, out date)) return;
            DG.ItemsSource = (DG.ItemsSource as List<Contract>).Where(x => x.DateOfConclusion == date).ToList();
        }

        private void SelectedGroup()
        {
            if (GroupCB.SelectedValue == null) return;
            string group = GroupCB.SelectedValue.ToString();
            if(group == "Все") return;
            DG.ItemsSource = (DG.ItemsSource as List<Contract>).Where(x => x.Cadet.Group.Name == group).ToList();
        }

    }
}
