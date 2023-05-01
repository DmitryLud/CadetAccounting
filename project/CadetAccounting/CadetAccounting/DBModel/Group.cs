//------------------------------------------------------------------------------
// <auto-generated>
//     Этот код создан по шаблону.
//
//     Изменения, вносимые в этот файл вручную, могут привести к непредвиденной работе приложения.
//     Изменения, вносимые в этот файл вручную, будут перезаписаны при повторном создании кода.
// </auto-generated>
//------------------------------------------------------------------------------

namespace CadetAccounting.DBModel
{
    using System;
    using System.Collections.Generic;
    
    public partial class Group
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Group()
        {
            this.Cadets = new HashSet<Cadet>();
            this.ClassesLists = new HashSet<ClassesList>();
        }
    
        public int ID { get; set; }
        public int LicenseCategoryID { get; set; }
        public int TeacherID { get; set; }
        public string Name { get; set; }
        public string Type { get; set; }
        public System.DateTime DateStart { get; set; }
        public System.DateTime DateEnd { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Cadet> Cadets { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ClassesList> ClassesLists { get; set; }
        public virtual LicenseCategory LicenseCategory { get; set; }
        public virtual Teacher Teacher { get; set; }
    }
}
