package com.pigeon3d;

import objd.lang.*;

public class ScheduleEvent implements Comparable<ScheduleEvent> {
    public final double time;
    public final P0 f;
    @Override
    public int compareTo(final ScheduleEvent to) {
        return Float.compareTo(this.time, to.time);
    }
    public ScheduleEvent(final double time, final P0 f) {
        this.time = time;
        this.f = f;
    }
    public String toString() {
        return String.format("ScheduleEvent(%f)", this.time);
    }
}