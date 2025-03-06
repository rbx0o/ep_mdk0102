using System;
using System.Linq;
using MainProgram.Models;
using Microsoft.EntityFrameworkCore;

namespace MainProgram.ViewModels
{
    internal class AuthorizedUser : ViewModelBase
    {
        static Lazy<AuthorizedUser> _userInstance = new(() => new AuthorizedUser());

        //Данное свойство возвращает объект, _userInstance.Value (В нём содержится AuthorizedUser)
        internal static AuthorizedUser UserInstance => _userInstance.Value; //Запись аналогичная Get, только сокращённая
        public User? Data { get; private set; }

        public void SaveData(User user)
        {
            Data = new User()
            {
                IdUser = user.IdUser,
                Email = user.Email,
                Password = user.Password,
                IdRole = user.IdRole,
                IdRoleNavigation = user.IdRoleNavigation,
                Person = user.Person
            };

            SaveAuthorizedUserData.SaveData(Data.IdUser.ToString());
        }

        public bool UserIsSaved()
        {
            string? token = SaveAuthorizedUserData.LoadUser();
            if (!string.IsNullOrEmpty(token))
            {
                User? user = db.Users
                    .Include(x => x.IdRoleNavigation)
                    .Include(x => x.Person)
                    .FirstOrDefault(x => x.IdUser.ToString() == token);
                if (user != null)
                {
                    Data = new User()
                    {
                        IdUser = user.IdUser,
                        Email = user.Email,
                        Password = user.Password,
                        IdRole = user.IdRole,
                        IdRoleNavigation = user.IdRoleNavigation,
                        Person = user.Person
                    };

                    return true;
                }
            }
            return false;
        }

        public void DeleteUser()
        {
            Data = null;
            SaveAuthorizedUserData.DeleteData();
        }
    }
}
