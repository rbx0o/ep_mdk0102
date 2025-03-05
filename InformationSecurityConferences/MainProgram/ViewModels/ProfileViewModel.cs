using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MainProgram.Models;
using MainProgram.Views;
using ReactiveUI;
using static MainProgram.ViewModels.MainWindowViewModel;

namespace MainProgram.ViewModels
{
    public class ProfileViewModel : ViewModelBase
    {
        User currentUser;

        public User CurrentUser { get => currentUser; set => this.RaiseAndSetIfChanged(ref currentUser, value); }

        public ProfileViewModel(User CurrentUser)
        {
            this.CurrentUser = CurrentUser;
        }

        public void GoBack()
        {
            switch (CurrentUser.IdRoleNavigation.RoleName)
            {
                case "Участник":
                    Navigate.ToMember(CurrentUser);
                    break;
                case "Жюри":
                    Navigate.ToJury(CurrentUser);
                    break;
                case "Организатор":
                    Navigate.ToOrganizer(CurrentUser);
                    break;
                case "Модератор":
                    Navigate.ToModerator(CurrentUser);
                    break;
            }
        }

        public void ToMainView()
        {
            Navigate.ToMain();
        }
    }
}
