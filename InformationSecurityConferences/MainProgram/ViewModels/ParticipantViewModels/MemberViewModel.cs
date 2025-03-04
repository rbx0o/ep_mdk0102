﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MainProgram.Views;
using MainProgram.Models;
using Microsoft.EntityFrameworkCore;
using ReactiveUI;
using static MainProgram.ViewModels.MainWindowViewModel;

namespace MainProgram.ViewModels
{
    public class MemberViewModel : ViewModelBase
    {
        User currentUser;

        public User CurrentUser { get => currentUser; set => this.RaiseAndSetIfChanged(ref currentUser, value); }

        public MemberViewModel(User CurrentUser)
        {
            this.CurrentUser = CurrentUser;
        }

        public void ToProfileView()
        {
            Navigate.ToProfile(CurrentUser);
        }

        public void ToMainView()
        {
            Navigate.ToMain();
        }
    }
}
