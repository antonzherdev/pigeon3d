package com.pigeon3d;

import objd.lang.*;

public interface Camera {
    int cullFace();
    MatrixModel matrixModel();
    double viewportRatio();
    String toString();
}