using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MainProgram.Models;
using Microsoft.EntityFrameworkCore;
using ReactiveUI;
using static MainProgram.ViewModels.MainWindowViewModel;

namespace MainProgram.ViewModels
{
    public class JuryViewModel : ViewModelBase
    {

        List<Person> listJury;

        public List<Person> ListJury
        {
            get => listJury;
            set => this.RaiseAndSetIfChanged(ref listJury, value);
        }

        public JuryViewModel()
        {
            listJury = db.Persons
                .Include(x => x.IdDirectionNavigation)
                .Include(x => x.IdUserNavigation)
                .Include(x => x.IdUserNavigation.IdRoleNavigation)
                .Where(x => x.IdUserNavigation.IdRoleNavigation.RoleName == "Жюри").ToList();
        }

        public void ToMainMenuView() => Navigate.ToMainMenu(AuthorizedUser.UserInstance.Data);

        public void Exit()
        {
            AuthorizedUser.UserInstance.DeleteUser();
            Navigate.ToMain();
        }
    }
}
