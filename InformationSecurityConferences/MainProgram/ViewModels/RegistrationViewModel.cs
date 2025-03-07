using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Numerics;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Avalonia;
using Avalonia.Controls.ApplicationLifetimes;
using Avalonia.Media.Imaging;
using Avalonia.Platform;
using Avalonia.Platform.Storage;
using MainProgram.Models;
using Newtonsoft.Json.Linq;
using ReactiveUI;
using static MainProgram.ViewModels.MainWindowViewModel;

namespace MainProgram.ViewModels
{
    public class RegistrationViewModel : ViewModelBase
    {
        Guid registrationId;

        List<Direction>? directions;
        List<Event>? events;
        List<Gender> genders;
        List<Role> roles;

        Direction? selectedDirection;
        Event? selectedEvent;
        Role? selectedRole;
        Gender? selectedGender;

        string password, rePassword, email, phone, fullName, message, messageColor;

        Bitmap? selectedImage;

        IStorageFile? selectedFile;
        public RegistrationViewModel()
        {
            RegistrationId = Guid.NewGuid();

            Roles = db.Roles.Where(Roles => Roles.RoleName == "Жюри" || Roles.RoleName == "Модератор").ToList();

            Genders = db.Genders.ToList();
            Genders[0].GenderName = "Мужской";
            Genders[1].GenderName = "Женский";

            Directions = db.Directions.ToList();
            Events = db.Events.ToList();

            SelectedDirection = null;
            SelectedEvent = null;
            SelectedImage = new Bitmap(AssetLoader.Open(new Uri($"avares://MainProgram/Assets/images/noImage.jpg")));
        }

        public Guid RegistrationId { get => registrationId; set => this.RaiseAndSetIfChanged(ref registrationId, value); }

        //Статусы
        public List<Role> Roles { get => roles; set => this.RaiseAndSetIfChanged(ref roles, value); }
        public Role? SelectedRole { get => selectedRole; set { this.RaiseAndSetIfChanged(ref selectedRole, value); Message = string.Empty; } }

        //Пол
        public List<Gender> Genders { get => genders; set => this.RaiseAndSetIfChanged(ref genders, value); }
        public Gender? SelectedGender { get => selectedGender; set { this.RaiseAndSetIfChanged(ref selectedGender, value); Message = string.Empty; } }

        //Направления
        public List<Direction>? Directions { get => directions; set => this.RaiseAndSetIfChanged(ref directions, value); }
        public Direction? SelectedDirection { get => selectedDirection; set { this.RaiseAndSetIfChanged(ref selectedDirection, value); Message = string.Empty; } }

        //Мероприятия
        public List<Event>? Events { get => events; set => this.RaiseAndSetIfChanged(ref events, value); }
        public Event? SelectedEvent { get => selectedEvent; set { this.RaiseAndSetIfChanged(ref selectedEvent, value); Message = string.Empty; } }

        //Пароли
        public string Password
        {
            get => password; set
            {
                this.RaiseAndSetIfChanged(ref password, value);
                CheckPasswords();
                Message = string.Empty;
            }
        }
        public string RePassword
        {
            get => rePassword;
            set
            {
                this.RaiseAndSetIfChanged(ref rePassword, value);
                CheckPasswords();
                Message = string.Empty;
            }
        }

        public string Email { get => email; set { this.RaiseAndSetIfChanged(ref email, value); Message = string.Empty; } }
        public string Phone { get => phone; set { this.RaiseAndSetIfChanged(ref phone, value); Message = string.Empty; } }
        public string FullName { get => fullName; set { this.RaiseAndSetIfChanged(ref fullName, value); Message = string.Empty; } }

        public Bitmap? SelectedImage { get => selectedImage; set { this.RaiseAndSetIfChanged(ref selectedImage, value); Message = string.Empty; } }

        public IStorageFile? SelectedFile { get => selectedFile; set => selectedFile = value; }
        public string Message { get => message; set => this.RaiseAndSetIfChanged(ref message, value); }
        public string MessageColor { get => messageColor; set => this.RaiseAndSetIfChanged(ref messageColor, value); }
        string PathToImageFileAvares { get; set; }

        /// <summary>
        /// Проверка на валидность пароля
        /// </summary>
        /// <returns></returns>
        bool IsPasswordValid()
        {
            // Проверяем длину пароля
            if (Password.Length < 6)
                return false;

            // Проверяем наличие хотя бы одной заглавной буквы, строчной буквы, цифры и спецсимвола
            bool hasUpperCase = false;
            bool hasLowerCase = false;
            bool hasDigit = false;
            bool hasSpecialChar = false;

            foreach (char c in Password)
            {
                if (char.IsUpper(c)) hasUpperCase = true;
                if (char.IsLower(c)) hasLowerCase = true;
                if (char.IsDigit(c)) hasDigit = true;
                if (Regex.IsMatch(c.ToString(), @"[\W_]")) hasSpecialChar = true; // Спецсимволы
            }

            return hasUpperCase && hasLowerCase && hasDigit && hasSpecialChar;
        }

        bool CheckPasswords() => Password == RePassword;

        /// <summary>
        /// Проверка на корректность шаблона почты
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        bool IsEmailValid()
        {
            // Регулярное выражение для проверки email
            string emailPattern = @"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";

            return Regex.IsMatch(Email, emailPattern);
        }


        public void Registration()
        {
            if (!string.IsNullOrEmpty(Message))
            {
                Message = string.Empty;
            }

            if (string.IsNullOrEmpty(SelectedRole?.RoleName) || string.IsNullOrEmpty(SelectedGender?.GenderName) || string.IsNullOrEmpty(Password) ||
                string.IsNullOrEmpty(RePassword) || string.IsNullOrEmpty(Email) || string.IsNullOrEmpty(Phone) || string.IsNullOrEmpty(FullName) ||
                SelectedEvent is null || SelectedDirection is null)
            {
                Message = "Не все обязательные поля заполнены";
                MessageColor = "#FFFF0000";
                return;
            }
            else if (!CheckPasswords())
            {
                Message = "Пароли не совпадают";
                MessageColor = "#FFFF0000";
                return;
            }
            else if (!IsPasswordValid())
            {
                Message = "Пароль не соответствует требованиям";
                MessageColor = "#FFFF0000";
                return;
            }
            else if (!IsEmailValid())
            {
                Message = "Ввдено некорректное значение почты";
                MessageColor = "#FFFF0000";
                return;
            }
            else
            {
                if (SelectedImage != null)
                {
                    SaveImage();
                }

                User newUser = new User()
                {
                    IdUser = RegistrationId,
                    Email = Email,
                    Password = Password,
                    IdRole = SelectedRole?.RoleName switch
                    {
                        "Жюри" => 2,
                        "Модератор" => 4
                    },
                    IdRoleNavigation = db.Roles.FirstOrDefault(x => x.RoleName == SelectedRole.RoleName),
                    Person = new Person()
                    {
                        IdPerson = Guid.NewGuid(),
                        PersonLastName = FullName.Split()[0],
                        PersonFirstName = FullName.Split()[1],
                        PersonPatronymic = FullName.Split()[2],
                        Birthday = new DateOnly(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day),
                        IdCountry = 171,
                        PhoneNumber = Phone,
                        PersonImage = PathToImageFileAvares,
                        IdUser = RegistrationId,
                        IdGender = SelectedGender?.GenderName switch
                        {
                            "Мужской" => 1,
                            "Женский" => 2,
                        },
                        IdDirection = db.Directions.FirstOrDefault(x => x.DirectionName == SelectedDirection.DirectionName).IdDirection
                    }
                };
                try
                {
                    db.Users.Add(newUser);
                    db.SaveChanges();
                    Message = "Данные успешно добавлены";
                    MessageColor = "#FF008000";
                    ResetData();
                }
                catch (Exception)
                {
                    Message = "Произошла ошибка";
                    MessageColor = "#FFFF0000";
                    throw;
                }
            }
        }

        void ResetData()
        {
            RegistrationId = Guid.NewGuid();
            
            FullName = string.Empty;
            Password = string.Empty;
            RePassword = string.Empty;
            Email = string.Empty;
            PathToImageFileAvares = string.Empty;

            SelectedDirection = null;
            SelectedEvent = null;
            SelectedImage = new Bitmap(AssetLoader.Open(new Uri($"avares://MainProgram/Assets/images/noImage.jpg")));
            SelectedFile = null;
            SelectedRole = null;
            SelectedGender = null;
        }

        /// <summary>
        /// Выбор картинки
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NullReferenceException"></exception>
        public async Task LoadImage()
        {
            if (Application.Current?.ApplicationLifetime is not IClassicDesktopStyleApplicationLifetime desktop ||
                desktop.MainWindow?.StorageProvider is not { } provider) throw new NullReferenceException("Отсутствует провайдер");

            var files = await provider.OpenFilePickerAsync(
                new FilePickerOpenOptions()
                {
                    Title = "Выберите изображение профиля",
                    AllowMultiple = false,
                    FileTypeFilter = [FilePickerFileTypes.ImageAll]
                });

            if (files is null || files.Count == 0)
                return;

            SelectedFile = files[0];

            Uri fileUri = SelectedFile.Path;
            string pathFile = fileUri.LocalPath;

            SelectedImage = new Bitmap(pathFile);
        }

        //Сохранение картинки в каталог конкретного пользователя
        async Task SaveImage()
        {
            string? projectRoot = Directory.GetParent(AppContext.BaseDirectory)?.Parent?.Parent?.Parent?.FullName;

            string path = Path.Combine(projectRoot, "Assets\\images\\persons"); // Путь к папке 

            string fileName = SelectedFile.Name;

            string destinationPath = Path.Combine(path, fileName);

            //Сохраняем путь для картинки нового пользователя
            PathToImageFileAvares = Path.Combine(fileName);

            // Проверяем, существует ли уже такой файл, и меняем имя, если нужно
            int counter = 1;
            while (File.Exists(destinationPath))
            {
                string extension = Path.GetExtension(fileName);
                fileName = $"{fileName}_{counter}{extension}";
                destinationPath = Path.Combine(path, fileName);
                counter++;
            }

            // Копируем изображение в каталог с пользовательскими изображениями
            await using var sourceStream = await SelectedFile.OpenReadAsync();
            await using var destinationStream = File.Create(destinationPath);
            await sourceStream.CopyToAsync(destinationStream);
        }

        public void GoBack() => Navigate.ToMainMenu(AuthorizedUser.UserInstance.Data);

        public void Exit()
        {
            AuthorizedUser.UserInstance.DeleteUser();
            Navigate.ToMain();
        }
    }
}
