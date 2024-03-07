clear;close all;clc;
addpath('.\correct_yaxis\');
addpath('.\time_corr\'); 
addpath('.\reslice\');
%--------------------------------------------------------------------------
%% sorting 3D
%M=readtable('D:\Yintzu\mouse.xls');

% ch1 folder start/final image name
%ALL_first = 1280 ;
%last = 10399;
inputtiffdir='D:\20230607\export\'; %add one folder named "export", put data in
outputmatdir='D:\20230607\'; %add new folder name"4_4_128_128_1"
for n=1
   % listing = dir('C:\b07 YinTzu\20230607');
   % folder=string(listing(n+2).name);
    %='2_2_64_128_pre';
    %folder=sprintf([folder,'%d'],n);
% define by your FOV rangea and tag samples
folder="94k";
    n
    repeat=4; %188k=2,94k=4;
     FOV = "500*500";
        x_pixel = 128;
        y_pixel = 128;
        z_pixel = 531;
    % mouse experiement parameter
    %{
    s1=table2cell(M(n,1));
    s2=table2cell(M(n,2));
    s3=table2cell(M(n,3));
    s4=table2cell(M(n,4));
    s1=num2str(reshape([s1{:}],size(s1)));
    s2=num2str(reshape([s2{:}],size(s2)));
    s3=char(s3);
    s4=char(s4);
    folder=[num2str(s1),'_',num2str(s2),'_',s3,'_',s4];
   %}
    %{
    if n<7
        FOV = "500*500";
        x_pixel = 128;
        y_pixel = 128;
        z_pixel = 265;
    elseif n>=7 && n<11
        FOV = "200*400";
        x_pixel = 64;
        y_pixel = 128;
        z_pixel = 265;
    elseif n>=11
        FOV = "200*200";
        x_pixel = 64;
        y_pixel = 64;
        z_pixel = 265;
    end
%}
% reconstruct 4D stack 
% ch1 folder start/final image name
%
    T=struct2table(dir([inputtiffdir,folder]));
    S=string(table2cell(T(:,1)));
    dataname=zeros(length(S)-2,1);
    for f=3:size(S,1)
        dataname(f-2) = sscanf(S(f),'%d');
    end
    first=min(dataname);
    ALL_first = ceil(first/64).*64;
    lastone = max(dataname);
    last = floor(lastone/64).*64;

shift_pixel = 0;
updown_or_downup = "downup"; % updown or downup, which means the order of y-axis image take by galvo

% input/output dir name
s1 = [inputtiffdir,folder,'\'];  %input
s4 = [outputmatdir,folder,'\ch1_out\']; %output
%save 4D stack
save_rawmat = 1; % if true save, else not save
% run
output_rawdata_filename = [outputmatdir,folder,'\export_out.mat'];
tic
sorting3D_94k;
toc
%}

% 4D stack already finish
%{
path='D:\Lee\volume_image_data\20221109_29_4\analysis_report\';
load([path,folder,'\export_out.mat']);
%}
%--------------------------------------------------------------------------
%% time correction
% run
tic
xyzt_raw_data_timecorr = TAG_preprocessing(xyzt_raw_data);
toc
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
tic
xyzt_reslice_timecorr = reslice(xyzt_raw_data_timecorr,save_type);
toc
% save raw data
output_path = [outputmatdir,folder,'\']; %assign the output path
output_reslice_filename = 'reslice';
save([output_path,output_reslice_filename],'xyzt_reslice_timecorr',"-v7.3")
%--------------------------------------------------------------------------
%% extract data from raw stack
% xyt: output x-y-t stack in ./ch1_out_xyt dir, using 1(save), 0(don't save)
% xyz: output x-y-z stack in ./ch1_out_xyz dir, using 1(save), 0(don't save)
xyt = 1;
xyz = 1;
% run
extract_data_from_raw_stack(xyzt_reslice_timecorr,xyt,xyz,output_path);
disp("all done")
end