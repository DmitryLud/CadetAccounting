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
using Spire.Doc.Documents;
using Spire.Doc.Fields;

namespace CadetAccounting
{
    class WordHelper
    {
        public static void SaveClasses(List<ClassesList> groups)
        {
            string[][] data = new string[groups.Count()][];

            for (int i = 0; i < groups.Count(); i++)
            {
                data[i] = new string[] { groups[i].Class.Name, groups[i].Class.Date.ToString("dd/MMMM/yyyy"), groups[i].Class.Time.Hours.ToString() + ":" + groups[i].Class.Time.Minutes.ToString(), groups[i].Class.RoomNumber.ToString() };
            }

            Document document = new Document();
            Section section = document.AddSection();
            Paragraph par = section.AddParagraph();

            par.Text = "Группа: " + groups[0].Group.Name + "\nПреподаватель: " + groups[0].Group.Teacher.Surname + " " + groups[0].Group.Teacher.Name + " " + groups[0].Group.Teacher.Patronymic;

            Table table = section.AddTable(true);
            table.ResetCells(data.Length + 1, 4);

            TableRow FRow = table.Rows[0];
            FRow.IsHeader = true;

            FRow.Height = 23;

            Paragraph p = FRow.Cells[0].AddParagraph();
            FRow.Cells[0].CellFormat.VerticalAlignment = Spire.Doc.Documents.VerticalAlignment.Middle;
            p.Format.HorizontalAlignment = Spire.Doc.Documents.HorizontalAlignment.Center;
            TextRange TR = p.AppendText("Тема занятия");

            Paragraph p1 = FRow.Cells[1].AddParagraph();
            FRow.Cells[1].CellFormat.VerticalAlignment = Spire.Doc.Documents.VerticalAlignment.Middle;
            p1.Format.HorizontalAlignment = Spire.Doc.Documents.HorizontalAlignment.Center;
            TextRange TR1 = p1.AppendText("Дата занятия");

            Paragraph p2 = FRow.Cells[2].AddParagraph();
            FRow.Cells[2].CellFormat.VerticalAlignment = Spire.Doc.Documents.VerticalAlignment.Middle;
            p1.Format.HorizontalAlignment = Spire.Doc.Documents.HorizontalAlignment.Center;
            TextRange TR2 = p2.AppendText("Время занятия");

            Paragraph p3 = FRow.Cells[3].AddParagraph();
            FRow.Cells[3].CellFormat.VerticalAlignment = Spire.Doc.Documents.VerticalAlignment.Middle;
            p1.Format.HorizontalAlignment = Spire.Doc.Documents.HorizontalAlignment.Center;
            TextRange TR3 = p3.AppendText("№ кабинета");

            for (int r = 0; r < data.Length; r++)
            {
                
                TableRow DataRow = table.Rows[r + 1];
                DataRow.Height = 20;
                
                for (int c = 0; c < data[r].Length; c++)
                {
                    DataRow.Cells[c].CellFormat.VerticalAlignment = Spire.Doc.Documents.VerticalAlignment.Middle;
                    Paragraph para = DataRow.Cells[c].AddParagraph();
                    TextRange TRan = para.AppendText(data[r][c]);
                    para.Format.HorizontalAlignment = Spire.Doc.Documents.HorizontalAlignment.Center;
                    TRan.CharacterFormat.FontName = "Calibri";

                    TRan.CharacterFormat.FontSize = 11;
                    
                }
                
            }

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
                        System.Windows.MessageBox.Show("Выберите папку для сохранение файлов", "Внимание", MessageBoxButton.OK, MessageBoxImage.Warning);
                        return;
                    }
                }

                string newFilePath = link + $"\\Группа_{groups[0].Group.Name}.docx";
                document.SaveToFile(newFilePath, FileFormat.Docx);
                System.Diagnostics.Process.Start(newFilePath);
            }
            catch (Exception)
            {

            }

            document.SaveToFile(@"D:\.net test\test.docx", FileFormat.Docx);
        }

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
