using UnityEngine;
using System.Collections;

public class animation : MonoBehaviour
{

    private Animator m_animator;
    private AudioSource footstepSource;
    bool isWalkingPressed;

    // Use this for initialization
    void Awake()
    {
        m_animator = GetComponent<Animator>();
        footstepSource = GetComponent<AudioSource>();
    }

    // Update is called once per frame
    void Update()
    {
        bool isWalkingPressed = false;

        if (Input.GetAxis("Vertical") != 0 || Input.GetAxis("Horizontal") != 0)
        {

            isWalkingPressed = true;

            if (!footstepSource.isPlaying)
            {
                footstepSource.Play();
            }
        }
        else
        {
            footstepSource.Stop();
            isWalkingPressed = false;
        }

        m_animator.SetBool("isWalking", isWalkingPressed);
    }
}