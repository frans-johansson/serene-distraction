using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PuzzleInitializer : MonoBehaviour
{
    protected Color initialColor = new Color(1.0f, 0.0f, 0.0f, 1);
    protected Color clickedColor = Color.white;

    protected CorrectClick firstCorrect;
    protected CorrectClick secondCorrect;

    // Use this for initialization
    void Awake()
    {
        firstCorrect = GameObject.Find("Runa3").GetComponent<CorrectClick>();
        secondCorrect = GameObject.Find("Runa8").GetComponent<CorrectClick>();
    }
}

