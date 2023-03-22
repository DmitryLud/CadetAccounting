using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CadetAccounting.DBModel;
using Spire.Doc;
using System.IO;

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

            document.SaveToFile(@"C:\Users\Asus\Desktop\contract.docx", FileFormat.Docx);
            System.Diagnostics.Process.Start(@"C:\Users\Asus\Desktop\contract.docx");
        }
    }
}
