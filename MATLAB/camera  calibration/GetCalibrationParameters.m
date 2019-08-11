%%  Correct Fisheye Image for Lens Distortion
%% Clear all
clc,clear;

%% Gather a set of checkerboard calibration images.
images = imageDatastore('D:\NCNU\Viplad\report\matlab\camera  calibration\0\','FileExtensions','.jpg');

%%  Detect the calibration pattern from the images.
[imagePoints,boardSize,imagesUsed] = detectCheckerboardPoints(images.Files);

%% Plot the detected and reprojected points.
%{
figure 
poi=8;
I = readimage(images,poi); 
imshow(I);
hold on
plot(imagePoints(:,1,poi),imagePoints(:,2,poi),'go');
plot(params.ReprojectedPoints(:,1,poi),params.ReprojectedPoints(:,2,poi),'r+');
legend('Detected Points','Reprojected Points');
hold off
%}

%%  Generate world coordinates for the corners of the checkerboard squares.
squareSize = 26.5; % millimeters
worldPoints = generateCheckerboardPoints(boardSize,squareSize);

%% Estimate the fisheye camera calibration parameters based on the image and world points. 
%   Use the first image to get the image size.
I = readimage(images,1); 
imageSize = [size(I,1) size(I,2)];
params = estimateFisheyeParameters(imagePoints,worldPoints,imageSize);

%%  Save  Parameters 
save CameraParameters_2k_1 params

%%  Remove lens distortion from the first image |I| and display the results.
I = readimage(images,1); 
J1 = undistortFisheyeImage(I,params.Intrinsics,'OutputView','valid');
figure
imshow(J1)
imshowpair(I,J1,'montage')
title('Original Image (left) vs. Corrected Image (right)')

%%
J2 = undistortFisheyeImage(I,params.Intrinsics,'OutputView','full');
figure
imshow(J2)
imshowpair(J2,J1,'montage')
title('Full Output Viewvs. Corrected Image (right)')

