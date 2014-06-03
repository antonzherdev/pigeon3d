package com.pigeon3d;

import objd.lang.*;

public abstract class InAppProduct {
    public abstract void buyQuantity(final int quantity);
    public final String id;
    public final String name;
    public final String price;
    public void buy() {
        buyQuantity(((int)(1)));
    }
    public InAppProduct(final String id, final String name, final String price) {
        this.id = id;
        this.name = name;
        this.price = price;
    }
    public String toString() {
        return String.format("InAppProduct(%s, %s, %s)", this.id, this.name, this.price);
    }
}