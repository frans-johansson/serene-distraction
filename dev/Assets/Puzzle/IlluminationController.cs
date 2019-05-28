using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IlluminationController : PuzzleInitializer {
  

    private bool stopWorking = false;

    private void Update()
    {
        Debug.Log("Something");
       if (stopWorking == false && firstCorrect.isClicked == true && secondCorrect.isClicked == true)
            {
                StopAllCoroutines();
                StartCoroutine(LightAllRunes());
            }

    }

    //Detect if a click occurs
    public void OnMouseDown()
    {
        Debug.Log("Something has been clicked");

        if (stopWorking == false)
        {
            StopAllCoroutines();
            StartCoroutine(LightUp());
            Debug.Log("A rune has been clicked");
            
            if (firstCorrect.isClicked == true)
            {
                firstCorrect.isClicked = false;
                StartCoroutine(ExtinguishLight(firstCorrect));
                //firstCorrect.GetComponent<Renderer>().material.color = initialColor;
            }

            if (secondCorrect.isClicked == true)
            {
                secondCorrect.isClicked = false;
                StartCoroutine(ExtinguishLight(secondCorrect));
                //secondCorrect.GetComponent<Renderer>().material.color = initialColor;
            }
        }
 
    }


    IEnumerator LightUp()
    {
         float duration = 1;
         float t = 0;

         while(t < duration)
         {
             yield return null;
             this.GetComponent<Renderer>().material.color = Color.Lerp(clickedColor, initialColor, Mathf.PingPong(t, 1));
             t += Time.deltaTime;
         }
    }


    IEnumerator ExtinguishLight(CorrectClick clicked)
    {
        float duration = 1f;
        float t = 0;

        // yield return new WaitForSeconds(1);
        while (t < duration)
        {
            yield return null;
            clicked.GetComponent<Renderer>().material.color = Color.Lerp(clickedColor, initialColor, t);
            t += Time.deltaTime;
        }
    }


    IEnumerator LightAllRunes()
    {
        stopWorking = true;
        float duration = 1f;
        float t = 0;

        yield return new WaitForSeconds(0.2f);
        while (t < duration)
        {
            yield return null;
            this.GetComponent<Renderer>().material.color = Color.Lerp(initialColor, clickedColor, t);
            t += Time.deltaTime;
        }
    }

}
