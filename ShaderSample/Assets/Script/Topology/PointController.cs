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
            Debug.LogError("Project => ���̃��b�V��(���f���܂��́A3D�I�u�W�F�N�g)��I�����A" +
                "�uRead/Write�v�ݒ��L���ɂ��Ă��������B");
            return;
        }

        // ���b�V���̃C���f�b�N�X���擾���ăg�|���W��ύX
        meshFilter.mesh.SetIndices(meshFilter.mesh.GetIndices(0), MeshTopology.Points, 0);
    }
}
