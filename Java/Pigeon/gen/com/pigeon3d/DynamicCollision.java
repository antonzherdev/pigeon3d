package com.pigeon3d;

import objd.lang.*;
import objd.collection.Pair;
import objd.collection.Iterable;

public final class DynamicCollision<T> {
    public final Pair<RigidBody<T>> bodies;
    public final Iterable<Contact> contacts;
    public float impulse() {
        final Float __tmp = this.contacts.chain().<Float>mapF(new F<Contact, Float>() {
            @Override
            public Float apply(final Contact _) {
                return _.impulse;
            }
        }).<Float>max();
        if(__tmp != null) {
            return __tmp;
        } else {
            return ((float)(0.0));
        }
    }
    public DynamicCollision(final Pair<RigidBody<T>> bodies, final Iterable<Contact> contacts) {
        this.bodies = bodies;
        this.contacts = contacts;
    }
    public String toString() {
        return String.format("DynamicCollision(%s, %s)", this.bodies, this.contacts);
    }
    public boolean equals(final Object to) {
        if(this == to) {
            return true;
        }
        if(to == null || !(to instanceof DynamicCollision)) {
            return false;
        }
        final DynamicCollision<T> o = ((DynamicCollision<T>)(((DynamicCollision)(to))));
        return this.bodies.equals(o.bodies) && this.contacts.equals(o.contacts);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + this.bodies.hashCode();
        hash = hash * 31 + this.contacts.hashCode();
        return hash;
    }
}