package com.pigeon3d.geometry;

import objd.lang.*;
import objd.collection.ImArray;

public interface Figure {
    Rect boundingRect();
    ImArray<LineSegment> segments();
    String toString();
}