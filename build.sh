#!/bin/sh
cd ./Sources/

ObjD --include ../ObjC/ObjDLib/Sources  --obj-c ../ObjC/Pigeon/Generated  --java ../Java/Pigeon/src --java-test ../Java/Pigeon/test
#ObjD --include ../ObjC/ObjDLib/Sources  --obj-c ../ObjC/Pigeon/Generated