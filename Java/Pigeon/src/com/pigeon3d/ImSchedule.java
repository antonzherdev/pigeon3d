package com.pigeon3d;

import objd.lang.*;
import objd.collection.ImList;

public class ImSchedule {
    public final ImList<ScheduleEvent> events;
    public final int time;
    public ImSchedule(final ImList<ScheduleEvent> events, final int time) {
        this.events = events;
        this.time = time;
    }
    public String toString() {
        return String.format("ImSchedule(%s, %d)", this.events, this.time);
    }
}