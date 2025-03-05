using MainProgram.Models;
using ReactiveUI;

namespace MainProgram.ViewModels;

public class ViewModelBase : ReactiveObject
{
    public EpMdk0102Context db = new EpMdk0102Context();
}
