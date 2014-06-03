package com.pigeon3d;

import objd.lang.*;
import objd.react.Signal;

public class InAppTransaction {
    public static final Signal<InAppTransaction> changed;
    public static final Signal<InAppTransaction> finished;
    public final String productId;
    public final int quantity;
    public final InAppTransactionState state;
    public final String error;
    public void finish() {
        InAppTransaction.finished.postData(this);
    }
    public InAppTransaction(final String productId, final int quantity, final InAppTransactionState state, final String error) {
        this.productId = productId;
        this.quantity = quantity;
        this.state = state;
        this.error = error;
    }
    public String toString() {
        return String.format("InAppTransaction(%s, %d, %s, %s)", this.productId, this.quantity, this.state, this.error);
    }
    static {
        changed = new Signal<InAppTransaction>();
        finished = new Signal<InAppTransaction>();
    }
}