clc
clear
close all

[C, A, b] = sdplib('sdplib/maxG11.dat-s');
sbm(C, A, b, 1e-5, 0.2, 1);