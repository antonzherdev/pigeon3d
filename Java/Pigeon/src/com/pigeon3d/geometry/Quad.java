package com.pigeon3d.geometry;

import objd.lang.*;
import objd.collection.ImArray;

public class Quad {
    public static final Quad identity;
    public final vec2 p0;
    public final vec2 p1;
    public final vec2 p2;
    public final vec2 p3;
    public static Quad applySize(final float size) {
        return new Quad(new vec2(-(size), -(size)), new vec2(size, -(size)), new vec2(size, size), new vec2(-(size), size));
    }
    public Quad addVec2(final vec2 vec2) {
        return new Quad(vec2.addVec2(this.p0, vec2), vec2.addVec2(this.p1, vec2), vec2.addVec2(this.p2, vec2), vec2.addVec2(this.p3, vec2));
    }
    public Quad addXY(final float x, final float y) {
        return addVec2(new vec2(x, y));
    }
    public Quad mulValue(final float value) {
        return new Quad(vec2.mulF4(this.p0, value), vec2.mulF4(this.p1, value), vec2.mulF4(this.p2, value), vec2.mulF4(this.p3, value));
    }
    public Quad mulMat3(final Mat3 mat3) {
        return new Quad(mat3.mulVec2(this.p0), mat3.mulVec2(this.p1), mat3.mulVec2(this.p2), mat3.mulVec2(this.p3));
    }
    public Quadrant quadrant() {
        final float x = (this.p1.x - this.p0.x) / 2;
        final float y = (this.p3.y - this.p0.y) / 2;
        final Quad q = Quad.addVec2(mulValue(((float)(0.5))), this.p0);
        return new Quadrant(((Quad[4])(ImArray.fromObjects(q, Quad.addXY(q, x, ((float)(0))), Quad.addXY(q, x, y), Quad.addXY(q, ((float)(0)), y)))));
    }
    public vec2 applyIndex(final int index) {
        if(index == 0) {
            return this.p0;
        } else {
            if(index == 1) {
                return this.p1;
            } else {
                if(index == 2) {
                    return this.p2;
                } else {
                    if(index == 3) {
                        return this.p3;
                    } else {
                        throw new RuntimeException("Incorrect quad index");
                    }
                }
            }
        }
    }
    public Rect boundingRect() {
        double minX = Float.max;
        double maxX = Float.min;
        double minY = Float.max;
        double maxY = Float.min;
        int i = 0;
        while(i < 4) {
            final vec2 pp = applyIndex(((int)(i)));
            if(pp.x < minX) {
                minX = ((double)(pp.x));
            }
            if(pp.x > maxX) {
                maxX = ((double)(pp.x));
            }
            if(pp.y < minY) {
                minY = ((double)(pp.y));
            }
            if(pp.y > maxY) {
                maxY = ((double)(pp.y));
            }
            i++;
        }
        return vec2.rectToVec2(new vec2(((float)(minX)), ((float)(minY))), new vec2(((float)(maxX)), ((float)(maxY))));
    }
    public ImArray<Line2> lines() {
        return ImArray.fromObjects(Line2.applyP0P1(this.p0, this.p1), Line2.applyP0P1(this.p1, this.p2), Line2.applyP0P1(this.p2, this.p3), Line2.applyP0P1(this.p3, this.p0));
    }
    public ImArray<vec2> ps() {
        return ImArray.fromObjects(this.p0, this.p1, this.p2, this.p3);
    }
    public vec2 closestPointForVec2(final vec2 vec2) {
        if(containsVec2(vec2)) {
            return vec2;
        } else {
            ImArray<vec2> projs = Quad.lines(this).chain().<vec2>mapOptF(((F<Line2, vec2>)(((F)(new F<Line2, vec2>() {
                @Override
                public vec2 apply(final Line2 _) {
                    return Line2.projectionOnSegmentVec2(_, vec2);
                }
            }))))).toArray();
            if(projs.isEmpty()) {
                projs = Quad.ps(this);
            }
            {
                final vec2 __tmp_0f_2 = projs.chain().sortBy().<Float>ascBy(new F<vec2, Float>() {
                    @Override
                    public Float apply(final vec2 _) {
                        return vec2.lengthSquare(vec2.subVec2(_, vec2));
                    }
                }).endSort().head();
                if(__tmp_0f_2 != null) {
                    return __tmp_0f_2;
                } else {
                    return this.p0;
                }
            }
        }
    }
    public boolean containsVec2(final vec2 vec2) {
        return Rect.containsVec2(Quad.boundingRect(this), vec2) && (Triangle.containsVec2(new Triangle(this.p0, this.p1, this.p2), vec2) || Triangle.containsVec2(new Triangle(this.p2, this.p3, this.p0), vec2));
    }
    public Quad mapF(final F<vec2, vec2> f) {
        return new Quad(f.apply(this.p0), f.apply(this.p1), f.apply(this.p2), f.apply(this.p3));
    }
    public vec2 center() {
        final vec2 __tmp;
        {
            final vec2 __tmp_e1 = Line2.crossPointLine2(Line2.applyP0P1(this.p0, this.p2), Line2.applyP0P1(this.p1, this.p3));
            if(__tmp_e1 != null) {
                __tmp = __tmp_e1;
            } else {
                __tmp = Line2.crossPointLine2(Line2.applyP0P1(this.p0, this.p1), Line2.applyP0P1(this.p2, this.p3));
            }
        }
        if(__tmp != null) {
            return __tmp;
        } else {
            return this.p0;
        }
    }
    public Quad(final vec2 p0, final vec2 p1, final vec2 p2, final vec2 p3) {
        this.p0 = p0;
        this.p1 = p1;
        this.p2 = p2;
        this.p3 = p3;
    }
    public String toString() {
        return String.format("Quad(%s, %s, %s, %s)", this.p0, this.p1, this.p2, this.p3);
    }
    public boolean equals(final Quad to) {
        return this.p0.equals(to.p0) && this.p1.equals(to.p1) && this.p2.equals(to.p2) && this.p3.equals(to.p3);
    }
    public int hashCode() {
        int hash = 0;
        hash = hash * 31 + vec2.hashCode(this.p0);
        hash = hash * 31 + vec2.hashCode(this.p1);
        hash = hash * 31 + vec2.hashCode(this.p2);
        hash = hash * 31 + vec2.hashCode(this.p3);
        return hash;
    }
    static {
        identity = new Quad(new vec2(((float)(0)), ((float)(0))), new vec2(((float)(1)), ((float)(0))), new vec2(((float)(1)), ((float)(1))), new vec2(((float)(0)), ((float)(1))));
    }
}