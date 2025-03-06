using System.Collections.Generic;
using System.Linq;
using MainProgram.Models;
using Microsoft.EntityFrameworkCore;
using ReactiveUI;
using static MainProgram.ViewModels.MainWindowViewModel;

namespace MainProgram.ViewModels
{
    public class ProfileViewModel : ViewModelBase
    {
        User? currentUser;

        public User? CurrentUser { get => currentUser; set => this.RaiseAndSetIfChanged(ref currentUser, value); }
        public List<Gender> GendersList => db.Genders.ToList();


        public ProfileViewModel(User CurrentUser)
        {
            this.CurrentUser = db.Users
                .Include(x => x.IdRoleNavigation)
                .Include(x => x.Person)
                .Include(x => x.Person.IdGenderNavigation)
                .FirstOrDefault(x => x.IdUser == CurrentUser.IdUser);

            GendersList[0].GenderName = "Мужской";
            GendersList[1].GenderName = "Женский";
        }

        public void SaveChanges()
        {
            db.SaveChanges();
        }

        public void GoBack()
        {
            switch (CurrentUser?.IdRoleNavigation.RoleName)
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
