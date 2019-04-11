using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class windLeaves : MonoBehaviour
{
    /* Todo:
     * 
     * Better interface parameters to control "wind intensity"
     * Some sense of wind direction as a bias to the noise (random stuff)
     * Maybe some way of using deltaTime rather than normal time?
     * 
     */

    public float amp;
    public float angular_vel;
    public float phase_diff;
    public float eccentricity;

    private float rotX;
    private float rotY;

    // Start is called before the first frame update
    void Start()
    {}

    // Update is called once per frame
    void Update()
    {
        float t = Time.time;

        // Calculate rotation based on input params
        // Shifting phases for the other to avoid uniformity
        rotX = amp * Mathf.Sin(angular_vel * t);
        rotY = amp * Mathf.Sin(angular_vel * t + phase_diff);

        // Add some noise for a natural effect based on params
        rotX *= Random.Range(0, eccentricity);
        rotY *= Random.Range(0, eccentricity);

        // Do rotation
        gameObject.transform.Rotate(rotX, rotY, 0);
    }
}
