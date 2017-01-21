using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Wave2 : MonoBehaviour {
    float[] yvalues;
    public int numPoints = 200;
    public int stepsPerFrame = 1;

    float width;

    int yValHead;

    public float amplitude = 75.0f;
    public float scale = 1000;

    public GameObject baseChild;
    GameObject[] points;

    public GameObject renderQuad;

    bool[] currPlaying;
    float[] timesPressed;
    int numPlaying;

    public string[] inputNames = { "Q", "W", "E", "R", "T", "Y" };

	// Use this for initialization
	void Start () {
        width = renderQuad.transform.lossyScale.x;

        renderQuad.SetActive(false);

        yvalues = new float[numPoints];
        points = new GameObject[numPoints - 1];

        for (int i = 0; i < points.Length; i++)
        {
            points[i] = Instantiate(baseChild);
            points[i].transform.parent = transform;
            points[i].transform.localPosition = new Vector3((i - 1) * width / numPoints - width / 2, 0, 0);
        }

        yValHead = 0;

        currPlaying = new bool[inputNames.Length];
        timesPressed = new float[inputNames.Length];
    }
	
	// Update is called once per frame
	void Update () {
        HandleInput();

        float x = Time.time * scale * 1000;
        for (int i = 0;  i < stepsPerFrame; i++)
        {
            int index = yvalues.Length - yValHead - 1 + i;
            if (index >= yvalues.Length)
                index -= yvalues.Length;
            yvalues[index] = amplitude *
                ((currPlaying[0] ? Mathf.Sin(x - timesPressed[0]) : 0) +
                (currPlaying[1] ? Mathf.Sin(2 * (x - timesPressed[1])) : 0) +
                (currPlaying[2] ? Mathf.Sin(4 * (x - timesPressed[2])) : 0) +
                (currPlaying[3] ? Mathf.Sin(8 * (x - timesPressed[3])) : 0) +
                (currPlaying[4] ? Mathf.Sin(16 * (x - timesPressed[4])) : 0) +
                (currPlaying[5] ? Mathf.Sin(32 * (x - timesPressed[5])) : 0));

            x -= 1.0f / Time.deltaTime * stepsPerFrame;
        }

        yValHead += stepsPerFrame;
        yValHead = yValHead % yvalues.Length;

        float prev = -131313;
        for (int i = 0; i < yvalues.Length; i++)
        {
            int adj_index = (i - yValHead) % yvalues.Length;
            if (adj_index < 0)
            {
                adj_index += yvalues.Length;
            }

            if (prev != -131313)
            {
                Transform t = points[i - 1].transform;
                t.localPosition = new Vector3(t.localPosition.x, (yvalues[adj_index] + prev) / 2, 0);
                t.localScale = new Vector3(Mathf.Sqrt(width * width / (numPoints * numPoints) +
                        (yvalues[adj_index] - prev) * (yvalues[adj_index] - prev)) * 1.1f,
                        t.localScale.y, t.localScale.z);
                t.localEulerAngles = new Vector3(0, 0,
                    Mathf.Atan2(yvalues[adj_index] - prev,
                    width / numPoints) * 180 / Mathf.PI);
            }

            prev = yvalues[adj_index];
        }
	}

    void HandleInput()
    {
        for (int i = 0; i < inputNames.Length; i++)
        {
            if ((Input.GetAxis(inputNames[i]) > 0) != currPlaying[i])
            {
                if (currPlaying[i])
                {
                    currPlaying[i] = false;
                    numPlaying -= 1;
                }
                else
                {
                    currPlaying[i] = true;
                    numPlaying += 1;
                    timesPressed[i] = Time.time * scale * 1000;
                }
            }
        }

    }
}
