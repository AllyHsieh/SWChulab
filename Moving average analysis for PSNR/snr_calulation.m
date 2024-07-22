figure(5),subplot(121),imagesc(squeeze(sum(raw(:,:,2:30,400),3)));title('RAW signal');axis image
figure(5),subplot(122),imagesc(squeeze(sum(denoise(:,:,2:30,400),3)));title('Denosie signal');axis image
%%

signalrange=[20:70;10:60];
%bgrange=[90:100;25:35];
sr=raw(signalrange(1,:),signalrange(2,:),2:30,:);
figure(231),subplot(221),imagesc(squeeze(sum(raw(signalrange(1,:),signalrange(2,:),2:30,100),3)));title('RAW_signal');axis image
signalr=squeeze(mean(sr,[1,2]));
br=squeeze(mean(raw(bgrange(1,:),bgrange(2,:),2:30,:),[1,2]));
figure(231),subplot(222),imagesc(squeeze(sum(raw(bgrange(1,:),bgrange(2,:),2:30,100),3)));title('RAW_bg');axis image
image2D = reshape(raw(bgrange(1,:),bgrange(2,:),2:30,:), [], size(raw,3)-2, size(raw,4));
stdr = squeeze(std(image2D, 0, 1));
%stdr=squeeze(std(br,[],[1,2]));
SNRr=(signalr-br)./sqrt(signalr-br+stdr.^2);
%SNRr=(signalr)./sqrt(stdr.^2);

resultr=permute(SNRr(:,2:end-1),[2,1]);
%%
signalrange=[30:100;30:100];
bgrange=[90:100;110:120];
% signalrange=[50:80;35:65];
% bgrange=[25:50;10:35];
sd=denoise(signalrange(1,:),signalrange(2,:),2:30,:);
signald=squeeze(mean(sd,[1,2]));
figure(231),subplot(223),imagesc(squeeze(sum(denoise(signalrange(1,:),signalrange(2,:),2:30,100),3)));title('Denoised_signal');axis image
bd=squeeze(mean(denoise(bgrange(1,:),bgrange(2,:),2:30,:),[1,2]));
figure(231),subplot(224),imagesc(squeeze(sum(denoise(bgrange(1,:),bgrange(2,:),2:30,100),3)));title('Denoised_bg');axis image
image2D = reshape(denoise(bgrange(1,:),bgrange(2,:),2:30,:), [], size(denoise,3)-2, size(denoise,4));
stdd = squeeze(std(image2D, 0, 1));
%stdd=squeeze(std(bd,[],[1,2]));
SNRd=(signald-bd)./sqrt(signald-bd+stdd.^2);
%SNRd=(signald)./sqrt(stdd.^2);
resultd=permute(SNRd(:,2:end-1),[2,1]);
%%
figure(1),subplot(211),violinplot(resultr(:,1:4:end),[1:4:29]);title('SNR-raw data');ylim([0 40])
figure(1),subplot(212),violinplot(resultd(:,1:4:end),[1:4:29]);title('SNR-TAGSPARK');ylim([0 40])
