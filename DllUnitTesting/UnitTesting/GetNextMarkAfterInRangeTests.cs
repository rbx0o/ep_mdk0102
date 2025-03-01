using REG_MARK_LIB;

namespace UnitTesting;

[TestClass]
public class GetNextMarkAfterInRangeTests
{
    [DataTestMethod]
    [DataRow("A999AA097", "A999AA097", "B001AA097", "A001AB097")]  // ��������� ����� � ���������
    [DataRow("A123AA777", "A100AA777", "A200AA777", "A124AA777")]  // ���������� ����� ������ ���������
    [DataRow("X999XX199", "X999XX199", "X999XX199", "Out of stock")]  // ��������� ����� � ���������
    [DataRow("M888AM150", "M800AM150", "M888AM150", "Out of stock")]  // ��������� ����� � ���������
    [DataRow("C567BC199", "C500BC199", "C570BC199", "C568BC199")]  // ���������� ������
    [DataRow("K999KK777", "K999KK777", "K001KK777", "Out of stock")]  // ��������� ����� � �����
    [DataRow("B050BB050", "B050BB050", "B060BB050", "B051BB050")]  // ���������� ������ ���������
    [DataRow("P999PP750", "P990PP750", "X001PP750", "P001PC750")]  // ��������� ����� ����� ������ �����
    [DataRow("T999TT199", "T999TT199", "T999TT199", "Out of stock")]  // ��� ��������� ���������
    [DataRow("E123EK178", "E100EK178", "E130EK178", "E124EK178")]  // ���������� ����������
    public void GetNextMarkAfterInRange_WorksCorrectly(string prevMark, string rangeStart, string rangeEnd, string expected)
    {
        string actual = String.Empty;

        actual = RegMark.GetNextMarkAfterInRange(prevMark, rangeStart, rangeEnd);

        Assert.AreEqual(expected, actual);
    }

    [DataTestMethod]
    [DataRow("A999AA097", "A999AA097", "B001AA097", "A001AB097")]  // ��������� ����� � ���������
    [DataRow("A123AA777", "A100AA777", "A200AA777", "A124AA777")]  // ���������� ����� ������ ���������
    [DataRow("X999XX199", "X999XX199", "X999XX199", "Out of stock")]  // ��������� ����� � ���������
    [DataRow("M888AM150", "M800AM150", "M888AM150", "Out of stock")]  // ��������� ����� � ���������
    [DataRow("C567BC199", "C500BC199", "C570BC199", "C568BC199")]  // ���������� ������
    [DataRow("K999KK777", "K999KK777", "K001KK777", "Out of stock")]  // ��������� ����� � �����
    [DataRow("B050BB050", "B050BB050", "B060BB050", "B051BB050")]  // ���������� ������ ���������
    [DataRow("P999PP750", "P990PP750", "X001PP750", "P001PC750")]  // ��������� ����� ����� ������ �����
    [DataRow("T999TT199", "T999TT199", "T999TT199", "Out of stock")]  // ��� ��������� ���������
    [DataRow("E123EK178", "E100EK178", "E130EK178", "E124EK178")]  // ���������� ����������
    public void GetNextMarkAfterInRange_ResultIsString(string prevMark, string rangeStart, string rangeEnd, string expected)
    {
        Type type = typeof(string);

        var result = RegMark.GetNextMarkAfterInRange(prevMark, rangeStart, rangeEnd);

        Assert.IsInstanceOfType(result, type);
    }

    [DataTestMethod]
    [DataRow("A999AA097", "A999AA097", "B001AA097", "A001AB097")]  // ��������� ����� � ���������
    [DataRow("A123AA777", "A100AA777", "A200AA777", "A124AA777")]  // ���������� ����� ������ ���������
    [DataRow("X999XX199", "X999XX199", "X999XX199", "Out of stock")]  // ��������� ����� � ���������
    [DataRow("M888AM150", "M800AM150", "M888AM150", "Out of stock")]  // ��������� ����� � ���������
    [DataRow("C567BC199", "C500BC199", "C570BC199", "C568BC199")]  // ���������� ������
    [DataRow("K999KK777", "K999KK777", "K001KK777", "Out of stock")]  // ��������� ����� � �����
    [DataRow("B050BB050", "B050BB050", "B060BB050", "B051BB050")]  // ���������� ������ ���������
    [DataRow("P999PP750", "P990PP750", "X001PP750", "P001PC750")]  // ��������� ����� ����� ������ �����
    [DataRow("T999TT199", "T999TT199", "T999TT199", "Out of stock")]  // ��� ��������� ���������
    [DataRow("E123EK178", "E100EK178", "E130EK178", "E124EK178")]  // ���������� ����������
    public void GetNextMarkAfterInRange_ResultIsNotNull(string prevMark, string rangeStart, string rangeEnd, string expected)
    {
        string result = String.Empty;

        result = RegMark.GetNextMarkAfterInRange(prevMark, rangeStart, rangeEnd);

        Assert.IsNotNull(result);
    }
}
