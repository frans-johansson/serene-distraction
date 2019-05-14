using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PuzzleInitializer : MonoBehaviour
{
    protected Color initialColor = new Color(0.945f, 0.176f, 0.157f, 1);
    protected Color clickedColor = Color.white;

    protected CorrectClick firstCorrect;
    protected CorrectClick secondCorrect;

    // Use this for initialization
    void Awake()
    {
        firstCorrect = GameObject.Find("Runa1").GetComponent<CorrectClick>();
        secondCorrect = GameObject.Find("Runa5").GetComponent<CorrectClick>();
    }
}

