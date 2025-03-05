using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MainProgram.ViewModels;
using MainProgram.Views;
using ReactiveUI;
using Microsoft.EntityFrameworkCore;
using MainProgram.Models;
using static MainProgram.ViewModels.MainWindowViewModel;

namespace MainProgram.ViewModels
{
    public class AuthViewModel : ViewModelBase
    {
        string login = "";
        string password = "";
        string message = "";
        User currentUser = new();

        public string Login  { get => login; set => this.RaiseAndSetIfChanged(ref login, value); }
        public string Password { get => password; set => this.RaiseAndSetIfChanged(ref password, value); }
        public string Message { get => message; set => this.RaiseAndSetIfChanged(ref message, value); }
        public User CurrentUser { get => currentUser; set => this.RaiseAndSetIfChanged(ref currentUser, value); }

        public AuthViewModel()
        {
            
        }

        public void Auth()
        {
            CurrentUser = db.Users.Include(x => x.IdRoleNavigation).FirstOrDefault(x => x.Email == Login && x.Password == Password);

            if (CurrentUser != null)
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
            else
            {
                Message = "Неверный логин или пароль";
            }
        }
    }
}
