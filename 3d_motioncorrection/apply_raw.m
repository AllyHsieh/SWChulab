clc;clear;close all
[optimizer,metric] = imregconfig("multimodal");
path = "D:\110011566\research_pan\3d_motioncorrection\ch1_out_xyz";%raw data path
save_path = path+"_regist";
trace_mat_path = ".\trace.mat"

%%
load(trace_mat_path)

if ~isdir(save_path)
    mkdir(save_path)
end

A = dir(path);
z_slice_num = length(A)-3+1;

fixedVolume = tiffreadVolume(fullfile(path, "VOL_2.tiff"));
total_img = zeros([size(fixedVolume) z_slice_num]);
total_img(:,:,:,1) = fixedVolume;
mean_volume = double(fixedVolume);
%%
parfor i = 3:z_slice_num+1
    movingVolume = tiffreadVolume(fullfile(path, "VOL_"+num2str(i)+".tiff"));
    total_img(:,:,:,i-1) = movingVolume;
end

parfor f = 1:length(x_loc)
    T = [1,0,0,0;0,1,0,0;0,0,1,0;x_loc(f),y_loc(f),z_loc(f),1];
    tform = affine3d(T);
    movingVolume = total_img(:,:,:,f);
    movingVolume_crop = movingVolume(20:117,15:end,:);

    centerOutput = affineOutputView(size(fixedVolume),tform,'BoundsStyle','centerOutput');
    movingRegisteredVolume = imwarp(movingVolume,tform,"linear",'OutputView',centerOutput);
    disp(f)
%     mean_volume = mean_volume+movingRegisteredVolume;
    fTIF = Fast_BigTiff_Write(fullfile(save_path,"VOL_"+num2str(f+1)+"_regist.tiff"));
    fTIF.WriteIMG(uint16(movingRegisteredVolume(:,:,1)'));
    for z = 2:size(movingRegisteredVolume,3)
        temp_img = uint16(squeeze(movingRegisteredVolume(:,:,z)));
        fTIF.WriteIMG(temp_img');
    end
    fTIF.close;
end
