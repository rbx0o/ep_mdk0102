using REG_MARK_LIB;

namespace UnitTesting;

[TestClass]
public class GetNextMarkAfterInRangeTests
{
    [DataTestMethod]
    [DataRow("A999AA097", "A999AA097", "B001AA097", "A001AB097")]  // Следующий номер в диапазоне
    [DataRow("A123AA777", "A100AA777", "A200AA777", "A124AA777")]  // Увеличение числа внутри диапазона
    [DataRow("X999XX199", "X999XX199", "X999XX199", "Out of stock")]  // Последний номер в диапазоне
    [DataRow("M888AM150", "M800AM150", "M888AM150", "Out of stock")]  // Последний номер в диапазоне
    [DataRow("C567BC199", "C500BC199", "C570BC199", "C568BC199")]  // Увеличение номера
    [DataRow("K999KK777", "K999KK777", "K001KK777", "Out of stock")]  // Последний номер в серии
    [DataRow("B050BB050", "B050BB050", "B060BB050", "B051BB050")]  // Увеличение внутри диапазона
    [DataRow("P999PP750", "P990PP750", "X001PP750", "P001PC750")]  // Последний номер перед сменой буквы
    [DataRow("T999TT199", "T999TT199", "T999TT199", "Out of stock")]  // Уже последний возможный
    [DataRow("E123EK178", "E100EK178", "E130EK178", "E124EK178")]  // Нормальное увеличение
    public void GetNextMarkAfterInRange_WorksCorrectly(string prevMark, string rangeStart, string rangeEnd, string expected)
    {
        string actual = String.Empty;

        actual = RegMark.GetNextMarkAfterInRange(prevMark, rangeStart, rangeEnd);

        Assert.AreEqual(expected, actual);
    }

    [DataTestMethod]
    [DataRow("A999AA097", "A999AA097", "B001AA097", "A001AB097")]  // Следующий номер в диапазоне
    [DataRow("A123AA777", "A100AA777", "A200AA777", "A124AA777")]  // Увеличение числа внутри диапазона
    [DataRow("X999XX199", "X999XX199", "X999XX199", "Out of stock")]  // Последний номер в диапазоне
    [DataRow("M888AM150", "M800AM150", "M888AM150", "Out of stock")]  // Последний номер в диапазоне
    [DataRow("C567BC199", "C500BC199", "C570BC199", "C568BC199")]  // Увеличение номера
    [DataRow("K999KK777", "K999KK777", "K001KK777", "Out of stock")]  // Последний номер в серии
    [DataRow("B050BB050", "B050BB050", "B060BB050", "B051BB050")]  // Увеличение внутри диапазона
    [DataRow("P999PP750", "P990PP750", "X001PP750", "P001PC750")]  // Последний номер перед сменой буквы
    [DataRow("T999TT199", "T999TT199", "T999TT199", "Out of stock")]  // Уже последний возможный
    [DataRow("E123EK178", "E100EK178", "E130EK178", "E124EK178")]  // Нормальное увеличение
    public void GetNextMarkAfterInRange_ResultIsString(string prevMark, string rangeStart, string rangeEnd, string expected)
    {
        Type type = typeof(string);

        var result = RegMark.GetNextMarkAfterInRange(prevMark, rangeStart, rangeEnd);

        Assert.IsInstanceOfType(result, type);
    }

    [DataTestMethod]
    [DataRow("A999AA097", "A999AA097", "B001AA097", "A001AB097")]  // Следующий номер в диапазоне
    [DataRow("A123AA777", "A100AA777", "A200AA777", "A124AA777")]  // Увеличение числа внутри диапазона
    [DataRow("X999XX199", "X999XX199", "X999XX199", "Out of stock")]  // Последний номер в диапазоне
    [DataRow("M888AM150", "M800AM150", "M888AM150", "Out of stock")]  // Последний номер в диапазоне
    [DataRow("C567BC199", "C500BC199", "C570BC199", "C568BC199")]  // Увеличение номера
    [DataRow("K999KK777", "K999KK777", "K001KK777", "Out of stock")]  // Последний номер в серии
    [DataRow("B050BB050", "B050BB050", "B060BB050", "B051BB050")]  // Увеличение внутри диапазона
    [DataRow("P999PP750", "P990PP750", "X001PP750", "P001PC750")]  // Последний номер перед сменой буквы
    [DataRow("T999TT199", "T999TT199", "T999TT199", "Out of stock")]  // Уже последний возможный
    [DataRow("E123EK178", "E100EK178", "E130EK178", "E124EK178")]  // Нормальное увеличение
    public void GetNextMarkAfterInRange_ResultIsNotNull(string prevMark, string rangeStart, string rangeEnd, string expected)
    {
        string result = String.Empty;

        result = RegMark.GetNextMarkAfterInRange(prevMark, rangeStart, rangeEnd);

        Assert.IsNotNull(result);
    }
}
