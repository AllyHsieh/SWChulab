clear;close all;clc;
addpath('.\correct_yaxis\');
addpath('.\time_corr\'); 
addpath('.\reslice\');
%--------------------------------------------------------------------------
%% sorting 3D
%M=readtable('D:\Yintzu\mouse.xls');

inputtiffdir='H:\Leo\240708\fast\'; %add one folder named "export", put data in "'E:\20240422\'"
outputmatdir='H:\Leo\240708\fast\'; %adTAGtestTAGtestd new folder name"4_4_128_128_1"
%o=[3,4,9];
%for n=1%6:8
    %{
     listing = dir(inputtiffdir);
     folder=char(string(listing(n).name));
     disp([folder,' start!'])
    %='2_2_64_128_pre';
    %folder=sprintf([folder,'%d'],n);
    %}
folder = 'trial5';
% define by your FOV rangea and tag samples
%folder='retry_10D';
    
    %repeat=2; %188k=2,94k=4;
     FOV =  "700*700_15%_mouse_0708";
        x_pixel = 128;
        y_pixel = 128;
        z_pixel = 265;
   
    %{
    if n<7
        FOV = "500*500";
        x_pixel = 128;
        y_pixel = 128;
        z_pixel =65;
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

folder_path = fullfile(inputtiffdir, folder);
T = struct2table(dir(fullfile(folder_path, '*.tiff')));
    S=string(table2cell(T(:,1)));
    dataname=zeros(length(S)-2,1);
    for f=1:size(S,1)
        % Remove the file extension
        [~, name, ~] = fileparts(S{f});
        % Use sscanf to extract integer from string and store in dataname
        dataname(f) = sscanf(name, '%d');
    end
    first=min(dataname);
    ALL_first = ceil(first/64).*64;
    lastone = max(dataname);
    last = floor(lastone/64).*64;

shift_pixel = 0;
updown_or_downup = "updown"; % updown or downup, which means the order of y-axis image take by galvo

% input/output dir name
s1 = [inputtiffdir,folder,'\'];  %input
s4 = [outputmatdir,folder,'\ch1_out']; %output
%mkdir(s4)
%save 4D stack
save_rawmat = 1; % if true save, else not save
% run
output_rawdata_filename = [outputmatdir,folder,'\export_out_sorting3Dok.mat'];
tic
sorting3D
toc
%}

%--------------------------------------------------------------------------
%% time correction
% run
tic
%xyzt_raw_data_timecorr = TAG_preprocessing(xyzt_raw_data);
%disp('timecorr')
 xyzt_raw_data_timecorr = xyzt_raw_data;
 disp('no timecorr')

toc

%--------------------------------------------------------------------------
%% reslice
% % reslice with actual DOF
% inputtiffdir='F:\alice\020524mouse\FASTSCAN\'; %add one folder named "export", put data in "'E:\20240422\'"
% outputmatdir='E:\Alice\020524 mouse SCN\25%'; %adTAGtestTAGtestd new folder name"4_4_128_128_1"
% %o=[3,4,9];
% %for n=1%6:8
%     %{
%      listing = dir(inputtiffdir);
%      folder=char(string(listing(n).name));
%      disp([folder,' start!'])
%     %='2_2_64_128_pre';
%     %folder=sprintf([folder,'%d'],n);
%     %}
% folder = 'mouse20%_zphy70um_timecorr';
% xyzt_raw_data_timecorr = xyzt_raw_data;
%
% save_type: how to process the data, "interpolate" or "mean"
% method: how to reslice, "z"(height) or "layer"
save_type = "interpolate";
method = "z";
z_physical_distance = 94; % um
% z-axis resample
if method == "z"
    N_z = 2; % N_z = z resolution
    z_axis_resample(method,N_z,z_physical_distance);
    interval=N_z;
elseif method == "layer"
    N_layer = 1; % "N_layer" layers turn into 1 stack.
    z_axis_resample(method,N_layer,z_physical_distance); %用不到z_physical_distance
    interval=N_layer;
end
% run
tic
xyzt_reslice_timecorr = reslice(xyzt_raw_data_timecorr,save_type);
toc
% save raw data
output_path = [outputmatdir,folder,'\']; %assign the output path
output_reslice_filename = convertStringsToChars(strcat(method,'_',num2str(interval),'_reslice'));
%zstack=xyzt_reslice_timecorr;
%%
newfolder=[output_path,output_reslice_filename,'\'];
mkdir(newfolder);
timeproj=mean(xyzt_reslice_timecorr(:,:,:,:),4);
save([newfolder,output_reslice_filename],'xyzt_reslice_timecorr','timeproj',"-v7.3")

%--------------------------------------------------------------------------
%% extract data from raw stack
% xyt: output x-y-t stack in ./ch1_out_xyt dir, using 1(save), 0(don't save)
% xyz: output x-y-z stack in ./ch1_out_xyz dir, using 1(save), 0(don't save)
xyt = 0;
xyz = 1;
% run
tic
extract_data_from_raw_stack(xyzt_reslice_timecorr,xyt,xyz,newfolder);
toc
disp("all done")
%end