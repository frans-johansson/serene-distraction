using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class musicManager : MonoBehaviour {

    public float crossoverTime;
    [Range(0,1)]
    public float maxVolume;
    private float frameStep;

    private AudioSource dayMusic;
    private AudioSource nightMusic;
    private SunMoonCycle timeOfDay;

    private void Start()
    {
        dayMusic = GetComponents<AudioSource>()[0];
        nightMusic = GetComponents<AudioSource>()[1];
        timeOfDay = FindObjectOfType<SunMoonCycle>();

        frameStep = 1 / (crossoverTime * 60);

        dayMusic.volume = 0.0f;
        nightMusic.volume = 0.0f;
    }

    private void Update()
    {
        if(timeOfDay.isNight)
        {
            if(nightMusic.volume < maxVolume)
                nightMusic.volume += frameStep;
            if (dayMusic.volume > 0.0f)
                dayMusic.volume -= frameStep;
        }
        else if(!timeOfDay.isNight)
        {
            if(dayMusic.volume < maxVolume)
                dayMusic.volume += frameStep;
            if(nightMusic.volume > 0.0f)
                nightMusic.volume -= frameStep;
        }
    }
}
