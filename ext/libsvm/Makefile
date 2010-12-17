CXX ?= g++
CFLAGS = -Wall -Wconversion -O3 -fPIC
SHVER = 2

all: clean svm-train svm-predict svm-scale

lib: svm.o
	$(CXX) -shared -dynamiclib svm.o -o libsvm.so.$(SHVER)

svm-predict: svm-predict.c svm.o
	$(CXX) $(CFLAGS) svm-predict.c svm.o -o eluka-svm-predict -lm
svm-train: svm-train.c svm.o
	$(CXX) $(CFLAGS) svm-train.c svm.o -o eluka-svm-train -lm
svm-scale: svm-scale.c
	$(CXX) $(CFLAGS) svm-scale.c -o eluka-svm-scale
svm.o: svm.cpp svm.h
	$(CXX) $(CFLAGS) -c svm.cpp
clean:
	rm -f *~ svm.o eluka-svm-train eluka-svm-predict eluka-svm-scale libsvm.so.$(SHVER)

install:
	mkdir -p ../../bin
	cp eluka-svm-train ../../bin
	cp eluka-svm-predict ../../bin
	cp eluka-svm-scale ../../bin
