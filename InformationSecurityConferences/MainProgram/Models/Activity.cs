using System;
using System.Collections.Generic;

namespace MainProgram.Models;

public partial class Activity
{
    public Guid IdActivity { get; set; }

    public string ActivityName { get; set; } = null!;

    public int DayNumber { get; set; }

    public TimeOnly TimeStart { get; set; }

    public Guid IdModerator { get; set; }

    public Guid? IdJury1 { get; set; }

    public Guid? IdJury2 { get; set; }

    public Guid? IdJury3 { get; set; }

    public Guid? IdJury4 { get; set; }

    public Guid? IdJury5 { get; set; }

    public int IdEvent { get; set; }

    public virtual Event IdEventNavigation { get; set; } = null!;

    public virtual Person? IdJury1Navigation { get; set; }

    public virtual Person? IdJury2Navigation { get; set; }

    public virtual Person? IdJury3Navigation { get; set; }

    public virtual Person? IdJury4Navigation { get; set; }

    public virtual Person? IdJury5Navigation { get; set; }

    public virtual Person IdModeratorNavigation { get; set; } = null!;
}
