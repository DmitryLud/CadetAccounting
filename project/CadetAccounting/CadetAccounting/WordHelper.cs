using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CadetAccounting.DBModel;
using Spire.Doc;
using System.IO;
using System.Security.Principal;
using System.Windows;
using System.Windows.Forms;

namespace CadetAccounting
{
    class WordHelper
    {
        public static void ReplaceText(Contract contract)
        {
            Document document = new Document(Directory.GetCurrentDirectory() + @"\contract.docx").Clone();

            document.Replace("<day>", DateTime.Now.Day.ToString(), false, true);
            document.Replace("<month>", DateTime.Now.ToString("MMMM"), false, true);
            document.Replace("<year>", DateTime.Now.Year.ToString(), false, true);
            document.Replace("<cadet>", contract.Cadet.Surname + " " + contract.Cadet.Name + " " + contract.Cadet.Patronymic, false, true);
            document.Replace("<license>", contract.Cadet.Group.LicenseCategory.Name, false, true);
            document.Replace("<studyLen>", (contract.Cadet.Group.DateEnd - contract.Cadet.Group.DateStart).Days.ToString(), false, true);
            document.Replace("<dateStart>", contract.Cadet.Group.DateStart.ToString("dd/MMMM/yyyy"), false, true);
            document.Replace("<price>", contract.TotalPrice.ToString(), false, true);

            try
            {
                string link;

                using (StreamReader reader = new StreamReader(Directory.GetCurrentDirectory() + @"\data.txt"))
                {
                    link = reader.ReadLine();
                }

                if (!string.IsNullOrEmpty(link) && !Directory.Exists(link))
                {
                    link = null;
                    using (StreamWriter writer = new StreamWriter(Directory.GetCurrentDirectory() + @"\data.txt"))
                    {
                        writer.Flush();
                    }
                }
                if (string.IsNullOrEmpty(link))
                {
                    FolderBrowserDialog folderBrowser = new FolderBrowserDialog();
                    DialogResult result = folderBrowser.ShowDialog();
                    if (!string.IsNullOrWhiteSpace(folderBrowser.SelectedPath))
                    {
                        using (StreamWriter writer = new StreamWriter(Directory.GetCurrentDirectory() + @"\data.txt"))
                        {
                            writer.WriteLine(folderBrowser.SelectedPath);
                            link = folderBrowser.SelectedPath;
                        }
                    }
                    else
                    {
                        System.Windows.MessageBox.Show("Выберите папку для сохранение файлов", "Внимание",MessageBoxButton.OK, MessageBoxImage.Warning);
                        return;
                    }
                }

                string newFilePath = link + $"\\{contract.DateOfConclusion.Day}_{contract.DateOfConclusion.Month}_{contract.DateOfConclusion.Year}_{contract.Cadet.Surname}_{contract.Cadet.Name}_{contract.Cadet.Patronymic}.docx";
                document.SaveToFile(newFilePath, FileFormat.Docx);
                System.Diagnostics.Process.Start(newFilePath);
            }
            catch (Exception)
            {

            }
        }
    }
}
