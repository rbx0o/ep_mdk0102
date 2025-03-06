using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MainProgram.Models;
using ReactiveUI;
using static MainProgram.ViewModels.MainWindowViewModel;

namespace MainProgram.ViewModels
{
    public class MainMenuViewModel : ViewModelBase
    {
        User currentUser;

        public User CurrentUser { get => currentUser; set => this.RaiseAndSetIfChanged(ref currentUser, value); }

        public MainMenuViewModel(User CurrentUser)
        {
            this.CurrentUser = CurrentUser;
        }

        public void ToProfileView()
        {
            Navigate.ToProfile(CurrentUser);
        }

        public void Exit()
        {
            AuthorizedUser.UserInstance.DeleteUser();
            Navigate.ToMain();
        }
    }
}
