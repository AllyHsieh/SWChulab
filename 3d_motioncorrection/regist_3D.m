clc;clear;close all
[optimizer,metric] = imregconfig("multimodal");
path = "D:\110011566\research_pan\3d_motioncorrection\xyz_denoise";
suffix = "f_E_10_Iter_0785_output"; %依照.tif前面的後墜填入

%%
save_path = path+"_registed";
if ~isdir(save_path)
    mkdir(save_path)
end

fixedVolume = tiffreadVolume(fullfile(path, "VOL_2"+suffix+".tif"));

fTIF = Fast_BigTiff_Write(fullfile(save_path,"VOL_2_regist.tif"));
fTIF.WriteIMG(fixedVolume(:,:,1)');
for z = 2:size(fixedVolume,3)
    temp_img = uint16(squeeze(fixedVolume(:,:,z)));
    fTIF.WriteIMG(temp_img');
end
fTIF.close;
x_loc = [0];
y_loc = [0];
z_loc = [0];
parfor i = 3:length(dir("D:\110011566\research_pan\3d_motioncorrection\xyz_denoise"))-1
    movingVolume = tiffreadVolume(fullfile(path, "VOL_"+num2str(i)+suffix+".tif"));
    tform = imregtform(movingVolume,fixedVolume,"translation",optimizer,metric);

    centerOutput = affineOutputView(size(fixedVolume),tform,'BoundsStyle','centerOutput');
    movingRegisteredVolume = imwarp(movingVolume,tform,"bicubic",'OutputView',centerOutput);
    [temp_x,temp_y,temp_z] = transformPointsForward(tform, 0,0,0);
    x_loc = [x_loc temp_x];
    y_loc = [y_loc temp_y];
    z_loc = [z_loc temp_z];
    disp(i+"   "+temp_z)
%     mean_volume = mean_volume+movingRegisteredVolume;
    fTIF = Fast_BigTiff_Write(fullfile(save_path,"VOL_"+num2str(i)+"_regist.tif"));
    fTIF.WriteIMG(movingRegisteredVolume(:,:,1)');
    for z = 2:size(movingRegisteredVolume,3)
        temp_img = uint16(squeeze(movingRegisteredVolume(:,:,z)));
        fTIF.WriteIMG(temp_img');
    end
    fTIF.close;
end

save('trace.mat',"x_loc", "y_loc","z_loc");
%%
figure
subplot(3,1,1)
plot(x_loc)
ylim([-2 2])
title("x location")
ylabel("pixel")
subplot(3,1,2)
plot(y_loc)
ylim([-2 2])
title("y location")
ylabel("pixel")
subplot(3,1,3)
plot(z_loc)
ylim([-2 2])
title("z location")
ylabel("pixel")
xlabel("frame")
%%
x_loc_filt = medfilt1(x_loc,11);
y_loc_filt = medfilt1(y_loc,11);
z_loc_filt = medfilt1(z_loc,11);

figure
subplot(3,1,1)
plot(x_loc)
hold on
plot(x_loc_filt)
ylim([-2 2])
title("x location")
ylabel("pixel")
subplot(3,1,2)
plot(y_loc)
hold on
plot(y_loc_filt)
ylim([-2 2])
title("y location")
ylabel("pixel")
subplot(3,1,3)
plot(z_loc)
hold on
plot(z_loc_filt)
ylim([-2 2])
title("z location")
ylabel("pixel")
xlabel("frame")

