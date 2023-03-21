using Microsoft.Reporting.WinForms;
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
    public partial class ReportPage : Page
    {
        private bool _isReportViewerLoaded;
        private ReportDataSource _reportDataSource1;
        private CadetAccountingDataSet _CadetAccountingDataSet;
        CadetAccountingDataSetTableAdapters.PaymentGroupReportTableAdapter _paymentGroupReportTableAdapter;
        public ReportPage()
        {
            InitializeComponent();

            _reportDataSource1 = new ReportDataSource();
            _CadetAccountingDataSet = new CadetAccountingDataSet();
            _paymentGroupReportTableAdapter = new CadetAccountingDataSetTableAdapters.PaymentGroupReportTableAdapter();

            ReportView.Load += (s, e) => ReportViewer_Load();
            ReportBtn.Click += (s, e) => {
                try
                {
                    CreateReport(GroupTB.Text);
                }
                catch (Exception)
                {
                    
                }
            };

        }

        private void CreateReport(string group)
        {

            _CadetAccountingDataSet.BeginInit();

            _reportDataSource1.Value = _CadetAccountingDataSet.PaymentGroupReport;
            ReportView.LocalReport.DataSources.Add(_reportDataSource1);
            ReportView.LocalReport.ReportEmbeddedResource = "CadetAccounting.Report.Report.rdlc";

            _CadetAccountingDataSet.EndInit();


            _paymentGroupReportTableAdapter.ClearBeforeFill = true;
            _paymentGroupReportTableAdapter.Fill(_CadetAccountingDataSet.PaymentGroupReport, group);
            

            ReportView.RefreshReport();
        }

        private void ReportViewer_Load()
        {
            if (!_isReportViewerLoaded)
            {
                _CadetAccountingDataSet.BeginInit();

                _reportDataSource1.Name = "DataSet";
                _reportDataSource1.Value = _CadetAccountingDataSet.PaymentGroupReport;
                ReportView.LocalReport.DataSources.Add(_reportDataSource1);
                ReportView.LocalReport.ReportEmbeddedResource = "CadetAccounting.Report.Report.rdlc";

                _CadetAccountingDataSet.EndInit();


                _paymentGroupReportTableAdapter.ClearBeforeFill = true;

                ReportView.RefreshReport();

                _isReportViewerLoaded = true;
            }
        }

    }
}
