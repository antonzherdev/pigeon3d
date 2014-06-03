package com.pigeon3d;

import objd.lang.*;

public enum InAppTransactionState {
    purchasing(),
    purchased(),
    failed(),
    restored();
    private InAppTransactionState() {
    }
}