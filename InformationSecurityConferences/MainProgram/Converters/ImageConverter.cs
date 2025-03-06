using System;
using System.Globalization;
using Avalonia.Data.Converters;
using Avalonia.Media.Imaging;
using Avalonia.Platform;

namespace MainProgram.Converters
{
    public class ImageConverter : IValueConverter
    {
        public object? Convert(object? value, Type targetType, object? parameter, CultureInfo culture)
        {
            if (parameter != null)
            {
                switch (parameter)
                {
                    case "event":
                        return value != null ? new Bitmap(AssetLoader.Open(new Uri($"avares://MainProgram/Assets/images/events/{value}"))) : null;
                    case "persons":
                        return value != null ? new Bitmap(AssetLoader.Open(new Uri($"avares://MainProgram/Assets/images/persons/{value}"))) : null;
                    case "cities":
                        return value != null ? new Bitmap(AssetLoader.Open(new Uri($"avares://MainProgram/Assets/images/cities/{value}"))) : null;
                    default:
                        return new Bitmap(AssetLoader.Open(new Uri($"avares://MainProgram/Assets/images/noImage.jpg")));
                }
            }
            else return new Bitmap(AssetLoader.Open(new Uri($"avares://MainProgram/Assets/images/noImage.jpg")));
        }

        public object? ConvertBack(object? value, Type targetType, object? parameter, CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
