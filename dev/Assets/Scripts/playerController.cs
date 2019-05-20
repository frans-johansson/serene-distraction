using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class playerController : MonoBehaviour
{

    private string forwardInputAxis = "Vertical";
    private string sideInputAxis = "Horizontal";

    private CharacterController charController;

    [SerializeField] private float slopeForce;
    [SerializeField] private float slopeForceRayLength;
    [SerializeField] private float moveSpeed = 10;

    private void Awake()
    {
        charController = GetComponent<CharacterController>();
    }

    private void Update()
    {
        PlayerMovement();
    }

    private void PlayerMovement()
    {
        float verInput = Input.GetAxis(forwardInputAxis);
        float horizInput = Input.GetAxis(sideInputAxis);

        Vector3 forwardMovement = transform.forward * verInput;
        Vector3 rightMovement = transform.right * horizInput;

        Vector3 input = forwardMovement + rightMovement;

        if (input.magnitude > 1f)
        {
            input.Normalize();
        }

        charController.SimpleMove(input * moveSpeed);

        if ((verInput != 0 || horizInput != 0) && OnSlope())
        {
            charController.Move(Vector3.down * charController.height / 2 * slopeForce * Time.deltaTime);
        }
    }

    private bool OnSlope()
    {
        RaycastHit hit;

        if (Physics.Raycast(transform.position, Vector3.down, out hit, charController.height / 2 * slopeForceRayLength))
        {
            if (hit.normal != Vector3.up)
            {
                return true;
            }
        }

        return false;
    }
}