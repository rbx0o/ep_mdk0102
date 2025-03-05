using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MainProgram.Models;
using MainProgram.Views;
using Microsoft.EntityFrameworkCore;
using ReactiveUI;
using static MainProgram.ViewModels.MainWindowViewModel;

namespace MainProgram.ViewModels
{
    public class MainViewModel : ViewModelBase
    {
        List<Event> listEvents;

        public List<Event> ListEvents
        {
            get => listEvents;
            set => this.RaiseAndSetIfChanged(ref listEvents, value);
        }

        public MainViewModel()
        {
            listEvents = db.Events.ToList();
        }

        public void ToAuthView()
        {
            Navigate.ToAuth();
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
