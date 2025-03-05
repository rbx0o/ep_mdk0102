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
    public class JuryViewModel : ViewModelBase
    {
        User currentUser;

        public User CurrentUser { get => currentUser; set => this.RaiseAndSetIfChanged(ref currentUser, value); }

        public JuryViewModel(User CurrentUser)
        {
            this.CurrentUser = CurrentUser;
        }

        public void ToProfileView()
        {
            Navigate.ToProfile(CurrentUser);
        }

        public void ToMainView()
        {
            Navigate.ToMain();
        }
    }
}
