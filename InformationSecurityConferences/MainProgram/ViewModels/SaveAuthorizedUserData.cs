using System;
using System.IO;
using Newtonsoft.Json;

namespace MainProgram.ViewModels
{
    public class SaveAuthorizedUserData
    {
        static string GetFilePath()
        {
            string appData = Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData);

            string appFolder = Path.Combine(appData, "SecurityConference");
            if (!Directory.Exists(appFolder))
            {
                Directory.CreateDirectory(appFolder);
            }

            return Path.Combine(appFolder, "Data.json");
        }

        public static void SaveData(string token)
        {
            string pathToFile = GetFilePath();
            string json = JsonConvert.SerializeObject(token);
            File.WriteAllText(pathToFile, json);
        }

        public static void DeleteData()
        {
            string pathToFile = GetFilePath();
            if (File.Exists(pathToFile))
            {
                File.Delete(pathToFile);
            }
        }

        public static string? LoadUser()
        {
            string pathToFile = GetFilePath();
            if (File.Exists(pathToFile))
            {
                string json = File.ReadAllText(pathToFile);
                return JsonConvert.DeserializeObject<string>(json);
            }
            else
                return null;
        }
    }
}
