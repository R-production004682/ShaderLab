using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DisplacementController : MonoBehaviour
{
    [SerializeField] private Material topologyMaterial;
    [SerializeField] private float speed;
    [SerializeField] private float maxDisplacement = 0.1f;

    private float time = 0.0f;

    private void Update()
    {
        time += Time.deltaTime;

        float displacement = (Mathf.Sin(time - Mathf.PI / 2) + 1.0f) * 0.5f * maxDisplacement;
        topologyMaterial.SetFloat("_Displacement", displacement);
    }
}
