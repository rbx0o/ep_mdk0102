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
using Avalonia.Media.Imaging;
using Avalonia.Media.TextFormatting;
using Avalonia.Media;
using Avalonia;
using System.Diagnostics.Metrics;
using Tmds.DBus.Protocol;

namespace MainProgram.ViewModels
{
    public class AuthViewModel : ViewModelBase
    {
        string login = "";
        string password = "";
        string message = "";
        User? currentUser = new();
        Random random = new Random();
        Bitmap captchaImage;
        string captchaString;
        string inputCaptcha = "";
        int countTry = 3;
        bool authButtonIsEnabled = true;

        public string Login  { get => login; set => this.RaiseAndSetIfChanged(ref login, value); }
        public string Password { get => password; set => this.RaiseAndSetIfChanged(ref password, value); }
        public string Message { get => message; set => this.RaiseAndSetIfChanged(ref message, value); }
        public User? CurrentUser { get => currentUser; set => this.RaiseAndSetIfChanged(ref currentUser, value); }
        public Bitmap CaptchaImage { get => captchaImage; set => this.RaiseAndSetIfChanged(ref captchaImage, value); }
        public string CaptchaString { get => captchaString; set => this.RaiseAndSetIfChanged(ref captchaString, value); }
        public string InputCaptcha { get => inputCaptcha; set => this.RaiseAndSetIfChanged(ref inputCaptcha, value); }
        public int CountTry { get => countTry; set => this.RaiseAndSetIfChanged(ref countTry, value); }
        public bool AuthButtonIsEnabled { get => authButtonIsEnabled; set => this.RaiseAndSetIfChanged(ref authButtonIsEnabled, value); }

        public AuthViewModel()
        {
            CaptchaString = GenerateCaptchaText();
            CaptchaImage = GenerateCaptchaImage(CaptchaString);
        }

        public async void Auth()
        {
            if (CountTry == 1)
            {
                AuthButtonIsEnabled = false;
                for (int i = 10; i >= 0; i--)
                {
                    await Task.Delay(1000);
                    Message = $"Повторите через: {i}";
                }
                Message = "";
                CountTry = 3;
                AuthButtonIsEnabled = true;
                return;
            }
            if (InputCaptcha != CaptchaString)
            {
                Message = $"Неверно введена капча.\nОсталось: {--CountTry} попыток";
                CaptchaString = GenerateCaptchaText();
                CaptchaImage = GenerateCaptchaImage(CaptchaString);
                return;
            }

            CurrentUser = db.Users
                .Include(x => x.IdRoleNavigation)
                .Include(x => x.Person)
                .Include(x => x.Person.IdGenderNavigation)
                .FirstOrDefault(x => x.Email == Login && x.Password == Password);

            if (CurrentUser != null)
            {
                AuthorizedUser.UserInstance.SaveData(CurrentUser);
                Navigate.ToMainMenu(CurrentUser);
            }
            else
            {
                Message = $"Неверный логин или пароль.\nОсталось: {--CountTry} попыток";
                CountTry = 3;
            }
        }

        public string GenerateCaptchaText()
        {
            string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            return new string(Enumerable.Repeat(chars, 6).Select(s => s[random.Next(s.Length)]).ToArray());
        }

        public Bitmap GenerateCaptchaImage(string captchaText)
        {
            int width = 200, height = 50;

            var renderTarget = new RenderTargetBitmap(new PixelSize(width, height), new Vector(96, 96));

            using (var ctx = renderTarget.CreateDrawingContext())
            {
                ctx.FillRectangle(Brushes.White, new Rect(0, 0, width, height));

                for (int i = 0; i < 30; i++)
                {
                    ctx.DrawLine(new Pen(new SolidColorBrush(Color.FromRgb(Convert.ToByte(random.Next(256)), Convert.ToByte(random.Next(255)), Convert.ToByte(random.Next(255)))), 1.5),
                        new Point(random.Next(width), random.Next(height)),
                        new Point(random.Next(width), random.Next(height)));
                }

                Typeface typeface = new Typeface("TimesNewRoman");
                double fontSize = 24;
                var textBrush = Brushes.Black;
                var textGeometry = new TextLayout(captchaText, typeface, fontSize, textBrush);

                var textWidth = textGeometry.Width;
                var textHeight = textGeometry.Height;
                var textPosition = new Point((width - textWidth) / 2, (height - textHeight) / 2);

                textGeometry.Draw(ctx, textPosition);
            }

            return renderTarget;
        }
    }
}
