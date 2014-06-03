package com.pigeon3d;

import objd.lang.*;
import objd.collection.MHashMap;
import objd.collection.ImArray;
import objd.collection.Iterator;
import objd.collection.Iterable;

public abstract class PhysicsWorld<T> {
    public abstract void _addBody(final PhysicsBody<T> body);
    public abstract void _removeBody(final PhysicsBody<T> body);
    private final MHashMap<T, PhysicsBody<T>> _bodiesMap;
    private ImArray<PhysicsBody<T>> _bodies;
    public void addBody(final PhysicsBody<T> body) {
        this._bodies = this._bodies.addItem(body);
        this._bodiesMap.setKeyValue(body.data(), body);
        _addBody(body);
    }
    public void removeBody(final PhysicsBody<T> body) {
        _removeBody(body);
        this._bodiesMap.removeKey(body.data());
        final ImArray<PhysicsBody<T>> bs = this._bodies;
        this._bodies = bs.subItem(body);
    }
    public boolean removeItem(final T item) {
        {
            final Boolean __tmp_0;
            {
                final PhysicsBody<T> body = this._bodiesMap.removeKey(item);
                if(body != null) {
                    removeBody(((PhysicsBody<T>)(((PhysicsBody)(body)))));
                    __tmp_0 = true;
                } else {
                    __tmp_0 = null;
                }
            }
            if(__tmp_0 != null) {
                return __tmp_0;
            } else {
                return false;
            }
        }
    }
    public PhysicsBody<T> bodyForItem(final T item) {
        return this._bodiesMap.applyKey(item);
    }
    public void clear() {
        {
            final Iterator<PhysicsBody<T>> __il__0i = this._bodies.iterator();
            while(__il__0i.hasNext()) {
                final PhysicsBody<T> body = __il__0i.next();
                _removeBody(body);
            }
        }
        this._bodies = ImArray.<PhysicsBody<T>>empty();
        this._bodiesMap.clear();
    }
    public Iterable<PhysicsBody<T>> bodies() {
        return this._bodies;
    }
    public PhysicsWorld() {
        this._bodiesMap = new MHashMap<T, PhysicsBody<T>>();
        this._bodies = ImArray.<PhysicsBody<T>>empty();
    }
    public String toString() {
        return "PhysicsWorld";
    }
}