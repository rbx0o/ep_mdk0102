using System;
using System.Collections.Generic;

namespace MainProgram.Models;

public partial class Direction
{
    public int IdDirection { get; set; }

    public string DirectionName { get; set; } = null!;

    public virtual ICollection<Person> People { get; set; } = new List<Person>();
}
