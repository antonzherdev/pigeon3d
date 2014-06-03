package com.pigeon3d;

import objd.lang.*;
import objd.react.Signal;
import objd.react.Var;
import objd.react.Observer;
import com.pigeon3d.geometry.vec2;
import objd.collection.ImArray;
import com.pigeon3d.geometry.Rect;
import com.pigeon3d.geometry.vec4;
import com.pigeon3d.geometry.mat4;
import com.pigeon3d.geometry.Line3;
import com.pigeon3d.geometry.Plane;
import com.pigeon3d.geometry.vec3;

public class CameraIsoMove extends InputProcessor_impl {
    public final CameraIso base;
    public final double minScale;
    public final double maxScale;
    public final int panFingers;
    public final int tapFingers;
    private CameraIso _currentBase;
    private CameraIso _camera;
    public final Signal<CameraIsoMove> changed;
    public final Var<Float> scale;
    private final Observer<Float> scaleObs;
    public final Var<vec2> center;
    private final Observer<vec2> centerObs;
    private vec2 _startPan;
    private double _startScale;
    private vec2 _pinchLocation;
    private vec2 _startCenter;
    public boolean panEnabled;
    public boolean tapEnabled;
    public boolean pinchEnabled;
    public CameraIso camera() {
        return this._camera;
    }
    public double viewportRatio() {
        return this._currentBase.viewportRatio;
    }
    public void setViewportRatio(final double viewportRatio) {
        this._currentBase = new CameraIso(this._currentBase.tilesOnScreen, this._currentBase.reserve, viewportRatio, this._currentBase.center);
        this._camera = new CameraIso(this._camera.tilesOnScreen, this._camera.reserve, viewportRatio, this._camera.center);
    }
    public CameraReserve reserve() {
        return this._currentBase.reserve;
    }
    public void setReserve(final CameraReserve reserve) {
        this._currentBase = new CameraIso(this._currentBase.tilesOnScreen, reserve, this._currentBase.viewportRatio, this._currentBase.center);
        this._camera = new CameraIso(this._camera.tilesOnScreen, reserve, this._camera.viewportRatio, this._camera.center);
    }
    @Override
    public Recognizers recognizers() {
        return new Recognizers(ImArray.fromObjects(((Recognizer<Object>)(((Recognizer)(Recognizer.<PinchParameter>applyTpBeganChangedEnded(((RecognizerType<LongRecognizer, PinchParameter>)(((RecognizerType)(new Pinch())))), new F<Event<PinchParameter>, Boolean>() {
            @Override
            public Boolean apply(final Event<PinchParameter> event) {
                if(CameraIsoMove.this.pinchEnabled) {
                    CameraIsoMove.this._startScale = CameraIsoMove.this.scale.value();
                    CameraIsoMove.this._pinchLocation = event.location();
                    CameraIsoMove.this._startCenter = CameraIsoMove.this._camera.center;
                    return true;
                } else {
                    return false;
                }
            }
        }, new P<Event<PinchParameter>>() {
            @Override
            public void apply(final Event<PinchParameter> event) {
                final double s = event.param().scale;
                CameraIsoMove.this.scale.setValue(CameraIsoMove.this._startScale * s);
                CameraIsoMove.this.center.setValue(((s <= 1.0) ? (CameraIsoMove.this._startCenter) : (((s < 2.0) ? (vec2.addVec2(CameraIsoMove.this._startCenter, vec2.mulF(vec2.subVec2(CameraIsoMove.this._pinchLocation, CameraIsoMove.this._startCenter), s - 1.0))) : (CameraIsoMove.this._pinchLocation)))));
            }
        }, new P<Event<PinchParameter>>() {
            @Override
            public void apply(final Event<PinchParameter> event) {
            }
        }))))), ((Recognizer<Object>)(((Recognizer)(Recognizer.<Void>applyTpBeganChangedEnded(((RecognizerType<LongRecognizer, Void>)(((RecognizerType)(new Pan(this.panFingers))))), new F<Event<Void>, Boolean>() {
            @Override
            public Boolean apply(final Event<Void> event) {
                CameraIsoMove.this._startPan = event.location();
                return CameraIsoMove.this.panEnabled && CameraIsoMove.this.scale.value() > 1.0;
            }
        }, new P<Event<Void>>() {
            @Override
            public void apply(final Event<Void> event) {
                CameraIsoMove.this.center.setValue(vec2.subVec2(vec2.addVec2(CameraIsoMove.this._camera.center, CameraIsoMove.this._startPan), event.location()));
            }
        }, new P<Event<Void>>() {
            @Override
            public void apply(final Event<Void> event) {
            }
        }))))), ((Recognizer<Object>)(((Recognizer)(Recognizer.<Void>applyTpOn(((RecognizerType<ShortRecognizer, Void>)(((RecognizerType)(new Tap(this.tapFingers, ((int)(2))))))), new F<Event<Void>, Boolean>() {
            @Override
            public Boolean apply(final Event<Void> event) {
                if(CameraIsoMove.this.tapEnabled) {
                    if(!(CameraIsoMove.this.scale.value().equals(CameraIsoMove.this.maxScale))) {
                        final vec2 loc = event.location();
                        CameraIsoMove.this.scale.setValue(CameraIsoMove.this.maxScale);
                        CameraIsoMove.this.center.setValue(loc);
                    } else {
                        CameraIsoMove.this.scale.setValue(1.0);
                        CameraIsoMove.this.center.setValue(CameraIsoMove.this._currentBase.naturalCenter());
                    }
                    return true;
                } else {
                    return false;
                }
            }
        })))))));
    }
    private Rect centerBounds() {
        final vec2 sizeP = vec2.applyF(2.0 - 2.0 / this.scale.value());
        return new Rect(vec2.divF(sizeP, -2.0), sizeP);
    }
    public CameraIsoMove(final CameraIso base, final double minScale, final double maxScale, final int panFingers, final int tapFingers) {
        this.base = base;
        this.minScale = minScale;
        this.maxScale = maxScale;
        this.panFingers = panFingers;
        this.tapFingers = tapFingers;
        this._currentBase = base;
        this._camera = base;
        this.changed = new Signal<CameraIsoMove>();
        this.scale = Var.<Float>limitedInitialLimits(1.0, new F<Float, Float>() {
            @Override
            public Float apply(final Float s) {
                return Float.clampMinMax(s, minScale, maxScale);
            }
        });
        this.scaleObs = this.scale.observeF(new P<Float>() {
            @Override
            public void apply(final Float s) {
                {
                    CameraIsoMove.this._camera = new CameraIso(vec2.divF4(CameraIsoMove.this._currentBase.tilesOnScreen, ((float)(s))), CameraReserve.divF4(CameraIsoMove.this._currentBase.reserve, ((float)(s))), CameraIsoMove.this._currentBase.viewportRatio, CameraIsoMove.this._camera.center);
                    CameraIsoMove.this.changed.post();
                }
            }
        });
        this.center = Var.<vec2>limitedInitialLimits(this._camera.center, new F<vec2, vec2>() {
            @Override
            public vec2 apply(final vec2 cen) {
                if(CameraIsoMove.this.scale.value() <= 1) {
                    return CameraIsoMove.this._currentBase.naturalCenter();
                } else {
                    final vec2 centerP = vec4.xy(CameraIsoMove.this._currentBase.matrixModel.wcp().mulVec4(vec4.applyVec2ZW(cen, ((float)(0)), ((float)(1)))));
                    final vec2 cp = Rect.closestPointForVec2(CameraIsoMove.this.centerBounds(), centerP);
                    if(cp.equals(centerP)) {
                        return cen;
                    } else {
                        final mat4 mat4 = CameraIsoMove.this._currentBase.matrixModel.wcp().inverse();
                        final vec4 p0 = mat4.mulVec4(new vec4(cp.x, cp.y, ((float)(-1)), ((float)(1))));
                        final vec4 p1 = mat4.mulVec4(new vec4(cp.x, cp.y, ((float)(1)), ((float)(1))));
                        final Line3 line = new Line3(vec4.xyz(p0), vec3.subVec3(vec4.xyz(p1), vec4.xyz(p0)));
                        return vec3.xy(Line3.rPlane(line, new Plane(new vec3(((float)(0)), ((float)(0)), ((float)(0))), new vec3(((float)(0)), ((float)(0)), ((float)(1))))));
                    }
                }
            }
        });
        this.centerObs = this.center.observeF(new P<vec2>() {
            @Override
            public void apply(final vec2 cen) {
                {
                    CameraIsoMove.this._camera = new CameraIso(CameraIsoMove.this.camera().tilesOnScreen, CameraIsoMove.this.camera().reserve, CameraIsoMove.this.camera().viewportRatio, cen);
                    CameraIsoMove.this.changed.post();
                }
            }
        });
        this._startPan = new vec2(((float)(-1)), ((float)(-1)));
        this._startScale = 1.0;
        this._pinchLocation = new vec2(((float)(-1)), ((float)(-1)));
        this._startCenter = new vec2(((float)(-1)), ((float)(-1)));
        this.panEnabled = true;
        this.tapEnabled = true;
        this.pinchEnabled = true;
    }
    public String toString() {
        return String.format("CameraIsoMove(%s, %f, %f, %d, %d)", this.base, this.minScale, this.maxScale, this.panFingers, this.tapFingers);
    }
}