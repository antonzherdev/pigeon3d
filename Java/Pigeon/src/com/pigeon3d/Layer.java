package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.RectI;
import objd.collection.Iterator;
import android.opengl.GLES20;
import com.pigeon3d.gl.eg;
import com.pigeon3d.geometry.Rect;
import com.pigeon3d.geometry.vec2;
import objd.collection.ImArray;

public class Layer extends Updatable_impl {
    public final LayerView view;
    public final InputProcessor inputProcessor;
    private final boolean iOS6;
    private final RecognizersState recognizerState;
    public static Layer applyView(final LayerView view) {
        return new Layer(view, Util.<InputProcessor>as(InputProcessor.class, view));
    }
    public void prepareWithViewport(final Rect viewport) {
        final Environment env = this.view.environment();
        Global.context.environment = env;
        final Camera camera = this.view.camera();
        final int cullFace = camera.cullFace();
        Global.context.cullFace.setValue(((int)(cullFace)));
        Global.context.renderTarget = new SceneRenderTarget();
        Global.context.setViewport(RectI.applyRect(viewport));
        Global.matrix.setValue(camera.matrixModel());
        this.view.prepare();
        if(platform.egPlatform().shadows) {
            {
                final Iterator<Light> __il__11t_0i = env.lights.iterator();
                while(__il__11t_0i.hasNext()) {
                    final Light light = __il__11t_0i.next();
                    if(light.hasShadows) {
                        {
                            final CullFace __tmp__il__11t_0rt_1self = Global.context.cullFace;
                            {
                                final int __il__11t_0rt_1oldValue = __tmp__il__11t_0rt_1self.invert();
                                drawShadowForCameraLight(camera, light);
                                if(__il__11t_0rt_1oldValue != GLES20.GL_NONE) {
                                    __tmp__il__11t_0rt_1self.setValue(__il__11t_0rt_1oldValue);
                                }
                            }
                        }
                    }
                }
            }
            if(this.iOS6) {
                GLES20.glFinish();
            }
        }
        eg.egCheckError();
    }
    public void reshapeWithViewport(final Rect viewport) {
        Global.context.setViewport(RectI.applyRect(viewport));
        this.view.reshapeWithViewport(viewport);
    }
    public void drawWithViewport(final Rect viewport) {
        final Environment env = this.view.environment();
        Global.context.environment = env;
        final Camera camera = this.view.camera();
        Global.context.cullFace.setValue(((int)(camera.cullFace())));
        Global.context.renderTarget = new SceneRenderTarget();
        Global.context.setViewport(RectI.applyRect(viewport));
        Global.matrix.setValue(camera.matrixModel());
        this.view.draw();
        eg.egCheckError();
    }
    public void completeWithViewport(final Rect viewport) {
        this.view.complete();
    }
    public void drawShadowForCameraLight(final Camera camera, final Light light) {
        Global.context.renderTarget = new ShadowRenderTarget(light);
        Global.matrix.setValue(light.shadowMatrixModel(camera.matrixModel()));
        light.shadowMap().biasDepthCp = ShadowMap.biasMatrix.mulMatrix(Global.matrix.value().cp());
        if(Global.context.redrawShadows) {
            {
                final ShadowMap __tmp__il__3t_0self = light.shadowMap();
                {
                    __tmp__il__3t_0self.bind();
                    {
                        GLES20.glClear(GLES20.GL_DEPTH_BUFFER_BIT);
                        this.view.draw();
                    }
                    __tmp__il__3t_0self.unbind();
                }
            }
        }
        eg.egCheckError();
    }
    public <P> boolean processEventViewport(final Event<P> event, final Rect viewport) {
        if(this.inputProcessor == null) {
            throw new NullPointerException();
        }
        if(((this.inputProcessor != null) ? (this.inputProcessor.isProcessorActive()) : (false))) {
            final Camera camera = this.view.camera();
            Global.matrix.setValue(camera.matrixModel());
            return this.recognizerState.<P>processEvent(new CameraEvent<P>(event, camera.matrixModel(), viewport));
        } else {
            return false;
        }
    }
    @Override
    public void updateWithDelta(final double delta) {
        this.view.updateWithDelta(delta);
    }
    public static Rect viewportWithViewSizeViewportLayoutViewportRatio(final vec2 viewSize, final Rect viewportLayout, final float viewportRatio) {
        final vec2 size = vec2.mulVec2(viewSize, viewportLayout.size);
        final vec2 vpSize = ((size.x == 0 && size.y == 0) ? (new vec2(viewSize.x, viewSize.y)) : (((size.x == 0) ? (new vec2(viewSize.x, size.y)) : (((size.y == 0) ? (new vec2(size.x, viewSize.y)) : (((size.x / size.y < viewportRatio) ? (new vec2(size.x, size.x / viewportRatio)) : (new vec2(size.y * viewportRatio, size.y)))))))));
        final vec2 po = vec2.addF(vec2.divI(viewportLayout.p, 2), 0.5);
        return new Rect(vec2.mulVec2(vec2.subVec2(viewSize, vpSize), po), vpSize);
    }
    public Layer(final LayerView view, final InputProcessor inputProcessor) {
        this.view = view;
        this.inputProcessor = inputProcessor;
        this.iOS6 = platform.egPlatform().os.isIOSLessVersion("7");
        this.recognizerState = new RecognizersState(((inputProcessor != null) ? (inputProcessor.recognizers()) : (new Recognizers(ImArray.<Recognizer<Object>>empty()))));
    }
    public String toString() {
        return String.format("Layer(%s, %s)", this.view, this.inputProcessor);
    }
}