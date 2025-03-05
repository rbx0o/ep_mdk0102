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
            currentViewModel = new MainViewModel();
        }

        public ViewModelBase CurrentViewModel { get => currentViewModel; set => this.RaiseAndSetIfChanged(ref currentViewModel, value); }
        public static MainWindowViewModel Navigate { get => navigate; set => navigate = value; }

        public void ToAuth() => CurrentViewModel = new AuthViewModel();
        public void ToMain() => CurrentViewModel = new MainViewModel();
        public void ToJury(User CurrentUser) => CurrentViewModel = new JuryViewModel(CurrentUser);
        public void ToMember(User CurrentUser) => CurrentViewModel = new MemberViewModel(CurrentUser);
        public void ToModerator(User CurrentUser) => CurrentViewModel = new ModeratorViewModel(CurrentUser);
        public void ToOrganizer(User CurrentUser) => CurrentViewModel = new OrganizerViewModel(CurrentUser);
        public void ToProfile(User CurrentUser) => CurrentViewModel = new ProfileViewModel(CurrentUser);

    }
}
