#!/bin/bash

make clean
make
./exe/mnist_cpu_base -a f --train-data-size 500 --test-data-size 100