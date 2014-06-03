package com.pigeon3d;

import objd.lang.*;
import objd.collection.ImList;

public class MSchedule {
    private ImList<ScheduleEvent> _events;
    private double _current;
    private double _next;
    public void scheduleAfterEvent(final double after, final P0 event) {
        this._events = this._events.<ScheduleEvent>insertItem(new ScheduleEvent(this._current + after, event));
        final ScheduleEvent __tmp_1ln = this._events.head();
        if(__tmp_1ln == null) {
            throw new NullPointerException();
        }
        this._next = __tmp_1ln.time;
    }
    public void updateWithDelta(final double delta) {
        this._current += delta;
        while(this._next >= 0 && this._current > this._next) {
            final ScheduleEvent e = this._events.head();
            this._events = this._events.tail();
            if(e != null) {
                e.f.apply();
            }
            this.updateNext();
        }
    }
    public double time() {
        return this._current;
    }
    public boolean isEmpty() {
        return this._next < 0.0;
    }
    public ImSchedule imCopy() {
        return new ImSchedule(this._events, ((int)(this._current)));
    }
    public void assignImSchedule(final ImSchedule imSchedule) {
        this._events = imSchedule.events;
        this._current = ((double)(imSchedule.time));
        this.updateNext();
    }
    private void updateNext() {
        {
            final ScheduleEvent __tmp_0 = this._events.head();
            if(__tmp_0 != null) {
                this._next = this._events.head().time;
            } else {
                this._next = ((double)(-1));
            }
        }
    }
    public MSchedule() {
        this._events = ImList.<ScheduleEvent>apply();
        this._current = 0.0;
        this._next = -1.0;
    }
    public String toString() {
        return "MSchedule";
    }
}