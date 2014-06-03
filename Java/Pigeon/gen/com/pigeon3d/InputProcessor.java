package com.pigeon3d;

import objd.lang.*;

public interface InputProcessor {
    boolean isProcessorActive();
    Recognizers recognizers();
    String toString();
}