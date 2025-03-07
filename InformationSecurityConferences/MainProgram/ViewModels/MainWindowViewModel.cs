using Avalonia.Controls;
using ReactiveUI;
using MainProgram.Models;
using MainProgram.Views;

namespace MainProgram.ViewModels
{
    public class MainWindowViewModel : ViewModelBase
    {
        ViewModelBase currentViewModel;
        static MainWindowViewModel navigate;

        public MainWindowViewModel()
        {
            Navigate = this;
            if (AuthorizedUser.UserInstance.UserIsSaved()) currentViewModel = new MainMenuViewModel(AuthorizedUser.UserInstance.Data);
            else currentViewModel = new MainViewModel();
        }

        public ViewModelBase CurrentViewModel { get => currentViewModel; set => this.RaiseAndSetIfChanged(ref currentViewModel, value); }
        public static MainWindowViewModel Navigate { get => navigate; set => navigate = value; }

        public void ToAuth() => CurrentViewModel = new AuthViewModel();
        public void ToMain() => CurrentViewModel = new MainViewModel();
        public void ToMainMenu(User CurrentUser) => CurrentViewModel = new MainMenuViewModel(CurrentUser);
        public void ToProfile(User CurrentUser) => CurrentViewModel = new ProfileViewModel(CurrentUser);
        public void ToEvents() => CurrentViewModel = new EventsViewModel();
        public void ToUsers() => CurrentViewModel = new UsersViewModel();
        public void ToJury() => CurrentViewModel = new JuryViewModel();
        public void ToRegistration() => CurrentViewModel = new RegistrationViewModel();

    }
}
