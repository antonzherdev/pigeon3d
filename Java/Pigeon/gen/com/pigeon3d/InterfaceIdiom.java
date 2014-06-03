package com.pigeon3d;

import objd.lang.*;

public enum InterfaceIdiom {
    phone(true, false, false),
    pad(false, true, false),
    computer(false, false, true);
    private InterfaceIdiom(final boolean isPhone, final boolean isPad, final boolean isComputer) {
        this.isPhone = isPhone;
        this.isPad = isPad;
        this.isComputer = isComputer;
    }
    public final boolean isPhone;
    public final boolean isPad;
    public final boolean isComputer;
}