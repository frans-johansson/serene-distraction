using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public abstract class ComponentController : MonoBehaviour {

    protected SunMoonCycle sunMoonComponent;
	
    private void OnEnable()
    {
        sunMoonComponent = this.GetComponent<SunMoonCycle>();

        if (sunMoonComponent!= null)
            sunMoonComponent.AddComponent(this);
    }

    private void OnDisable()
    {
        if (sunMoonComponent!= null)
            sunMoonComponent.RemoveModule(this);
    }

    public abstract void UpdateComponent(float intensity);
}
