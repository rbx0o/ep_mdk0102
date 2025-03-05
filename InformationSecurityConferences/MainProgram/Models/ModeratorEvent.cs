using System;
using System.Collections.Generic;

namespace MainProgram.Models;

public partial class ModeratorEvent
{
    public int IdModeratorEvent { get; set; }

    public string ModeratorEventName { get; set; } = null!;

    public virtual ICollection<Person> People { get; set; } = new List<Person>();
}
