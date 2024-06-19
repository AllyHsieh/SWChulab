clc;clear;close all
var_downsample = 60;

path = "F:\z=2_slice=31\18_2_4_v22_move_4\";
output_index_name = "test_psnr_corr_29_4_2_4_move4_v2_ds60.mat";
% RA = tiffreadVolume(fullfile(path, "29_4_2_4_slowscan_coregist.tiff"));
% RA = RA(53:427,:,:);
% RA = imresize(RA,1/4,"nearest");
% rescale_RA = rescale(RA);

suffix = "_regist.tiff";
%53 427
%raw_path = fullfile(path,"xyz_raw_regist");
%denoise_path = fullfile(path,"xyz_denoise_regist");
raw_path = fullfile(path,"ch1_out_xyz_regist");
denoise_path = fullfile(path,"ch1_out_xyz_denoise_regist");
%denoise_path = fullfile(path,"ch1_out_xyz_denoise_regist");
psnr_raw_list = [];
var_raw_list = [];
corr_raw_list = [];
A = dir(raw_path);
z_slice_num = length(A)-3+1;
temp_raw_1 = tiffreadVolume(fullfile(raw_path,"VOL_"+2+suffix));
denoise_4d = zeros(size(temp_raw_1,1),size(temp_raw_1,2),size(temp_raw_1,3),z_slice_num);
raw_4d = zeros(size(temp_raw_1,1),size(temp_raw_1,2),size(temp_raw_1,3),z_slice_num);
%% process 4D raw to movemean
for zz = 1:z_slice_num
    index = zz+1;
    temp_raw = tiffreadVolume(fullfile(raw_path,"VOL_"+num2str(index)+suffix));
    raw_4d(:,:,:,zz) = temp_raw;
   temp_denoise = tiffreadVolume(fullfile(denoise_path,"VOL_"+num2str(index)+"_denoised"+suffix)); %+"_denoised"
     %temp_denoise = tiffreadVolume(fullfile(denoise_path,"VOL_"+num2str(index)+".tiff"));
    denoise_4d(:,:,:,zz) = temp_denoise;
end

cutraw_4d=raw_4d(:,:,:,:);
cutdenoise_4d=denoise_4d(:,:,:,:);
raw_4d=cutraw_4d;
denoise_4d=cutdenoise_4d;

%%
% raw_4d_10x = movmean(raw_4d,10,4);
% raw_4d = raw_4d(:,:,:,5:end-5);
% denoise_4d = denoise_4d(:,:,:,5:end-5);
const=size(raw_4d,4)-floor(size(raw_4d,4)/var_downsample)*var_downsample; %8
%downsample ver
raw_4d_10x = squeeze(mean(reshape(raw_4d(:,:,:,1:end-const),size(raw_4d,1),size(raw_4d,2),size(raw_4d,3),var_downsample,[]),4));
raw_4d = reshape(raw_4d(:,:,:,1:end-const),size(raw_4d,1),size(raw_4d,2),size(raw_4d,3),var_downsample,[]);
raw_4d = squeeze(raw_4d(:,:,:,1,:));
denoise_4d = reshape(denoise_4d(:,:,:,1:end-const),size(raw_4d,1),size(raw_4d,2),size(raw_4d,3),var_downsample,[]);
denoise_4d = squeeze(denoise_4d(:,:,:,1,:));
%%

psnr_denoise_list = [];
var_denoise_list = [];
corr_denoise_list = [];
A = dir(denoise_path);
z_slice_num = length(A)-3+1;

raw_4d_10x =raw_4d_10x(:,:,3,:);
denoise_4d =denoise_4d(:,:,3,:);

for zz = 1:size(denoise_4d,4)
    temp_raw = rescale(raw_4d(:,:,:,zz));
    temp_denoise = rescale(denoise_4d(:,:,:,zz));
    temp_RA = rescale(raw_4d_10x(:,:,:,zz));

    peaksnr_denoise = psnr(temp_denoise,temp_RA);
    psnr_denoise_list = [psnr_denoise_list, peaksnr_denoise];

    peaksnr_raw = psnr(temp_raw,temp_RA);
    psnr_raw_list = [psnr_raw_list, peaksnr_raw];

    corr_raw = corrcoef(temp_raw,temp_RA);
    corr_raw_list = [corr_raw_list, corr_raw(1,2)];

    corr_denoise = corrcoef(temp_denoise,temp_RA);
    corr_denoise_list = [corr_denoise_list, corr_denoise(1,2)];

end
save(fullfile(path, output_index_name),"corr_denoise_list","psnr_denoise_list","corr_raw_list","psnr_raw_list")
%%
% load(fullfile(path, output_index_name))
% close all
%%
[h_snr,p_snr] = ttest2(psnr_raw_list,psnr_denoise_list, Tail="left")
[h_corr,p_scorr] = ttest2(corr_raw_list,corr_denoise_list, Tail="left")
%% 
figure
plot(psnr_raw_list);
hold on
plot(psnr_denoise_list)
legend(["raw", "denoised"])
xlabel("frame")
title("PSNR")
% 
% figure
% plot(corr_raw_list);
% hold on
% plot(corr_denoise_list)
% legend(["raw", "denoised"])
% xlabel("frame")
% title("Pearson correlation")
% 
% 
% %%
% close all;
% colors = [ [250/255,128/255,114/255];[0/255,191/255,255/255]];
% figure('Position', [200 300 800 600])
% subplot(1,2,1)
% boxplot([psnr_raw_list',psnr_denoise_list'],'Labels',{'Raw','Denoised'})
% 
% h = findobj(gca,'Tag','Box');
% for j=1:length(h)
%     patch(get(h(j),'XData'),get(h(j),'YData'),colors(j,:),'FaceAlpha',.5);
% end
% 
% yt = get(gca, 'YTick');
% axis([xlim    18  27])
% xt = get(gca, 'XTick');
% hold on
% plot(xt([1 2]), [1 1]*38, '-k')
% text(mean(xt([1 2]))-0.17, 38.2, '****','FontSize',18)
% title("PSNR")
% ax = gca; 
% ax.FontSize = 20; 
% 
% 
% subplot(1,2,2)
% boxplot([corr_raw_list',corr_denoise_list'],'Labels',{'Raw','Denoised'})
% 
% h = findobj(gca,'Tag','Box');
% for j=1:length(h)
%     patch(get(h(j),'XData'),get(h(j),'YData'),colors(j,:),'FaceAlpha',.5);
% end
% 
% yt = get(gca, 'YTick');
% axis([xlim    0.2  0.75])
% xt = get(gca, 'XTick');
% hold on
% plot(xt([1 2]), [1 1]*0.7, '-k')
% text(mean(xt([1 2]))-0.17, 0.71, '****','FontSize',18)
% 
% title("Pearson Correlation")
% 
% ax = gca; 
% ax.FontSize = 20; 
% %%
% figure
% histogram(psnr_raw_list)
% hold on
% histogram(psnr_denoise_list)
% legend(["raw", "denoised"])
% title("PSNR distribution")
% 
% 
% figure
% histogram(corr_raw_list)
% hold on
% histogram(corr_denoise_list)
% legend(["raw", "denoised"])
% title("Pearson correlation distribution")







