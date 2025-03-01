namespace REG_MARK_LIB
{
    public class RegMark
    {
        private char[] letters;
        private char[] nums;
        private string region;

        public string Mark 
        { 
            get { return $"{letters[0]}{nums[0]}{nums[1]}{nums[2]}{letters[1]}{letters[2]}{region}"; }
            set { }
        }

        private static List<char> cyryllicValidLetters = new List<char> { 'А', 'В', 'Е', 'К', 'М', 'Н', 'О', 'Р', 'С', 'Т', 'У', 'Х' };
        private static List<char> englishValidLetters = new List<char> { 'A', 'B', 'E', 'K', 'M', 'H', 'O', 'P', 'C', 'T', 'У', 'X' };
        private static List<char> digits = new List<char> { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' };

        private List<string> regionCodes = new List<string>
        {
            "001", "002", "003", "004", "005", "006", "007", "008", "009", "010", "011", "012", "013", "014", "015", "016", "017", "018", "019", "020",
            "021", "022", "023", "024", "025", "026", "027", "028", "029", "030", "031", "032", "033", "034", "035", "036", "037", "038", "039", "040",
            "041", "042", "043", "044", "045", "046", "047", "048", "049", "050", "051", "052", "053", "054", "055", "056", "057", "058", "059", "060",
            "061", "062", "063", "064", "065", "066", "067", "068", "069", "070", "071", "072", "073", "074", "075", "076", "077", "078", "079", "080",
            "081", "082", "083", "084", "085", "086", "087", "088", "089", "090", "091", "092", "094", "098", "099", "102", "116", "123", "124", "125", 
            "126", "130", "134", "136", "138", "142", "147", "150", "152", "154", "156", "158", "161", "163", "164", "165", "168", "172", "174", "177",
            "178", "180", "181", "184", "185", "186", "188", "190", "193", "196", "197", "198", "199", "200", "202", "250", "252", "550", "750", "790", 
            "777", "797", "799", "097"
        };

        public static RegMark operator ++(RegMark mark)
        {
            // Серия не кончилась: прибавить число
            if (Convert.ToInt32(new string(mark.nums)) < 999)
            {
                return new RegMark($"{mark.letters[0]}{Convert.ToInt32(new string(mark.nums)) + 1:D3}{mark.letters[1]}{mark.letters[2]}{mark.region}");
            }
            // Серия кончилась: сбросить номер до 001, начать новую серию
            else if (Convert.ToInt32(new string(mark.nums)) == 999) 
            {
                // Сбросить 3 букву до А и номер до 001, прибавить 1 или 2 букву
                if (mark.letters[2] == cyryllicValidLetters[11] || mark.letters[2] == englishValidLetters[11])
                {
                    // Сбросить 2 и 3 буквы до А и номер до 001, прибавить 1 букву
                    if (mark.letters[1] == cyryllicValidLetters[11] || mark.letters[1] == englishValidLetters[11])
                    {
                        // Если в данном регионе кончились все номера
                        if (mark.letters[0] == cyryllicValidLetters[11] || mark.letters[0] == englishValidLetters[11])
                            return new RegMark(mark.Mark);

                        if (cyryllicValidLetters.Contains(mark.letters[0])) return new RegMark($"{cyryllicValidLetters[cyryllicValidLetters.IndexOf(mark.letters[0]) + 1]}001AA{mark.region}");
                        if (englishValidLetters.Contains(mark.letters[0])) return new RegMark($"{englishValidLetters[englishValidLetters.IndexOf(mark.letters[0]) + 1]}001AA{mark.region}");
                    }
                    // Прибавить 2 букву, сбросить 3 букву до А и сбросить номер до 001
                    else
                    {
                        if (cyryllicValidLetters.Contains(mark.letters[1])) return new RegMark($"{mark.letters[0]}001{cyryllicValidLetters[cyryllicValidLetters.IndexOf(mark.letters[1]) + 1]}A{mark.region}");
                        if (englishValidLetters.Contains(mark.letters[1])) return new RegMark($"{mark.letters[0]}001{englishValidLetters[englishValidLetters.IndexOf(mark.letters[1]) + 1]}A{mark.region}");
                    }
                }
                // Прибавить 3 букву и сбросить номер до 001
                else
                {
                    if (cyryllicValidLetters.Contains(mark.letters[2])) return new RegMark($"{mark.letters[0]}001{mark.letters[1]}{cyryllicValidLetters[cyryllicValidLetters.IndexOf(mark.letters[2]) + 1]}{mark.region}");
                    if (englishValidLetters.Contains(mark.letters[2])) return new RegMark($"{mark.letters[0]}001{mark.letters[1]}{englishValidLetters[englishValidLetters.IndexOf(mark.letters[2]) + 1]}{mark.region}");
                }
            }
            return new RegMark(mark.Mark);
        }

        public static bool operator >(RegMark mark1, RegMark mark2)
        {
            int[] lettersInd1 = { 0, 0, 0 };
            int[] lettersInd2 = { 0, 0, 0 };

            if (cyryllicValidLetters.Contains(mark1.letters[0])) lettersInd1[0] = cyryllicValidLetters.IndexOf(mark1.letters[0]);
            if (englishValidLetters.Contains(mark1.letters[0])) lettersInd1[0] = englishValidLetters.IndexOf(mark1.letters[0]);

            if (cyryllicValidLetters.Contains(mark2.letters[0])) lettersInd2[0] = cyryllicValidLetters.IndexOf(mark2.letters[0]);
            if (englishValidLetters.Contains(mark2.letters[0])) lettersInd2[0] = englishValidLetters.IndexOf(mark2.letters[0]);

            if (cyryllicValidLetters.Contains(mark1.letters[1])) lettersInd1[1] = cyryllicValidLetters.IndexOf(mark1.letters[1]);
            if (englishValidLetters.Contains(mark1.letters[1])) lettersInd1[1] = englishValidLetters.IndexOf(mark1.letters[1]);

            if (cyryllicValidLetters.Contains(mark2.letters[1])) lettersInd2[1] = cyryllicValidLetters.IndexOf(mark2.letters[1]);
            if (englishValidLetters.Contains(mark2.letters[1])) lettersInd2[1] = englishValidLetters.IndexOf(mark2.letters[1]);

            if (cyryllicValidLetters.Contains(mark1.letters[2])) lettersInd1[2] = cyryllicValidLetters.IndexOf(mark1.letters[2]);
            if (englishValidLetters.Contains(mark1.letters[2])) lettersInd1[2] = englishValidLetters.IndexOf(mark1.letters[2]);

            if (cyryllicValidLetters.Contains(mark2.letters[2])) lettersInd2[2] = cyryllicValidLetters.IndexOf(mark2.letters[2]);
            if (englishValidLetters.Contains(mark2.letters[2])) lettersInd2[2] = englishValidLetters.IndexOf(mark2.letters[2]);

            if (lettersInd1[0] == lettersInd2[0])
            {
                if (lettersInd1[1] == lettersInd2[1])
                {
                    if (lettersInd1[2] == lettersInd2[2])
                    {
                        return Convert.ToInt32(new string(mark1.nums)) > Convert.ToInt32(new string(mark2.nums));
                    }
                    else
                        return lettersInd1[2] > lettersInd2[2];
                }
                else
                    return lettersInd1[1] > lettersInd2[1];
            }
            else
                return lettersInd1[0] > lettersInd2[0];
        }

        public static bool operator <(RegMark mark1, RegMark mark2)
        {
            int[] lettersInd1 = { 0, 0, 0 };
            int[] lettersInd2 = { 0, 0, 0 };

            if (cyryllicValidLetters.Contains(mark1.letters[0])) lettersInd1[0] = cyryllicValidLetters.IndexOf(mark1.letters[0]);
            if (englishValidLetters.Contains(mark1.letters[0])) lettersInd1[0] = englishValidLetters.IndexOf(mark1.letters[0]);

            if (cyryllicValidLetters.Contains(mark2.letters[0])) lettersInd2[0] = cyryllicValidLetters.IndexOf(mark2.letters[0]);
            if (englishValidLetters.Contains(mark2.letters[0])) lettersInd2[0] = englishValidLetters.IndexOf(mark2.letters[0]);

            if (cyryllicValidLetters.Contains(mark1.letters[1])) lettersInd1[1] = cyryllicValidLetters.IndexOf(mark1.letters[1]);
            if (englishValidLetters.Contains(mark1.letters[1])) lettersInd1[1] = englishValidLetters.IndexOf(mark1.letters[1]);

            if (cyryllicValidLetters.Contains(mark2.letters[1])) lettersInd2[1] = cyryllicValidLetters.IndexOf(mark2.letters[1]);
            if (englishValidLetters.Contains(mark2.letters[1])) lettersInd2[1] = englishValidLetters.IndexOf(mark2.letters[1]);

            if (cyryllicValidLetters.Contains(mark1.letters[2])) lettersInd1[2] = cyryllicValidLetters.IndexOf(mark1.letters[2]);
            if (englishValidLetters.Contains(mark1.letters[2])) lettersInd1[2] = englishValidLetters.IndexOf(mark1.letters[2]);

            if (cyryllicValidLetters.Contains(mark2.letters[2])) lettersInd2[2] = cyryllicValidLetters.IndexOf(mark2.letters[2]);
            if (englishValidLetters.Contains(mark2.letters[2])) lettersInd2[2] = englishValidLetters.IndexOf(mark2.letters[2]);

            if (lettersInd1[0] == lettersInd2[0])
            {
                if (lettersInd1[1] == lettersInd2[1])
                {
                    if (lettersInd1[2] == lettersInd2[2])
                    {
                        return Convert.ToInt32(new string(mark1.nums)) < Convert.ToInt32(new string(mark2.nums));
                    }
                    else
                        return lettersInd1[2] < lettersInd2[2];
                }
                else
                    return lettersInd1[1] < lettersInd2[1];
            }
            else
                return lettersInd1[0] < lettersInd2[0];
        }

        private RegMark(string mark)
        {
            letters = $"{mark.ToCharArray()[0]}{mark.ToCharArray()[4]}{mark.ToCharArray()[5]}".ToUpper().ToCharArray();
            nums = $"{mark.ToCharArray()[1]}{mark.ToCharArray()[2]}{mark.ToCharArray()[3]}".ToCharArray();
            region = new string(mark.ToCharArray()[6..]);

            if (region.Length == 2) region = $"0{region}";
        }        

        private bool CheckMark()
        {
            if (
                (cyryllicValidLetters.Contains(letters[0]) || englishValidLetters.Contains(letters[0])) &&
                (cyryllicValidLetters.Contains(letters[1]) || englishValidLetters.Contains(letters[1])) &&
                (cyryllicValidLetters.Contains(letters[2]) || englishValidLetters.Contains(letters[2])) &&
                regionCodes.Contains(region) &&
                digits.Contains(nums[0]) && digits.Contains(nums[1]) && digits.Contains(nums[2]) &&
                new string(nums) != "000"
                ) return true;

            return false;
        }

        public static bool CheckMark(string mark)
        {
            RegMark tempMark = new RegMark(mark);

            if (
                (cyryllicValidLetters.Contains(tempMark.letters[0]) || englishValidLetters.Contains(tempMark.letters[0])) &&
                (cyryllicValidLetters.Contains(tempMark.letters[1]) || englishValidLetters.Contains(tempMark.letters[1])) &&
                (cyryllicValidLetters.Contains(tempMark.letters[2]) || englishValidLetters.Contains(tempMark.letters[2])) &&
                tempMark.regionCodes.Contains(tempMark.region) &&
                digits.Contains(tempMark.nums[0]) && digits.Contains(tempMark.nums[1]) && digits.Contains(tempMark.nums[2]) &&
                new string(tempMark.nums) != "000"
                ) return true;

            return false;
        }

        public static string GetNextMarkAfter(string mark)
        {
            RegMark tempMark = new RegMark(mark);

            if (!tempMark.CheckMark())
            {
                throw new Exception("Неверный формат гос номера");
            }            
            tempMark++;

            return tempMark.Mark;
        }

        public static string GetNextMarkAfterInRange(string prevMark, string rangeStart, string rangeEnd)
        {
            RegMark rangeStartMark = new RegMark(rangeStart);
            RegMark rangeEndMark = new RegMark(rangeEnd);
            RegMark tempMark = new RegMark(prevMark);

            if (!rangeStartMark.CheckMark() || !rangeEndMark.CheckMark() || !tempMark.CheckMark())
            {
                throw new Exception("Неверный формат гос номера");
            }

            if (tempMark < rangeStartMark || tempMark > rangeEndMark || tempMark.Mark == rangeEnd)
            {
                return "Out of stock";
            }

            tempMark++;

            return tempMark.Mark;
        }

        public static int GetCombinationsCountInRange(string mark1, string mark2)
        {          
            RegMark rangeStartMark = new RegMark(mark1);
            RegMark currentMark = new RegMark(mark1);
            RegMark rangeEndMark = new RegMark(mark2);

            if (!rangeStartMark.CheckMark() || !rangeEndMark.CheckMark())
            {
                throw new Exception("Неверный формат гос номера");
            }

            int count = 0;
            while (currentMark < rangeEndMark)
            {
                currentMark++;
                count++;
            }
            count++;

            return count;
        }
    }
}