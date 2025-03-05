using System;
using System.Collections.Generic;

namespace MainProgram.Models;

public partial class User
{
    public Guid IdUser { get; set; }

    public string Email { get; set; } = null!;

    public string Password { get; set; } = null!;

    public int IdRole { get; set; }

    public virtual Role IdRoleNavigation { get; set; } = null!;

    public virtual Person? Person { get; set; }
}
