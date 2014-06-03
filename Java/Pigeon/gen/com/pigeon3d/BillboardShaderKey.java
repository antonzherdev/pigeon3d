package com.pigeon3d;

import objd.lang.*;

public final class BillboardShaderKey {
    public final boolean texture;
    public final boolean alpha;
    public final boolean shadow;
    public final BillboardShaderSpace modelSpace;
    public BillboardShader shader() {
        return new BillboardShader(this, new BillboardShaderBuilder(this).program());
    }
    public BillboardShaderKey(final boolean texture, final boolean alpha, final boolean shadow, final BillboardShaderSpace modelSpace) {
        this.texture = texture;
        this.alpha = alpha;
        this.shadow = shadow;
        this.modelSpace = modelSpace;
    }
    public String toString() {
        return String.format("BillboardShaderKey(%d, %d, %d, %s)", this.texture, this.alpha, this.shadow, this.modelSpace);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof BillboardShaderKey)) {
            return false;
        }
        final BillboardShaderKey o = ((BillboardShaderKey)(to));
        return this.texture.equals(o.texture) && this.alpha.equals(o.alpha) && this.shadow.equals(o.shadow) && this.modelSpace == o.modelSpace;
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + this.texture;
        hash = hash * 31 + this.alpha;
        hash = hash * 31 + this.shadow;
        hash = hash * 31 + this.modelSpace.hashCode();
        return hash;
    }
}