package com.pigeon3d;

import objd.lang.*;
import com.pigeon3d.geometry.vec2i;
import com.pigeon3d.geometry.RectI;
import objd.collection.ImArray;
import com.pigeon3d.geometry.vec2;
import objd.chain.Chain;
import objd.collection.Range;
import objd.collection.Traversable;

public class MapSso {
    public static final double ISO;
    public final vec2i size;
    public final RectI limits;
    public final ImArray<vec2i> fullTiles;
    public final ImArray<vec2i> partialTiles;
    public final ImArray<vec2i> allTiles;
    public boolean isFullTile(final vec2i tile) {
        return tile.y + tile.x >= 0 && tile.y - tile.x <= this.size.y - 1 && tile.y + tile.x <= this.size.x + this.size.y - 2 && tile.y - tile.x >= -(this.size.x) + 1;
    }
    public boolean isPartialTile(final vec2i tile) {
        return tile.y + tile.x >= -1 && tile.y - tile.x <= this.size.y && tile.y + tile.x <= this.size.x + this.size.y - 1 && tile.y - tile.x >= -(this.size.x) && (tile.y + tile.x == -1 || tile.y - tile.x == this.size.y || tile.y + tile.x == this.size.x + this.size.y - 1 || tile.y - tile.x == -(this.size.x));
    }
    public boolean isLeftTile(final vec2i tile) {
        return tile.y + tile.x == -1;
    }
    public boolean isTopTile(final vec2i tile) {
        return tile.y - tile.x == this.size.y;
    }
    public boolean isRightTile(final vec2i tile) {
        return tile.y + tile.x == this.size.x + this.size.y - 1;
    }
    public boolean isBottomTile(final vec2i tile) {
        return tile.y - tile.x == -(this.size.x);
    }
    public boolean isVisibleTile(final vec2i tile) {
        return tile.y + tile.x >= -1 && tile.y - tile.x <= this.size.y && tile.y + tile.x <= this.size.x + this.size.y - 1 && tile.y - tile.x >= -(this.size.x);
    }
    public boolean isVisibleVec2(final vec2 vec2) {
        return vec2.y + vec2.x >= -1 && vec2.y - vec2.x <= this.size.y && vec2.y + vec2.x <= this.size.x + this.size.y - 1 && vec2.y - vec2.x >= -(this.size.x);
    }
    public vec2 distanceToMapVec2(final vec2 vec2) {
        return new vec2(((vec2.y + vec2.x < -1) ? (vec2.y + vec2.x + 1) : (((vec2.y + vec2.x > this.size.x + this.size.y - 1) ? ((vec2.y + vec2.x - this.size.x) - this.size.y + 1) : (((float)(0)))))), ((vec2.y - vec2.x > this.size.y) ? ((vec2.y - vec2.x) - this.size.y) : (((vec2.y - vec2.x < -(this.size.x)) ? (vec2.y - vec2.x + this.size.x) : (((float)(0)))))));
    }
    private Chain<vec2i> allPosibleTiles() {
        return new Range(RectI.x(this.limits), RectI.x2(this.limits), 1).chain().<Integer>mulBy(((Traversable<Integer>)(((Traversable)(new Range(RectI.y(this.limits), RectI.y2(this.limits), 1)))))).<vec2i>mapF(new F<Tuple<Integer, Integer>, vec2i>() {
            @Override
            public vec2i apply(final Tuple<Integer, Integer> _) {
                return new vec2i(_.a, _.b);
            }
        });
    }
    private int tileCutAxisLessMore(final int less, final int more) {
        if(less == more) {
            return 1;
        } else {
            if(less < more) {
                return 0;
            } else {
                return 2;
            }
        }
    }
    public MapTileCutState cutStateForTile(final vec2i tile) {
        return new MapTileCutState(tileCutAxisLessMore(0, tile.x + tile.y), tileCutAxisLessMore(tile.y - tile.x, this.size.y - 1), tileCutAxisLessMore(tile.x + tile.y, this.size.x + this.size.y - 2), tileCutAxisLessMore(-(this.size.x) + 1, tile.y - tile.x));
    }
    public MapSso(final vec2i size) {
        this.size = size;
        this.limits = vec2i.rectToVec2i(new vec2i((1 - size.y) / 2 - 1, (1 - size.x) / 2 - 1), new vec2i((2 * size.x + size.y - 3) / 2 + 1, (size.x + 2 * size.y - 3) / 2 + 1));
        this.fullTiles = this.allPosibleTiles().filterWhen(new F<vec2i, Boolean>() {
            @Override
            public Boolean apply(final vec2i _) {
                return isFullTile(_);
            }
        }).toArray();
        this.partialTiles = this.allPosibleTiles().filterWhen(new F<vec2i, Boolean>() {
            @Override
            public Boolean apply(final vec2i _) {
                return isPartialTile(_);
            }
        }).toArray();
        this.allTiles = this.fullTiles.addSeq(this.partialTiles);
    }
    public String toString() {
        return String.format("MapSso(%s)", this.size);
    }
    static {
        ISO = 0.70710678118655;
    }
}