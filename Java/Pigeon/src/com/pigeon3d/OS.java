package com.pigeon3d;

import objd.lang.*;

public final class OS {
    public final OSType tp;
    public final Version version;
    public final boolean jailbreak;
    public boolean isIOS() {
        return this.tp == OSType.iOS;
    }
    public boolean isIOSLessVersion(final String version) {
        return this.tp == OSType.iOS && this.version.lessThan(version);
    }
    public OS(final OSType tp, final Version version, final boolean jailbreak) {
        this.tp = tp;
        this.version = version;
        this.jailbreak = jailbreak;
    }
    public String toString() {
        return String.format("OS(%s, %s, %d)", this.tp, this.version, this.jailbreak);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof OS)) {
            return false;
        }
        final OS o = ((OS)(to));
        return this.tp == o.tp && this.version.equals(o.version) && this.jailbreak.equals(o.jailbreak);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + this.tp.hashCode();
        hash = hash * 31 + this.version.hashCode();
        hash = hash * 31 + this.jailbreak;
        return hash;
    }
}