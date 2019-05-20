using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoonScript : MonoBehaviour
{
    [SerializeField] private float lengthOfDay; //Length of day in minutes
    private float timeScale; //Converts the game's day length to real time day length
    [Range(0, 1)] [SerializeField] private float currentTimeOfDay;
    private float intensity;

    [SerializeField] private Light moon;
    [SerializeField] private Gradient moonColor;
    [SerializeField] private float baseIntensity;


    void Update()
    {
        moon.intensity = Mathf.Lerp(0, 1, Mathf.PingPong(currentTimeOfDay, 1));
        moon.color = moonColor.Evaluate(Time.deltaTime); //Spelar gradienten "baklänges", motsatt från solen
    }

    private void UpdateTimeScale()
    {
        timeScale = 24 / (lengthOfDay / 60);
    }

    private void UpdateTime()
    {
        currentTimeOfDay += Time.deltaTime * timeScale / 86400;
        if (currentTimeOfDay > 1)
        {
            currentTimeOfDay -= 1;
        }
    }
}
