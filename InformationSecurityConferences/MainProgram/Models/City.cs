using System;
using System.Collections.Generic;

namespace MainProgram.Models;

public partial class City
{
    public int IdCity { get; set; }

    public string CityName { get; set; } = null!;

    public string? CityImage { get; set; }

    public virtual ICollection<Event> Events { get; set; } = new List<Event>();
}
