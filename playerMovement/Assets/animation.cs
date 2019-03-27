using UnityEngine;
using System.Collections;

public class animation : MonoBehaviour {

    private Animator m_animator;

	// Use this for initialization
	void Start () {
        m_animator = GetComponent<Animator>();
	}
	
	// Update is called once per frame
	void Update () {
        bool isWalkingPressed = false;

        if (Input.GetAxis("Vertical") != 0 || Input.GetAxis("Horizontal") != 0)
        {
            isWalkingPressed = true;
        }

        m_animator.SetBool("isWalking", isWalkingPressed);
	}
}
