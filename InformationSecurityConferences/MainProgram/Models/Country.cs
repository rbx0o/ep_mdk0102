using System;
using System.Collections.Generic;

namespace MainProgram.Models;

public partial class Country
{
    public int IdCountry { get; set; }

    public string CountryNameRu { get; set; } = null!;

    public string CountryNameEn { get; set; } = null!;

    public int NumericCode { get; set; }

    public string LetterCode { get; set; } = null!;

    public virtual ICollection<Person> People { get; set; } = new List<Person>();
}
