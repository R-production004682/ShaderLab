using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Sample : MonoBehaviour
{
    void Update()
    {
         Transform trn = this.transform;
         trn.Rotate(0.0f, 0.05f, 0.0f, Space.World);
    }
}
