using System.Collections.Generic;
using System.Linq;
using MainProgram.Models;
using ReactiveUI;
using static MainProgram.ViewModels.MainWindowViewModel;

namespace MainProgram.ViewModels
{
    public class EventsViewModel : ViewModelBase
    {
        List<Event> listEvents;

        public List<Event> ListEvents
        {
            get => listEvents;
            set => this.RaiseAndSetIfChanged(ref listEvents, value);
        }

        public EventsViewModel()
        {
            listEvents = db.Events.ToList();
        }

        public void ToMainMenuView() => Navigate.ToMainMenu(AuthorizedUser.UserInstance.Data);

        public void Exit()
        {
            AuthorizedUser.UserInstance.DeleteUser();
            Navigate.ToMain();
        }

        public void SortByDate(int sortBy)
        {
            switch (sortBy)
            {
                case 1:
                    ListEvents = ListEvents.OrderBy(x => x.EventDate).ToList();
                    break;
                case 2:
                    ListEvents = ListEvents.OrderByDescending(x => x.EventDate).ToList();
                    break;
            }
        }
    }
}