using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SunMoonCycle : MonoBehaviour
{
    [SerializeField] protected float dayLength; //Längd på dag i minuter
    [HideInInspector] public float timeScale; //Räknar ut antalet speldagar på ett "riktigt" dygn
    [Range(0, 1)] [SerializeField] private float currentTime;

    //Roterar solen
    [SerializeField] private Transform objectRotation;

    [Header("Sun Light")]
    [SerializeField] private Light sun;
    protected float intensity;
    [SerializeField] private float sunMinIntensity; //Minsta intensiteten, intensitet vid soluppgång
    [SerializeField] private float sunMaxIntensity; //Variationen i intensitet, från soluppgång till mitt på dagen
    [SerializeField] private Gradient sunColor; //Kontrollerar färgen på solen under dagen

    private float secondsInDay = 60 * 60 * 24;

    [Header("Modules")]
    private List<ComponentController> ComponentList = new List<ComponentController>();

    public bool isNight;

    void Start()
    {
        timeScale = 24 / (dayLength / 60); //timeScale skalar om dagar från speltid till riktig tid
    }

    void Update()
    {
        UpdateTimeOfDay();

        UpdateRotation();
        UpdateIntensity();
        ChangeSunColor();

        UpdateComponent();
    }

    private void UpdateTimeOfDay()
    {
        currentTime += Time.deltaTime * timeScale / secondsInDay; //Adderar tiden mellan varje frame multiplicerat med antalet sekunder på ett speldygn
        if (currentTime > 1)
        {
            currentTime = 0; //Tiden på en dag går mellan 0 och 1, så när CurrentTime = 1 återställs dagen.
        }
    }

    private void UpdateRotation()
    {
        float sunRotAngle = currentTime * 360f;
        objectRotation.transform.localRotation = Quaternion.Euler(new Vector3(sunRotAngle, 0f, 0f)); //Solen roterar runt sin x-axel
    }

    private void UpdateIntensity()
    {
        intensity = Vector3.Dot(sun.transform.forward, Vector3.down);

        if (intensity >= 0)
            isNight = false;
        else
            isNight = true;

        intensity = Mathf.Clamp01(intensity);

        // Sätter en global shadervariabel som låter oss styra Shadow Reduction
        Shader.SetGlobalFloat("_TimeOfDayModifier", intensity);

        sun.intensity = intensity * sunMaxIntensity + sunMinIntensity;
    }

    private void ChangeSunColor()
    {
        sun.color = sunColor.Evaluate(intensity); //Gradienten går mellan 0 och 1. 0 är solens färg vid horisonten, 1 är färgen mitt på dagen
    }

    public void AddComponent(ComponentController component)
    {
        ComponentList.Add(component); //Lägger till en komponent i listan
    }

    public void RemoveModule(ComponentController component)
    {
        ComponentList.Remove(component); //Tar bort en komponent från listan
    }

    private void UpdateComponent()
    {
        foreach(ComponentController module in ComponentList)
        {
            module.UpdateComponent(intensity); //Updaterar varje komponent varje frame
        }
    }

    private void SetToDayTime()
    {

    }

    private void SetToNightTime()
    {

    }
}
 