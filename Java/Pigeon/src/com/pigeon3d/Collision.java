package com.pigeon3d;

import objd.lang.*;
import objd.collection.Pair;
import objd.collection.Iterable;

public final class Collision<T> {
    public final Pair<CollisionBody<T>> bodies;
    public final Iterable<Contact> contacts;
    public Collision(final Pair<CollisionBody<T>> bodies, final Iterable<Contact> contacts) {
        this.bodies = bodies;
        this.contacts = contacts;
    }
    public String toString() {
        return String.format("Collision(%s, %s)", this.bodies, this.contacts);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof Collision)) {
            return false;
        }
        final Collision<T> o = ((Collision<T>)(((Collision)(to))));
        return this.bodies.equals(o.bodies) && this.contacts.equals(o.contacts);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + this.bodies.hashCode();
        hash = hash * 31 + this.contacts.hashCode();
        return hash;
    }
}