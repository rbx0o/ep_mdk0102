using REG_MARK_LIB;

namespace UnitTesting
{
    [TestClass]
    public sealed class GetNextMarkAfterTests
    {
        [DataTestMethod]
        [DataRow("A001AA01", "A002AA001")]
        [DataRow("M456MM77", "M457MM077")]
        [DataRow("X789TX99", "X790TX099")]
        [DataRow("A999EX178", "A001KA178")]
        [DataRow("H999OH97", "H001OO097")]
        [DataRow("O888AO150", "O889AO150")]
        [DataRow("T999TT199", "T001TУ199")]
        [DataRow("C999ХХ777", "T001AA777")]
        [DataRow("P333PP22", "P334PP022")]
        [DataRow("X999XX44", "X999XX044")]
        public void GetNextMarkAfter_WorksCorrectly(string startMark, string excepted)
        {
            string actual = String.Empty;

            actual = RegMark.GetNextMarkAfter(startMark);

            Assert.AreEqual(excepted, actual);
        }

        [DataTestMethod]
        [DataRow("A001AA01", "A002AA001")]
        [DataRow("M456MM77", "M457MM077")]
        [DataRow("X789TX99", "X790TX099")]
        [DataRow("A999EX178", "A001KA178")]
        [DataRow("H999OH97", "H001OO097")]
        [DataRow("O888AO150", "O889AO150")]
        [DataRow("T999TT199", "T001TY199")]
        [DataRow("C999ХХ777", "T001AA777")]
        [DataRow("P333PP22", "P334PP022")]
        [DataRow("X999XX44", "X999XX044")]
        public void GetNextMarkAfter_ResultIsString(string startMark, string excepted)
        {
            Type type = typeof(string);
            var result = RegMark.GetNextMarkAfter(startMark);

            Assert.IsInstanceOfType(result, type);
        }

        [DataTestMethod]
        [DataRow("A001AA01", "A002AA001")]
        [DataRow("M456MM77", "M457MM077")]
        [DataRow("X789TX99", "X790TX099")]
        [DataRow("A999EX178", "A001KA178")]
        [DataRow("H999OH97", "H001OO097")]
        [DataRow("O888AO150", "O889AO150")]
        [DataRow("T999TT199", "T001TY199")]
        [DataRow("C999ХХ777", "T001AA777")]
        [DataRow("P333PP22", "P334PP022")]
        [DataRow("X999XX44", "X999XX044")]
        public void GetNextMarkAfter_ResultIsNotNull(string startMark, string excepted)
        {
            string result = String.Empty;

            result = RegMark.GetNextMarkAfter(startMark);

            Assert.IsNotNull(result);
        }

    }
}
