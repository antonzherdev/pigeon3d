#if TARGET_OS_IPHONE
#import <OpenGLES/EAGL.h>
#elif TARGET_OS_MAC
#import <OpenGL/gl3.h>
#endif
#import "PGVec.h"
#import "PGPlatform.h"
#ifndef GL_RGBA8_OES
#define GL_RGBA8_OES GL_RGBA
#endif

@class PGMat4;


static inline void egViewport(PGRectI rect) {
    glViewport((GLint)rect.p.x, (GLint)rect.p.y, (GLsizei)rect.size.x, (GLsizei)rect.size.y);
}


static inline void egUniformVec4(GLuint location, PGVec4 color ) {
    glUniform4f(location, (GLfloat) color.x, (GLfloat) color.y, (GLfloat) color.z, (GLfloat) color.w);
}
static inline void egUniformVec3(GLuint location, PGVec3 vec3 ) {
    glUniform3f(location, (GLfloat) vec3.x, (GLfloat) vec3.y, (GLfloat) vec3.z);
}
static inline void egUniformVec2(GLuint location, PGVec2 vec2 ) {
    glUniform2f(location, (GLfloat) vec2.x, (GLfloat) vec2.y);
}

NSString* egGetProgramError(GLuint program);
void egShaderSource(GLuint shader, NSString* source);
NSString* egGetShaderError(GLuint shader);

static inline BOOL GLuintEq(GLuint a, GLuint b) {
    return a == b;
}

static inline NSUInteger GLuintHash(GLuint x) {
    return x;
}

static inline NSString *GLuintDescription(GLuint x) {
    return [NSString stringWithFormat:@"%d", x];
}

static inline BOOL GLintEq(GLint a, GLint b) {
    return a == b;
}

static inline NSUInteger GLintHash(GLint x) {
    return (NSUInteger) x;
}

static inline NSString *GLintDescription(GLint x) {
    return [NSString stringWithFormat:@"%d", x];
}

static inline BOOL GLenumEq(GLenum a, GLenum b) {
    return a == b;
}

static inline NSUInteger GLenumHash(GLenum x) {
    return x;
}

static inline NSString *GLenumDescription(GLenum x) {
    return [NSString stringWithFormat:@"%d", x];
}

static inline GLuint egGenBuffer() {
    GLuint buffer;
    glGenBuffers(1, &buffer);
    return buffer;
}

static inline void egDeleteBuffer(GLuint handle) {
    glDeleteBuffers(1, &handle);
}

static inline GLuint egGenVertexArray() {
#if TARGET_OS_IPHONE
    GLuint buffer;
    glGenVertexArraysOES(1, &buffer);
    return buffer;
#else
    GLuint buffer;
    glGenVertexArrays(1, &buffer);
    return buffer;
#endif
}

static inline void egDeleteVertexArray(GLuint handle) {
#if TARGET_OS_IPHONE
    glDeleteVertexArraysOES(1, &handle);
#else
    glDeleteVertexArrays(1, &handle);
#endif
}


static inline void egBindVertexArray(GLuint handle) {
#if TARGET_OS_IPHONE
    glBindVertexArrayOES(handle);
#else
    glBindVertexArray(handle);
#endif
}

static inline GLuint egGenFrameBuffer() {
    GLuint buffer;
    glGenFramebuffers(1, &buffer);
    return buffer;
}


static inline void egDeleteFrameBuffer(GLuint handle) {
    glDeleteFramebuffers(1, &handle);
}

static inline GLuint egGenRenderBuffer() {
    GLuint buffer;
    glGenRenderbuffers(1, &buffer);
    return buffer;
}


static inline void egDeleteRenderBuffer(GLuint handle) {
    glDeleteRenderbuffers(1, &handle);
}

static inline GLuint egGenTexture() {
    GLuint buffer;
    glGenTextures(1, &buffer);
    return buffer;
}

static inline void egDeleteTexture(GLuint handle) {
    glDeleteTextures(1, &handle);
}

static inline GLint egGetAttribLocation(GLuint program, NSString* name) {
    return glGetAttribLocation(program, [name cStringUsingEncoding:NSUTF8StringEncoding]);
}

static inline GLint egGetUniformLocation(GLuint program, NSString* name) {
    return glGetUniformLocation(program, [name cStringUsingEncoding:NSUTF8StringEncoding]);
}

static inline void egVertexAttribPointer (GLuint index, NSUInteger size, GLenum type, GLboolean normalized, NSUInteger stride, NSUInteger pointer) {
    glVertexAttribPointer(index, (GLint)size, type, normalized, (GLsizei)stride, (GLvoid const *) pointer);
}


#define egJasVbo(NAME) [arrsv(PGMeshData, NAME ## _vertexcount) NAME ## _vertex]
#define egJasIbo(NAME) [arrp(unsigned int, numui4, NAME ## _polygoncount*3) NAME ## _index]

#define egJasModel(NAME) [PGMesh \
    applyVertexData:egJasVbo(NAME) \
    indexData: egJasIbo(NAME)]

#define egMeshDataModel(NAME) [PGMeshDataModel \
    meshDataModelWithVertex:egJasVbo(NAME) \
    index: egJasIbo(NAME)]


void egFlush();

static inline void egFramebufferTexture(GLenum target, GLenum attachment, GLuint texture, GLint level) {
#if TARGET_OS_IPHONE
    glFramebufferTexture2D(target, attachment, GL_TEXTURE_2D, texture, level);
#elif TARGET_OS_MAC
    glFramebufferTexture(target, attachment, texture, level);
#endif
}


NSUInteger egGLSLVersion();


static inline void egLabelShaderProgram(GLuint handle, NSString* name) {
#if DEBUG
#if TARGET_OS_IPHONE
    glLabelObjectEXT(GL_PROGRAM_OBJECT_EXT, handle, 0, [name cStringUsingEncoding:NSUTF8StringEncoding]);
#endif
#endif
}

static inline void egPushGroupMarker(NSString* name) {
#if DEBUG
#if TARGET_OS_IPHONE
    glPushGroupMarkerEXT(0, [name cStringUsingEncoding:NSUTF8StringEncoding]);
#endif
#endif
}

static inline void egPopGroupMarker() {
#if DEBUG
#if TARGET_OS_IPHONE
    glPopGroupMarkerEXT();
#endif
#endif
}


static inline void egCheckError() {
#if DEBUG
    GLenum err = glGetError();
    if(err != GL_NO_ERROR) {
        @throw [NSString stringWithFormat:@"OpenGL error: %i", err];
    }
#endif    
}


static inline GLvoid * egMapBuffer(GLenum target, GLenum access) {
#if TARGET_OS_IPHONE
    return glMapBufferOES(target, access);
#else
    return glMapBuffer(target, access);
#endif
}

static inline BOOL egUnmapBuffer(GLenum target) {
#if TARGET_OS_IPHONE
    return glUnmapBufferOES(target);
#else
    return glUnmapBuffer(target);
#endif
}

#if TARGET_OS_IPHONE
#define GL_WRITE_ONLY GL_WRITE_ONLY_OES
#define GL_READ_ONLY GL_READ_ONLY_OES
#define GL_READ_WRITE GL_READ_WRITE_OES
#endif