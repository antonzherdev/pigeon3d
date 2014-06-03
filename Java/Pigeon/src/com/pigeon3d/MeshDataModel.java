package com.pigeon3d;

import objd.lang.*;
import objd.collection.PArray;

public class MeshDataModel {
    public final PArray<MeshData> vertex;
    public final PArray<Integer> index;
    public MeshDataModel(final PArray<MeshData> vertex, final PArray<Integer> index) {
        this.vertex = vertex;
        this.index = index;
    }
    public String toString() {
        return String.format("MeshDataModel(%s, %s)", this.vertex, this.index);
    }
}