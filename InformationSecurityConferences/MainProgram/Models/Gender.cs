using System;
using System.Collections.Generic;

namespace MainProgram.Models;

public partial class Gender
{
    public int IdGender { get; set; }

    public string GenderName { get; set; } = null!;

    public virtual ICollection<Person> People { get; set; } = new List<Person>();
}
