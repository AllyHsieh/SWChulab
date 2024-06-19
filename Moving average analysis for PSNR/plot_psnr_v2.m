%load("E:\z=2_slice=31\18_2_4_v22_move_4\psnr_corr_29_4_2_4_move4_v2_ds20.mat")
close all

mean_psnr_raw = mean(psnr_raw_list);
mean_psnr_denoise = mean(psnr_denoise_list);
mean_corr_raw = mean(corr_raw_list);
mean_corr_denoise = mean(corr_denoise_list);
%%

[h_snr,p_snr] = ttest2(psnr_raw_list,psnr_denoise_list, Tail="left")
[h_corr,p_scorr] = ttest2(corr_raw_list,corr_denoise_list, Tail="left")

figure
violinplot(psnr_raw_list);
hold on
violinplot(psnr_denoise_list)
legend(["raw", "denoised"])
xlabel("frame")
title("PSNR")

figure
violinplot(corr_raw_list);
hold on
violinplot(corr_denoise_list)
legend(["raw", "denoised"])
xlabel("frame")
title("Pearson correlation")


%%
close all;
colors = [ [250/255,128/255,114/255];[0/255,191/255,255/255]];
figure('Position', [200 300 800 600])
subplot(1,2,1)
violinplot([psnr_raw_list',psnr_denoise_list'], [1 2],  'ShowData', false, 'ViolinColor', colors, 'ViolinAlpha', 1);



yt = get(gca, 'YTick');
axis([xlim    21  36])
xt = get(gca, 'XTick');
hold on
plot(xt([1 2]), [1 1]*34.1865, '-k')
text(mean(xt([1 2]))-0.17, 34.5165, '****','FontSize',18)
title("PSNR")
ax = gca; 
ax.FontSize = 20; 
xticklabels(["Raw" "Denoised"])


subplot(1,2,2)
violinplot([corr_raw_list',corr_denoise_list'], [1 2],  'ShowData', false, 'ViolinColor', colors, 'ViolinAlpha', 1);




yt = get(gca, 'YTick');
axis([xlim    0.5  0.955])
xt = get(gca, 'XTick');
hold on
plot(xt([1 2]), [1 1]*0.9, '-k')
text(mean(xt([1 2]))-0.17, 0.91, '****','FontSize',18)
xticklabels(["Raw" "Denoised"])
title("Pearson Correlation")

ax = gca; 
ax.FontSize = 20; 
%%
figure
histogram(psnr_raw_list)
hold on
histogram(psnr_denoise_list)
legend(["raw", "denoised"])
title("PSNR distribution")


figure
histogram(corr_raw_list)
hold on
histogram(corr_denoise_list)
legend(["raw", "denoised"])
title("Pearson correlation distribution")