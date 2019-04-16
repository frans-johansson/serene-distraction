using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class moonRotation : MonoBehaviour {

    [SerializeField] private Light moon;
    [SerializeField] private float timeInFullDay = 120f;

    private float startTimeSunRise = 05.00f / 24.00f;
    private float endTimeSunRise = 10.00f / 24.00f;
    private float startTimeSunSet = 17.00f / 24.00f;
    private float endTimeSunSet = 21.00f / 24.00f;

    [Range(0, 1)] [SerializeField] private float currentTimeOfDay;
    private float timeMultiplier = 1f;
    private float moonInitialIntensity;


	// Use this for initialization
	void Start () {
        moonInitialIntensity = moon.intensity;
        currentTimeOfDay = 0.5f;
	}
	
	// Update is called once per frame
	void Update () {
        UpdateMoon();

        currentTimeOfDay += Time.deltaTime / timeInFullDay; //Tiden mellan varje frame delad med antalet sekunder per "dag". Ger värde mellan 0 och 1, vilket är en dag.

        if( currentTimeOfDay >= 1)
        {
            currentTimeOfDay = 0; //Startar om dagen när currentTimeOfDay kommit upp till 1;
        }
	}

    void UpdateMoon()
    {
        moon.transform.localRotation = Quaternion.Euler((currentTimeOfDay * 360f)+90, 180, 0); //Roterar solen runt sin x-axel

        float intensityMultiplier = 1; //Kommer göra att solen får olika intensitet olika tider på dygnet

        if (currentTimeOfDay <= startTimeSunRise || currentTimeOfDay >= endTimeSunSet) //ingen intensitet i början av dagen (innan soluppgång/solnedgång)
        {
            intensityMultiplier = 1;
        }
        else if (currentTimeOfDay >= endTimeSunRise)
        {
            intensityMultiplier = Mathf.Clamp01((currentTimeOfDay - startTimeSunRise) * 1 / 0.02f); //Clamp01 ger min/max värde 0/1. Returnerar 0 om värdet är under 0, 1 och värdet är över 1. Om värdet är mellan 0 och 1 returnerar den värdet.
        
        }
        else if (currentTimeOfDay <= startTimeSunSet)
        {
            intensityMultiplier = Mathf.Clamp01(1 - ((currentTimeOfDay - endTimeSunSet) * (1 / 0.02f)));
        }
             moon.intensity = moonInitialIntensity * intensityMultiplier;
    }
}
