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
        string greeting;
        string fullName;

        bool isVisibleUsersView = false;
        bool isVisibleJuryView = false;
        bool isVisibleRegistrationView = false;

        public User CurrentUser { get => currentUser; set => this.RaiseAndSetIfChanged(ref currentUser, value); }
        public string Greeting { get => greeting; set => this.RaiseAndSetIfChanged(ref greeting, value); }
        public string FullName { get => fullName; set => this.RaiseAndSetIfChanged(ref fullName, value); }

        public bool IsVisibleUsersView { get => isVisibleUsersView; set => this.RaiseAndSetIfChanged(ref isVisibleUsersView, value); }
        public bool IsVisibleJuryView { get => isVisibleJuryView; set => this.RaiseAndSetIfChanged(ref isVisibleJuryView, value); }
        public bool IsVisibleRegistrationView { get => isVisibleRegistrationView; set => this.RaiseAndSetIfChanged(ref isVisibleRegistrationView, value); }

        public MainMenuViewModel(User CurrentUser)
        {
            this.CurrentUser = CurrentUser;

            if (CurrentUser.Person.IdGender == 1) FullName = $"Mr. {CurrentUser.Person.PersonLastName} {CurrentUser.Person.PersonFirstName}";
            else if (CurrentUser.Person.IdGender == 2) FullName = $"Ms. {CurrentUser.Person.PersonLastName} {CurrentUser.Person.PersonFirstName}";

            if (DateTime.Now.Hour >= 9 && DateTime.Now.Hour <= 11) Greeting = "Доброе утро!";
            else if (DateTime.Now.Hour > 11 && DateTime.Now.Hour <= 18) Greeting = "Добрый день!";
            else if (DateTime.Now.Hour > 18 && DateTime.Now.Hour <= 24) Greeting = "Добрый вечер!";
            else Greeting = "Доброго времени суток!";

            if (CurrentUser.IdRoleNavigation.RoleName == "Организатор")
            {
                IsVisibleUsersView = true;
                IsVisibleJuryView = true;
                IsVisibleRegistrationView = true;
            }
            else if (CurrentUser.IdRoleNavigation.RoleName == "Модератор" || CurrentUser.IdRoleNavigation.RoleName == "Жюри")
            {
                IsVisibleUsersView = true;
                IsVisibleJuryView = false;
                IsVisibleRegistrationView = false;
            }
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

        public void ToEventsView() => Navigate.ToEvents();
        public void ToUsersView() => Navigate.ToUsers();
        public void ToJuryView() => Navigate.ToJury();
        public void ToRegistrationView() => Navigate.ToRegistration();
    }
}
