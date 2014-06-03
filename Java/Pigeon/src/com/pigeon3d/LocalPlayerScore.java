package com.pigeon3d;

import objd.lang.*;

public class LocalPlayerScore {
    public final long value;
    public final int rank;
    public final int maxRank;
    public double percent() {
        return (((double)(this.rank)) - 1) / this.maxRank;
    }
    public LocalPlayerScore(final long value, final int rank, final int maxRank) {
        this.value = value;
        this.rank = rank;
        this.maxRank = maxRank;
    }
    public String toString() {
        return String.format("LocalPlayerScore(%d, %d, %d)", this.value, this.rank, this.maxRank);
    }
}