package com.pigeon3d;

import objd.lang.*;
import objd.collection.ImArray;
import objd.collection.Iterator;
import objd.collection.Go;

public class MeshModel {
    public final ImArray<VertexArray<Material>> arrays;
    public static MeshModel applyMeshes(final ImArray<Tuple<Mesh, Material>> meshes) {
        return MeshModel.applyShadowMeshes(false, meshes);
    }
    public static MeshModel applyShadowMeshes(final boolean shadow, final ImArray<Tuple<Mesh, Material>> meshes) {
        return new MeshModel(meshes.chain().<VertexArray<Material>>mapF(new F<Tuple<Mesh, Material>, VertexArray<Material>>() {
            @Override
            public VertexArray<Material> apply(final Tuple<Mesh, Material> p) {
                return p.a.<Material>vaoMaterialShadow(p.b, shadow);
            }
        }).toArray());
    }
    public void draw() {
        {
            final Iterator<VertexArray<Material>> __il__0i = this.arrays.iterator();
            while(__il__0i.hasNext()) {
                final VertexArray<Material> _ = __il__0i.next();
                _.draw();
            }
        }
    }
    public void drawOnly(final int only) {
        if(only == 0) {
            return ;
        }
        int o = only;
        {
            Go __il__2ret = Go.Continue;
            final Iterator<VertexArray<Material>> __il__2i = this.arrays.iterator();
            while(__il__2i.hasNext()) {
                final VertexArray<Material> a = __il__2i.next();
                a.draw();
                o--;
                if(((o > 0) ? (Go.Continue) : (Go.Break)) == Go.Break) {
                    __il__2ret = Go.Break;
                    break;
                }
            }
            return __il__2ret;
        }
    }
    public MeshModel(final ImArray<VertexArray<Material>> arrays) {
        this.arrays = arrays;
    }
    public String toString() {
        return String.format("MeshModel(%s)", this.arrays);
    }
}