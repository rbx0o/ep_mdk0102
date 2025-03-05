using System;
using System.Collections.Generic;

namespace MainProgram.Models;

public partial class Event
{
    public int IdEvent { get; set; }

    public string EventName { get; set; } = null!;

    public DateOnly EventDate { get; set; }

    public int LengthDays { get; set; }

    public int IdCity { get; set; }

    public string? EventImage { get; set; }

    public Guid? IdWinner { get; set; }

    public virtual ICollection<Activity> Activities { get; set; } = new List<Activity>();

    public virtual City IdCityNavigation { get; set; } = null!;

    public virtual Person? IdWinnerNavigation { get; set; }
}
