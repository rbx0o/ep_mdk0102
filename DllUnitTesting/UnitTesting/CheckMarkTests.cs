using REG_MARK_LIB;

namespace UnitTesting;

[TestClass]
public sealed class CheckMarkTests
{
    [DataTestMethod]
    [DataRow("A001AA01")]
    [DataRow("M456MM77")]
    [DataRow("X789TX99")]
    [DataRow("E555EK178")]
    [DataRow("H777OH97")]
    [DataRow("O888AO150")]
    [DataRow("T999TT199")]
    [DataRow("C222CC777")]
    [DataRow("P333PP22")]
    [DataRow("K444kK44")]
    public void CheckMark_TrueResults(string mark)
    {
        bool result = RegMark.CheckMark(mark);

        Assert.IsTrue(result);
    }

    [DataTestMethod]
    [DataRow("A001GA01")]
    [DataRow("M000MM000")]
    [DataRow("X789Tg99")]
    [DataRow("E555zK178")]
    [DataRow("q727OH97")]
    [DataRow("O888AO999")]
    [DataRow("T999fT199")]
    [DataRow("C222iC777")]
    [DataRow("P333PP100")]
    [DataRow("K444kj000")]
    public void CheckMark_FalseResults(string mark)
    {
        bool result = RegMark.CheckMark(mark);

        Assert.IsFalse(result);
    }

    [DataTestMethod]
    [DataRow("A001GA01")]
    [DataRow("M000MM000")]
    [DataRow("X789Tg99")]
    [DataRow("E555zK178")]
    [DataRow("q727OH97")]
    [DataRow("O888AO999")]
    [DataRow("T999fT199")]
    [DataRow("C222iC777")]
    [DataRow("P333PP100")]
    [DataRow("K444kj000")]
    public void CheckMark_ResultIsBool(string mark)
    {
        Type type = typeof(bool);
        var result = RegMark.CheckMark(mark);

        Assert.IsInstanceOfType(result, type);
    }
}
