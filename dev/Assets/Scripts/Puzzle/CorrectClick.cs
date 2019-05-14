using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CorrectClick : PuzzleInitializer {

    public bool isClicked = false;

    //Detect if a click occurs
    public void OnMouseDown()
    {
        if(!isClicked)
        {
            StopAllCoroutines();
            StartCoroutine(LightRune());
        }

        isClicked = true;
    }

    IEnumerator LightRune()
    {
        float duration = 1f;
        float t = 0;

        // yield return new WaitForSeconds(1);
        while (t < duration)
        {
            yield return null;
            this.GetComponent<Renderer>().material.color = Color.Lerp(initialColor, clickedColor, t);
            t += Time.deltaTime*4;
        }
    }
}
