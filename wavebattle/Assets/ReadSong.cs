using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Text;
using System.IO;

public class ReadSong : MonoBehaviour {
    int[] millis;
    string[] actions;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}

    private bool Load(string fileName)
    {
        try
        {
            string line;
            ArrayList lines = new ArrayList();
            StreamReader theReader = new StreamReader(fileName, Encoding.Default);
            using (theReader)
            {
                do
                {
                    line = theReader.ReadLine();

                    if (line != null)
                    {
                        string[] entries = line.Split(',');
                        if (entries.Length > 0)
                        {
                            lines.Add(entries);
                        }
                    }
                } while (line != null);
                
                theReader.Close();

                millis = new int[lines.Count];
                actions = new string[lines.Count];

                for (int i = 0; i < lines.Count; i++)
                {
                    millis[i] = int.Parse(((string[])lines[i])[0]);
                    actions[i] = ((string[])lines[i])[1];
                }

                return true;
            }
        }
        catch (Exception e)
        {
            Console.WriteLine("{0}\n", e.Message);
            return false;
        }
    }
}
}
