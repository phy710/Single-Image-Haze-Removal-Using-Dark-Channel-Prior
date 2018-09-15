% Single Image Haze Removal Using Dark Channel Prior
% Algorithm author: Kaiming He, Jian Sun, and Xiaoou Tang
% MATLAB code author: Zephyr
% Date: 03/28/2018
clear;
close all;
clc;
img = imread('traffic.jpg');
img = double(img) / 255;
figure;
imshow(img);
title('Origial Image');
[dehazedImg, darkChannel, transmission] = dehaze(img);
figure;
imshow(darkChannel);
title('Dark Channel');
figure;
imshow(transmission);
title('Transmission Map');
figure;
imshow(dehazedImg);
title('Dehazed Image');