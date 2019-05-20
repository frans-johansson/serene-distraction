using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoonComponent : ComponentController {

    [SerializeField] private Light moon;
    [SerializeField] private Gradient moonColor;
    [SerializeField] private float moonMinIntensity;


    public override void UpdateComponent(float intensity)
    {
        moon.color = moonColor.Evaluate(1- intensity); //Spelar gradienten "baklänges", motsatt från solen
        moon.intensity = (1- intensity) * moonMinIntensity + 0.04f; //Bestämmer månens intensitet
    }
}
