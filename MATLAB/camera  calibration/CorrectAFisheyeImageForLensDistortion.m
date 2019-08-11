%%  Correct Fisheye Image for Lens Distortion
%% Clear all
clc,clear,close all;

%% Gather a set of checkerboard calibration images.
images = imageDatastore('D:\NCNU\Viplad\report\matlab\camera  calibration\g30','FileExtensions','.jpg');

%%  Load Parameters 
load CameraParameters_2k.mat

%%  Remove lens distortion from the first image |I| and display the results.
mkdir('g100_ok');
for i=1:size(images.Files)
    I = readimage(images,i); 
    
    J1 = undistortFisheyeImage(I,params.Intrinsics,'OutputView','valid');
    %Save image
    image_name = strcat('g100_ok/',num2str(i));
    image_name = strcat(image_name,'.jpg');
    imwrite(J1,image_name);
end
%%