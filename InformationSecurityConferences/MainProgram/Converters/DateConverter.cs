using System;
using System.Globalization;
using Avalonia.Data.Converters;

namespace MainProgram.Converters
{
    public class DateConverter : IValueConverter
    {
        // ViewModel to View
        public object? Convert(object? value, Type targetType, object? parameter, CultureInfo culture)
        {
            if (value != null) return new DateTimeOffset((DateOnly)value, TimeOnly.MinValue, TimeSpan.Zero);
            return new DateTimeOffset();
        }

        // View to ViewModel
        public object? ConvertBack(object? value, Type targetType, object? parameter, CultureInfo culture)
        {
            if (value == null) return new DateOnly();

            DateTimeOffset date = (DateTimeOffset)value;
            return new DateOnly(date.Year, date.Month, date.Day);
        }
    }
}
