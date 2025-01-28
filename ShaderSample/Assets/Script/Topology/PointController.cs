using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshFilter))]
public class PointController : MonoBehaviour
{
    private void Start()
    {
        MeshFilter meshFilter = GetComponent<MeshFilter>();

        if(!meshFilter.mesh.isReadable)
        {
            Debug.LogError("Project => 問題のメッシュ(モデルまたは、3Dオブジェクト)を選択し、" +
                "「Read/Write」設定を有効にしてください。");
            return;
        }

        // メッシュのインデックスを取得してトポロジを変更
        meshFilter.mesh.SetIndices(meshFilter.mesh.GetIndices(0), MeshTopology.Points, 0);
    }
}
