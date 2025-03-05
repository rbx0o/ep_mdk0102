using System;
using System.Collections.Generic;

namespace MainProgram.Models;

public partial class Person
{
    public Guid IdPerson { get; set; }

    public string PersonLastName { get; set; } = null!;

    public string PersonFirstName { get; set; } = null!;

    public string PersonPatronymic { get; set; } = null!;

    public DateOnly Birthday { get; set; }

    public int IdCountry { get; set; }

    public string PhoneNumber { get; set; } = null!;

    public string? PersonImage { get; set; }

    public Guid IdUser { get; set; }

    public int IdGender { get; set; }

    public int? IdDirection { get; set; }

    public int? IdModeratorEvent { get; set; }

    public virtual ICollection<Activity> ActivityIdJury1Navigations { get; set; } = new List<Activity>();

    public virtual ICollection<Activity> ActivityIdJury2Navigations { get; set; } = new List<Activity>();

    public virtual ICollection<Activity> ActivityIdJury3Navigations { get; set; } = new List<Activity>();

    public virtual ICollection<Activity> ActivityIdJury4Navigations { get; set; } = new List<Activity>();

    public virtual ICollection<Activity> ActivityIdJury5Navigations { get; set; } = new List<Activity>();

    public virtual ICollection<Activity> ActivityIdModeratorNavigations { get; set; } = new List<Activity>();

    public virtual ICollection<Event> Events { get; set; } = new List<Event>();

    public virtual Country IdCountryNavigation { get; set; } = null!;

    public virtual Direction? IdDirectionNavigation { get; set; }

    public virtual Gender IdGenderNavigation { get; set; } = null!;

    public virtual ModeratorEvent? IdModeratorEventNavigation { get; set; }

    public virtual User IdUserNavigation { get; set; } = null!;
}
