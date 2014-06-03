package com.pigeon3d;

import objd.lang.*;
import objd.react.Signal;

public class Settings {
    public final Signal<ShadowType> shadowTypeChanged;
    private ShadowType _shadowType;
    public ShadowType shadowType() {
        return this._shadowType;
    }
    public void setShadowType(final ShadowType shadowType) {
        if(this._shadowType != shadowType) {
            this._shadowType = shadowType;
            this.shadowTypeChanged.postData(shadowType);
        }
    }
    public Settings() {
        this.shadowTypeChanged = new Signal<ShadowType>();
        this._shadowType = ShadowType.sample2d;
    }
    public String toString() {
        return "Settings";
    }
}