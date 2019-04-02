using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class triggerTest : MonoBehaviour {

    public bool enter = true;
    public bool stay = true;
    public bool exit = true;
    private bool isSphere = false;

	// Use this for initialization
	void Start () {
        var boxCollider = gameObject.AddComponent<BoxCollider>();
        boxCollider.isTrigger = true;
    }

    

    private void OnTriggerEnter(Collider other)
    {
        if (enter)
        {
            if (!isSphere)
            {
                GameObject sphere = GameObject.CreatePrimitive(PrimitiveType.Sphere);
                sphere.gameObject.transform.position = new Vector3(15, 5.5f, 12);
                isSphere = true;
            }
        }
    }

    // stayCount allows the OnTriggerStay to be displayed less often
    // than it actually occurs.
    //private float stayCount = 0.0f;
    private void OnTriggerStay(Collider other)
    {
        if (stay)
        {
            // Nothing yet

            /*if (stayCount > 0.25f)
            {
                Debug.Log("staying");
                stayCount = stayCount - 0.25f;
            }
            else
            {
                stayCount = stayCount + Time.deltaTime;
            }*/
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (exit)
        {
            // Nothing right now
        }
    }
}
