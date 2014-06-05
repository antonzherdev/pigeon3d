package com.pigeon3d;

import objd.lang.*;
import objd.collection.Int4Buffer;

public class MeshDataModel {
    public final MeshDataBuffer vertex;
    public final Int4Buffer index;
    public MeshDataModel(final MeshDataBuffer vertex, final Int4Buffer index) {
        this.vertex = vertex;
        this.index = index;
    }
    public String toString() {
        return String.format("MeshDataModel(%s, %s)", this.vertex, this.index);
    }
}