package com.pigeon3d;

import objd.lang.*;
import objd.collection.ImArray;
import objd.collection.Iterator;

public final class Version implements Comparable<Version> {
    public final ImArray<Integer> parts;
    public static Version applyStr(final String str) {
        return new Version(new StringEx(str).splitBy(".").chain().<Integer>mapF(new F<String, Integer>() {
            @Override
            public Integer apply(final String _) {
                return new StringEx(_).toInt();
            }
        }).toArray());
    }
    @Override
    public int compareTo(final Version to) {
        final Iterator<Integer> i = this.parts.iterator();
        final Iterator<Integer> j = to.parts.iterator();
        while(i.hasNext() && j.hasNext()) {
            final int vi = i.next();
            final int vj = j.next();
            if(vi != vj) {
                return Int.compareTo(vi, vj);
            }
        }
        return 0;
    }
    public boolean lessThan(final String than) {
        return compareTo(Version.applyStr(than)) < 0;
    }
    public boolean moreThan(final String than) {
        return compareTo(Version.applyStr(than)) > 0;
    }
    public Version(final ImArray<Integer> parts) {
        this.parts = parts;
    }
    public String toString() {
        return String.format("Version(%s)", this.parts);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof Version)) {
            return false;
        }
        final Version o = ((Version)(to));
        return this.parts.equals(o.parts);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + this.parts.hashCode();
        return hash;
    }
}