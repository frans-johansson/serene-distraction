using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DemoDayNightSwitch : MonoBehaviour {

    [SerializeField]
    private float speed = 50.0f;

    private SunMoonCycle dayTimeController;
    private bool CR_running;

    private void Start()
    {
        dayTimeController = FindObjectOfType<SunMoonCycle>();
        CR_running = false;
    }

    private void Update()
    {
        Debug.Log(dayTimeController.timeScale);

        if (CR_running != true && Input.GetKeyDown(KeyCode.N))
        {
            StartCoroutine(ChangeTimeOfDay());
        }
    }

    private void OnValidate()
    {
        if (speed < 1.0f)
            speed = 1.0f;
    }

    IEnumerator ChangeTimeOfDay()
    {
        Debug.Log("Coroutine started");

        CR_running = true;
        bool isCurrentlyNight = dayTimeController.isNight;

        float originalTimeScale = dayTimeController.timeScale;
        dayTimeController.timeScale *= speed;

        while(isCurrentlyNight == dayTimeController.isNight)
        {
            yield return null;
        }

        dayTimeController.timeScale = originalTimeScale;
        CR_running = false;

        Debug.Log("Coroutine ended");
    }
}
