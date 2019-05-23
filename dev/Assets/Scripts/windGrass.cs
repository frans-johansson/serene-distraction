using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class windGrass : MonoBehaviour
{
    /* Todo:
     * 
     * Better interface parameters to control "wind intensity"
     * Some sense of wind direction as a bias to the noise (random stuff)
     * Rotation should be done around the local x-axis, not the global x-axis
     * Maybe some way of using deltaTime rather than normal time?
     * 
     */

    public float amp;
    public float angular_vel;
    public Vector2 eccentricityRange;

    private Vector3 bottom_point;
    private float rotation;

    // Start is called before the first frame update
    void Start()
    {
        // Get local (global in case of no parent objects) postion and scale
        Vector3 pos = gameObject.transform.position;
        Vector3 scale = gameObject.transform.lossyScale;

        // Calculate the bottom center-most point
        // Scale has to be multiplied by 10 to convert into position-units 
        bottom_point = pos;
        bottom_point.y -= scale.y * 10 / 2;
    }

    // Update is called once per frame
    void Update()
    {
        float t = Time.time;

        // Calculate the rotation
        rotation = amp * Mathf.Sin(angular_vel * t);

        // Add some noise for a natural effect based on params
        rotation *= Random.Range(eccentricityRange.x, eccentricityRange.y) * Random.Range(eccentricityRange.x*0.5f, eccentricityRange.y*0.5f);

        // Do rotation around the bottom center-most point around the x-axis
        Vector3 axis = new Vector3( 1, 0, 0 );
        gameObject.transform.RotateAround(bottom_point, axis, rotation);
    }
}
