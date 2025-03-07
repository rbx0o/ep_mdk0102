using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static MainProgram.ViewModels.MainWindowViewModel;
using Microsoft.EntityFrameworkCore;
using MainProgram.Models;
using ReactiveUI;

namespace MainProgram.ViewModels
{
    public class UsersViewModel : ViewModelBase
    {
        List<Person> listUsers;

        public List<Person> ListUsers
        {
            get => listUsers;
            set => this.RaiseAndSetIfChanged(ref listUsers, value);
        }

        public UsersViewModel()
        {
            listUsers = db.Persons
                .Include(x => x.IdDirectionNavigation)
                .Include(x => x.IdUserNavigation)
                .Include(x => x.IdUserNavigation.IdRoleNavigation)
                .Where(x => x.IdUserNavigation.IdRoleNavigation.RoleName == "Участник").ToList();
        }

        public void ToMainMenuView() => Navigate.ToMainMenu(AuthorizedUser.UserInstance.Data);

        public void Exit()
        {
            AuthorizedUser.UserInstance.DeleteUser();
            Navigate.ToMain();
        }
    }
}
