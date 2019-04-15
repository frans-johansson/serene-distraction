using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Click : MonoBehaviour {

    GameObject sphere;

    void Start()
    {
        sphere = GameObject.Find("TriggerTest");
    }


    private void Update()
    {


    }
    //Detect if a click occurs
    public void OnMouseDown()
    {
        if (sphere.activeSelf)
        {
            //Output to console the clicked GameObject's name and the following message. You can replace this with your own actions for when clicking the GameObject.
            Debug.Log("Active");
        }
        else
        {
            Debug.Log("Unactive");
        }

    }
}
