clc;clear;close all
path = ".";
output_index_name = "test_psnr_corr_29_4_2_4_move4_v2_v4.mat";
raw_path = fullfile(path,"xyz_raw_regist");
denoise_path = fullfile(path,"xyz_denoise_regist");
RA = tiffreadVolume(fullfile(path, "29_4_2_4_slowscan.tiff"));
RA = RA(53:427,:,:);
suffix = "_regist.tiff";

%%
RA = imresize(RA,1/4,"nearest");
rescale_RA = rescale(RA);


%53 427


A = dir(raw_path);
baseline_time = 24*20;

z_slice_num = length(A)-3+1;
temp_raw_1 = tiffreadVolume(fullfile(raw_path,"VOL_"+2+suffix));
denoise_4d = zeros(size(temp_raw_1,1),size(temp_raw_1,2),size(temp_raw_1,3),baseline_time);
raw_4d = zeros(size(temp_raw_1,1),size(temp_raw_1,2),size(temp_raw_1,3),baseline_time);



%% process 4D raw to movemean
for zz = 1:baseline_time
    index = zz+1;
    temp_raw = tiffreadVolume(fullfile(raw_path,"VOL_"+num2str(index)+suffix));
    raw_4d(:,:,:,zz) = temp_raw;
    temp_denoise = tiffreadVolume(fullfile(denoise_path,"VOL_"+num2str(index)+suffix));
    denoise_4d(:,:,:,zz) = temp_denoise;
end
%%
% raw_4d_10x = movmean(raw_4d,10,4);
% raw_4d = raw_4d(:,:,:,5:end-5);
% denoise_4d = denoise_4d(:,:,:,5:end-5);
mean_psnr_mean = [];
mean_corr_mean = [];
denoise_psnr_mean = [];
denoise_corr_mean = [];
for downsample_factor = 5:100

    raw_4d_10x = movmean(raw_4d,downsample_factor,4, "Endpoints","discard");

    denoise_4d_down = denoise_4d(:,:,:,floor(downsample_factor/2):end-ceil(downsample_factor/2));
raw_4d_10x =raw_4d_10x(:,:,:,:);
denoise_4d_down =denoise_4d_down(:,:,:,:);
rescale_RA=rescale_RA(:,:,:);
    %%
    psnr_mean_list = [];
    corr_mean_list = [];
    psnr_denoise_list = [];
    corr_denoise_list = [];
    A = dir(denoise_path);
    z_slice_num = length(A)-3+1;
    
    for zz = 1:size(denoise_4d_down,4)
        temp_denoise = rescale(denoise_4d_down(:,:,:,zz));
        temp_RA = rescale(raw_4d_10x(:,:,:,zz));

        peaksnr_mean = psnr(rescale(temp_RA(13:106,:,:)),rescale_RA);
        psnr_mean_list = [psnr_mean_list, peaksnr_mean];
        corr_mean = corrcoef(rescale(temp_RA(13:106,:,:)),rescale_RA);
        corr_mean_list = [corr_mean_list, corr_mean(1,2)];

        peaksnr_denoise = psnr(temp_denoise,temp_RA);
        psnr_denoise_list = [psnr_denoise_list, peaksnr_denoise];
        corr_denoise = corrcoef(temp_denoise,temp_RA);
        corr_denoise_list = [corr_denoise_list, corr_denoise(1,2)];
    
    end
    mean_psnr_mean = [mean_psnr_mean mean(psnr_mean_list)];
    mean_corr_mean = [mean_corr_mean mean(corr_mean_list)];
    denoise_psnr_mean = [denoise_psnr_mean mean(psnr_denoise_list)];
    denoise_corr_mean = [denoise_corr_mean mean(corr_denoise_list)];
end
save(fullfile(path, output_index_name),"mean_psnr_mean","mean_corr_mean","denoise_psnr_mean","denoise_corr_mean")
%%
% load(fullfile(path, output_index_name))
close all


figure
plot(5:100,denoise_corr_mean)
ylabel("Correlation")
xlabel("Move mean frames")
title("Denoised vs Move Mean")
figure
plot(5:100,denoise_psnr_mean)
ylabel("PSNR")
xlabel("Move mean frames")
title("Denoised vs Move Mean")


figure
plot(5:100,mean_corr_mean)
hold on
yline(0.6073, "--")
ylabel("Correlation")
xlabel("Move mean frames")
title("Slowscan vs Move Mean")
figure
plot(5:100,mean_psnr_mean)
hold on
yline(16.5107, "--")
ylabel("PSNR")
xlabel("Move mean frames")
title("Slowscan vs Move Mean")
%%
psnr_denoise_list_100 = [];
corr_denoise_list_100 = [];
for zz = 1:size(denoise_4d_down,4)
    temp_denoise = denoise_4d_down(:,:,:,zz);


    peaksnr_denoise = psnr(rescale(temp_denoise(13:106,:,:)),rescale_RA);
    psnr_denoise_list_100 = [psnr_denoise_list_100, peaksnr_denoise];
    corr_denoise = corrcoef(rescale(temp_denoise(13:106,:,:)),rescale_RA);
    corr_denoise_list_100 = [corr_denoise_list_100, corr_denoise(1,2)];
    
end

mean(psnr_denoise_list_100)
mean(corr_denoise_list_100)


figure
plot(corr_denoise_list_100)



