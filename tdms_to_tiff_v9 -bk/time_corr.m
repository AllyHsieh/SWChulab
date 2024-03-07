clear;close all;clc;
addpath('.\correct_yaxis\');
addpath('.\time_corr\'); 
addpath('.\reslice\');
%--------------------------------------------------------------------------
%% sorting 3D
%{
% ch1 folder start/final image name
ALL_first = 3116;
last = 4718;
% define by your FOV rangea and tag samples
FOV = "400*400";
x_pixel = 128;  
y_pixel = 128; 
z_pixel = 265; 
% reconstruct data
shift_pixel = 0;
updown_or_downup = "downup"; % updown or downup, which means the order of y-axis image take by galvo
% input/output dir name
s1 = 'D:\Yintzu\20221125\2_2_move_1\'; 
s4 = 'D:\Yintzu\20221125\2_2_move_1\ch1_out\'; 
%save 4D stack
save_rawmat = 1; % if true save, else not save
output_rawdata_filename = "D:\Yintzu\20221125\2_2_move_1\export_out.mat";
% run
sorting3D;
%}
%--------------------------------------------------------------------------
%% time correction
% run
load("D:\Lee\volume_image_data\20221115_29_5\analysis_report\2_4_v22_move_1\export_out.mat");
xyzt_raw_data_timecorr = TAG_preprocessing(xyzt_raw_data);
%--------------------------------------------------------------------------
%% reslice
% save_type: how to process the data, "interpolate" or "mean"
% method: how to reslice, "z"(height) or "layer"
save_type = "interpolate";
method = "z";
% z-axis resample
if method == "z"
    N_z = 2; % N_z = z resolution
    z_axis_resample(method,N_z);
elseif method == "layer"
    N_layer = 1; % "N_layer" layers turn into 1 stack.
    z_axis_resample(method,N_layer);
end
% run
xyzt_reslice_timecorr = reslice(xyzt_raw_data_timecorr,save_type);
% save raw data
output_path = "D:\Yintzu\mouse_exp\29-5\2_4_move_1\"; %assign the output path
output_reslice_filename = "reslice.mat";
save(output_path+output_reslice_filename,"xyzt_reslice_timecorr","-v7.3")
%--------------------------------------------------------------------------
%% extract data from raw stack
% xyt: output x-y-t stack in ./ch1_out_xyt dir, using 1(save), 0(don't save)
% xyz: output x-y-z stack in ./ch1_out_xyz dir, using 1(save), 0(don't save)
xyt = 1;
xyz = 1;
% run
extract_data_from_raw_stack(xyzt_reslice_timecorr,xyt,xyz,output_path);
disp("all done")
