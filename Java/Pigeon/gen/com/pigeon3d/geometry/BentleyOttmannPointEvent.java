package com.pigeon3d.geometry;

import objd.lang.*;

public final class BentleyOttmannPointEvent<T> extends BentleyOttmannEvent<T> {
    public final boolean isStart;
    @Override
    public boolean isStart() {
        return isStart;
    }
    public final T data;
    public final LineSegment segment;
    public final vec2 point;
    @Override
    public vec2 point() {
        return point;
    }
    public double yForX(final double x) {
        if(this.segment.line().isVertical()) {
            if(this.isStart) {
                return ((double)(this.segment.p0.y));
            } else {
                return ((double)(this.segment.p1.y));
            }
        } else {
            return ((double)(((float)(((SlopeLine)(this.segment.line())).yForX(x)))));
        }
    }
    public double slope() {
        return this.segment.line().slope();
    }
    public boolean isVertical() {
        return this.segment.line().isVertical();
    }
    @Override
    public boolean isEnd() {
        return !(this.isStart);
    }
    public BentleyOttmannPointEvent(final boolean isStart, final T data, final LineSegment segment, final vec2 point) {
        this.isStart = isStart;
        this.data = data;
        this.segment = segment;
        this.point = point;
    }
    public String toString() {
        return String.format("BentleyOttmannPointEvent(%d, %s, %s, %s)", this.isStart, this.data, this.segment, this.point);
    }
}