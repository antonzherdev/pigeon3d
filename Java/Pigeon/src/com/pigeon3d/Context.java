package com.pigeon3d;

import objd.lang.*;
import objd.react.Var;
import com.pigeon3d.geometry.vec2i;
import objd.react.React;
import com.pigeon3d.geometry.vec2;
import objd.collection.MHashMap;
import com.pigeon3d.geometry.RectI;
import com.pigeon3d.geometry.vec4;
import com.pigeon3d.gl.gl;

public class Context {
    public final Var<vec2i> viewSize;
    public final React<vec2> scaledViewSize;
    public boolean ttf;
    private final MHashMap<String, FileTexture> textureCache;
    private final MHashMap<String, Font> fontCache;
    public Environment environment;
    public final MatrixStack matrixStack;
    public RenderTarget renderTarget;
    public boolean considerShadows;
    public boolean redrawShadows;
    public boolean redrawFrame;
    private RectI _viewport;
    private int _lastTexture2D;
    private final MHashMap<Integer, Integer> _lastTextures;
    private int _lastShaderProgram;
    private int _lastRenderBuffer;
    private int _lastVertexBufferId;
    private int _lastVertexBufferCount;
    private int _lastIndexBuffer;
    private int _lastVertexArray;
    public int defaultVertexArray;
    private boolean _needBindDefaultVertexArray;
    public final CullFace cullFace;
    public final EnablingState blend;
    public final EnablingState depthTest;
    private vec4 _lastClearColor;
    private BlendFunction _blendFunction;
    private BlendFunction _blendFunctionComing;
    private boolean _blendFunctionChanged;
    public Texture textureForNameFileFormatFormatScaleFilter(final String name, final TextureFileFormat fileFormat, final TextureFormat format, final double scale, final TextureFilter filter) {
        return this.textureCache.applyKeyOrUpdateWith(name, new F0<FileTexture>() {
            @Override
            public FileTexture apply() {
                return new FileTexture(name, fileFormat, format, scale, filter);
            }
        });
    }
    public Font fontWithName(final String name) {
        return this.fontCache.applyKeyOrUpdateWith(name, new F0<Font>() {
            @Override
            public Font apply() {
                return new BMFont(name);
            }
        });
    }
    public Font mainFontWithSize(final int size) {
        return fontWithNameSize("Helvetica", size);
    }
    public Font fontWithNameSize(final String name, final int size) {
        final double scale = Director.current().scale();
        final String nm = String.format("%s %d", name, ((int)(size * scale)));
        if(this.ttf) {
            return this.fontCache.applyKeyOrUpdateWith(nm, new F0<Font>() {
                @Override
                public Font apply() {
                    return new TTFFont(name, ((int)(size * scale)));
                }
            });
        } else {
            return fontWithName(nm);
        }
    }
    public void clear() {
        this.matrixStack.clear();
        this.considerShadows = true;
        this.redrawShadows = true;
        this.redrawFrame = true;
    }
    public void clearCache() {
        this.textureCache.clear();
        this.fontCache.clear();
    }
    public RectI viewport() {
        return this._viewport;
    }
    public void setViewport(final RectI viewport) {
        if(!(this._viewport.equals(viewport))) {
            this._viewport = viewport;
            gl.egViewportRect(viewport);
        }
    }
    public void bindTextureTextureId(final int textureId) {
        if(this._lastTexture2D != textureId) {
            this._lastTexture2D = textureId;
            gl.glBindTextureHandle(gl.GL_TEXTURE_2D, textureId);
        }
    }
    public void bindTextureTexture(final Texture texture) {
        final int id = texture.id();
        if(this._lastTexture2D != id) {
            this._lastTexture2D = id;
            gl.glBindTextureHandle(gl.GL_TEXTURE_2D, id);
        }
    }
    public void bindTextureSlotTargetTexture(final int slot, final int target, final Texture texture) {
        final int id = texture.id();
        if(slot == gl.GL_TEXTURE0 && target == gl.GL_TEXTURE_2D) {
            if(this._lastTexture2D != id) {
                this._lastTexture2D = id;
                gl.glBindTextureHandle(target, id);
            }
        } else {
            final int key = slot * 13 + target;
            if(!(this._lastTextures.isValueEqualKeyValue(key, id))) {
                if(slot != gl.GL_TEXTURE0) {
                    gl.glActiveTexture(slot);
                    gl.glBindTextureHandle(target, id);
                    gl.glActiveTexture(gl.GL_TEXTURE0);
                } else {
                    gl.glBindTextureHandle(target, id);
                }
                this._lastTextures.setKeyValue(key, id);
            }
        }
    }
    public void deleteTextureId(final int id) {
        Director.current().onGLThreadF(new P0() {
            @Override
            public void apply() {
                gl.egDeleteTextureHandle(id);
                if(Context.this._lastTexture2D == id) {
                    Context.this._lastTexture2D = ((int)(0));
                }
                Context.this._lastTextures.clear();
            }
        });
    }
    public void bindShaderProgramProgram(final ShaderProgram program) {
        final int id = program.handle;
        if(id != this._lastShaderProgram) {
            this._lastShaderProgram = id;
            gl.glUseProgramProgram(id);
        }
    }
    public void deleteShaderProgramId(final int id) {
        gl.glDeleteProgramProgram(id);
        if(id == this._lastShaderProgram) {
            this._lastShaderProgram = ((int)(0));
        }
    }
    public void bindRenderBufferId(final int id) {
        if(id != this._lastRenderBuffer) {
            this._lastRenderBuffer = id;
            gl.glBindRenderbufferHandle(gl.GL_RENDERBUFFER, id);
        }
    }
    public void deleteRenderBufferId(final int id) {
        Director.current().onGLThreadF(new P0() {
            @Override
            public void apply() {
                gl.egDeleteRenderBufferHandle(id);
                if(id == Context.this._lastRenderBuffer) {
                    Context.this._lastRenderBuffer = ((int)(0));
                }
            }
        });
    }
    public void bindVertexBufferBuffer(final VertexBuffer<Object> buffer) {
        final int handle = buffer.handle();
        if(handle != this._lastVertexBufferId) {
            this.checkBindDefaultVertexArray();
            this._lastVertexBufferId = handle;
            this._lastVertexBufferCount = ((int)(buffer.count()));
            gl.glBindBufferTargetHandle(gl.GL_ARRAY_BUFFER, handle);
        }
    }
    public int vertexBufferCount() {
        return this._lastVertexBufferCount;
    }
    public void bindIndexBufferHandle(final int handle) {
        if(handle != this._lastIndexBuffer) {
            this.checkBindDefaultVertexArray();
            this._lastIndexBuffer = handle;
            gl.glBindBufferTargetHandle(gl.GL_ELEMENT_ARRAY_BUFFER, handle);
        }
    }
    public void deleteBufferId(final int id) {
        Director.current().onGLThreadF(new P0() {
            @Override
            public void apply() {
                gl.egDeleteBufferHandle(id);
                if(id == Context.this._lastVertexBufferId) {
                    Context.this._lastVertexBufferId = ((int)(0));
                    Context.this._lastVertexBufferCount = ((int)(0));
                }
                if(id == Context.this._lastIndexBuffer) {
                    Context.this._lastIndexBuffer = ((int)(0));
                }
            }
        });
    }
    public void bindVertexArrayHandleVertexCountMutable(final int handle, final int vertexCount, final boolean mutable) {
        if(handle != this._lastVertexArray || mutable) {
            this._lastVertexArray = handle;
            this._lastIndexBuffer = ((int)(0));
            gl.egBindVertexArrayHandle(handle);
        }
        this._needBindDefaultVertexArray = false;
        this._lastVertexBufferCount = vertexCount;
    }
    public void deleteVertexArrayId(final int id) {
        Director.current().onGLThreadF(new P0() {
            @Override
            public void apply() {
                gl.egDeleteVertexArrayHandle(id);
                if(id == Context.this._lastVertexArray) {
                    Context.this._lastVertexArray = ((int)(0));
                }
            }
        });
    }
    public void bindDefaultVertexArray() {
        this._needBindDefaultVertexArray = true;
    }
    public void checkBindDefaultVertexArray() {
        if(this._needBindDefaultVertexArray) {
            this._lastIndexBuffer = ((int)(0));
            this._lastVertexBufferCount = ((int)(0));
            this._lastVertexBufferId = ((int)(0));
            gl.egBindVertexArrayHandle(this.defaultVertexArray);
            this._needBindDefaultVertexArray = false;
        }
    }
    public void draw() {
        this.cullFace.draw();
        this.depthTest.draw();
        if(this._blendFunctionChanged) {
            if(this._blendFunctionComing == null) {
                throw new NullPointerException();
            }
            this._blendFunctionComing.bind();
            this._blendFunctionChanged = false;
            this._blendFunction = this._blendFunctionComing;
        }
        this.blend.draw();
    }
    public void clearColorColor(final vec4 color) {
        if(!(this._lastClearColor.equals(color))) {
            this._lastClearColor = color;
            gl.glClearColorRGBA(color.x, color.y, color.z, color.w);
        }
    }
    public BlendFunction blendFunction() {
        return this._blendFunction;
    }
    public void setBlendFunction(final BlendFunction blendFunction) {
        this._blendFunctionComing = blendFunction;
        this._blendFunctionChanged = this._blendFunction == null || !(this._blendFunction.equals(blendFunction));
    }
    public Context() {
        this.viewSize = Var.<vec2i>applyInitial(new vec2i(0, 0));
        this.scaledViewSize = this.viewSize.<vec2>mapF(new F<vec2i, vec2>() {
            @Override
            public vec2 apply(final vec2i _) {
                return vec2i.divF(_, Director.current().scale());
            }
        });
        this.ttf = true;
        this.textureCache = new MHashMap<String, FileTexture>();
        this.fontCache = new MHashMap<String, Font>();
        this.environment = Environment.aDefault;
        this.matrixStack = new MatrixStack();
        this.renderTarget = new SceneRenderTarget();
        this.considerShadows = true;
        this.redrawShadows = true;
        this.redrawFrame = true;
        this._viewport = RectI.applyXYWidthHeight(((float)(0)), ((float)(0)), ((float)(0)), ((float)(0)));
        this._lastTexture2D = ((int)(0));
        this._lastTextures = new MHashMap<Integer, Integer>();
        this._lastShaderProgram = ((int)(0));
        this._lastRenderBuffer = ((int)(0));
        this._lastVertexBufferId = ((int)(0));
        this._lastVertexBufferCount = ((int)(0));
        this._lastIndexBuffer = ((int)(0));
        this._lastVertexArray = ((int)(0));
        this.defaultVertexArray = ((int)(0));
        this._needBindDefaultVertexArray = false;
        this.cullFace = new CullFace();
        this.blend = new EnablingState(gl.GL_BLEND);
        this.depthTest = new EnablingState(gl.GL_DEPTH_TEST);
        this._lastClearColor = new vec4(((float)(0)), ((float)(0)), ((float)(0)), ((float)(0)));
        this._blendFunctionChanged = false;
    }
    public String toString() {
        return "Context";
    }
}