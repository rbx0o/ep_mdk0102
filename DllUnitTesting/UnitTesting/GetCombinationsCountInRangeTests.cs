using REG_MARK_LIB;

namespace UnitTesting;

[TestClass]
public class GetCombinationsCountInRangeTests
{
    [DataTestMethod]
    [DataRow("A001AA001", "A005AA001", 5)]  // 5 номеров в пределах одной серии
    [DataRow("A001AA001", "A001AA001", 1)]  // Один и тот же номер → 1 комбинация
    [DataRow("A001AA777", "A003AA777", 3)]  // Переход с 999 на 001 (учитываем +2)
    [DataRow("X123XX055", "X124XX055", 2)]  // Разница в 1 номере
    [DataRow("B999BB777", "B001BE777", 2)]  // Переход буквы → 2 комбинации
    [DataRow("M888MM150", "M890MM150", 3)]  // Простой диапазон
    [DataRow("C001CC001", "C010CC001", 10)] // 10 номеров в пределах одной серии
    [DataRow("P555PP050", "P600PP050", 46)] // Разница в 46 номеров
    [DataRow("T999TT199", "T999TT199", 1)]  // Один и тот же номер → 1 комбинация
    [DataRow("E100EK178", "E200EK178", 101)]// 101 комбинация  
    public void GetCombinationsCountInRange_WorksCorrectly(string mark1, string mark2, int expectedCount)
    {
        int actual = 0;

        actual = RegMark.GetCombinationsCountInRange(mark1, mark2);

        Assert.AreEqual(expectedCount, actual);
    }

    [DataTestMethod]
    [DataRow("A001AA001", "A005AA001", 5)]  // 5 номеров в пределах одной серии
    [DataRow("A001AA001", "A001AA001", 1)]  // Один и тот же номер → 1 комбинация
    [DataRow("A001AA777", "A003AA777", 3)]  // Переход с 999 на 001 (учитываем +2)
    [DataRow("X123XX055", "X124XX055", 2)]  // Разница в 1 номере
    [DataRow("B999BB777", "B001BE777", 2)]  // Переход буквы → 2 комбинации
    [DataRow("M888MM150", "M890MM150", 3)]  // Простой диапазон
    [DataRow("C001CC001", "C010CC001", 10)] // 10 номеров в пределах одной серии
    [DataRow("P555PP050", "P600PP050", 46)] // Разница в 46 номеров
    [DataRow("T999TT199", "T999TT199", 1)]  // Один и тот же номер → 1 комбинация
    [DataRow("E100EK178", "E200EK178", 101)]// 101 комбинация  
    public void GetCombinationsCountInRange_ResultIsInt(string mark1, string mark2, int expectedCount)
    {
        Type type = typeof(int);

        var result = RegMark.GetCombinationsCountInRange(mark1, mark2);

        Assert.IsInstanceOfType(result, type);
    }

    [DataTestMethod]
    [DataRow("A001AA001", "A005AA001", 5)]  // 5 номеров в пределах одной серии
    [DataRow("A001AA001", "A001AA001", 1)]  // Один и тот же номер → 1 комбинация
    [DataRow("A001AA777", "A003AA777", 3)]  // Переход с 999 на 001 (учитываем +2)
    [DataRow("X123XX055", "X124XX055", 2)]  // Разница в 1 номере
    [DataRow("B999BB777", "B001BE777", 2)]  // Переход буквы → 2 комбинации
    [DataRow("M888MM150", "M890MM150", 3)]  // Простой диапазон
    [DataRow("C001CC001", "C010CC001", 10)] // 10 номеров в пределах одной серии
    [DataRow("P555PP050", "P600PP050", 46)] // Разница в 46 номеров
    [DataRow("T999TT199", "T999TT199", 1)]  // Один и тот же номер → 1 комбинация
    [DataRow("E100EK178", "E200EK178", 101)]// 101 комбинация  
    public void GetCombinationsCountInRange_ResultIsNotNull(string mark1, string mark2, int expectedCount)
    {
        int result = 0;

        result = RegMark.GetCombinationsCountInRange(mark1, mark2);

        Assert.IsNotNull(result);
    }
}
