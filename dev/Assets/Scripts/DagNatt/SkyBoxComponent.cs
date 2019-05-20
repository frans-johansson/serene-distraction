using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SkyBoxComponent : ComponentController
{
    [SerializeField] private Gradient skyColor;
    [SerializeField] private Gradient groundColor;

    public override void UpdateComponent(float intensity)
    {        
        RenderSettings.skybox.SetColor("_SkyTint", skyColor.Evaluate(intensity)); //Ändrar himlens färg enligt en gradient
        RenderSettings.skybox.SetColor("_GroundColor", groundColor.Evaluate(intensity)); //Ändrar markens/horisontens färg enligt gradient
    }
}
