using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class triggerTest : MonoBehaviour
{

    private GameObject sphere;

    // Use this for initialization
    void Start () {
        sphere = GameObject.Find("TriggerTest");
        sphere.gameObject.SetActive(false);
    }

    

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            sphere.gameObject.SetActive(true);
        }

    }

    // stayCount allows the OnTriggerStay to be displayed less often
    // than it actually occurs.
    //private float stayCount = 0.0f;
    private void OnTriggerStay(Collider other)
    {

    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            sphere.gameObject.SetActive(false);
        }
    }
}
