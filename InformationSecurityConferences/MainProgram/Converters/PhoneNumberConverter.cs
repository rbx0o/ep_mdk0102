using System;
using System.Globalization;
using Avalonia.Data.Converters;

namespace MainProgram.Converters
{
    public class PhoneNumberConverter : IValueConverter
    {
        // ViewModel to View
        public object? Convert(object? value, Type targetType, object? parameter, CultureInfo culture)
        {
            if (value == null) return String.Empty;

            return $"+{(string)value}";
        }

        // View to ViewModel
        public object? ConvertBack(object? value, Type targetType, object? parameter, CultureInfo culture)
        {
            if (value == null) return String.Empty;

            string str = (string)value;

            return str[1..^0]; // Удаляет первый символ
        }
    }
}
