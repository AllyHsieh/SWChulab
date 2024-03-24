%%
slow=double(tiffreadVolume('E:\240322\20xNA0.5_mousebrain_HWP306_PMT0.8 dt0.004_z0-2-270.tif'));
slow=slow(:,:,:,1);
figure(10),imagesc(sum(slow,3));axis image
%%
fa=mean(zstack(:,:,:,2:100),4);
fast=imresize(fa(:,1+3:end-2,:,:),[123,126]);
%fast=fast(3:end,:,:,:);
slow=imresize(slow,[123,126]);
slow=slow(:,1:end,:);
figure(11),imshowpair(slow(:,:,125),fast(:,:,floor(size(fast,3)/2)));
figure(12),imagesc(slow(:,:,70));axis image;figure(121),imagesc(fast(:,:,floor(size(fast,3)/2)));axis image;
%figure(12),imagesc(slow(:,:,75+45));axis image;figure(121),imagesc(fast(:,:,1));axis image;
%figure(12),imagesc(slow(:,:,65-25));axis image;figure(121),imagesc(fast(:,:,size(fast,3)));axis image;
%%
voxelz=2;img=3;
mag = interpvalue(120,35,5,size(slow,3));
for s=1:size(slow,3)
    fast=imresize(fa(:,1+ceil(mag(s)):end-floor(mag(s)),:,:),[123,126]);
    ref=slow(17:114,2:end,s);
    for f=1:size(fast,3)
        r=corrcoef(ref,fast(17:114,2:end,f));
        record(s,f)=r(2);
    end
end
[v1,p1]=max(record(:,1));
[v2,p2]=max(record(:,f));
figure(img),subplot(231),imagesc(record);ylabel('slow scan(um)');xlabel('fast scan(layer)');title(['DOF = ',num2str(abs(p1-p2)*voxelz)])
%yticks([0:floor(s/10):s]);yticklabels({'120','105','90','75','60','45','30','15','0','-15','-30','-45'})
figure(img),subplot(232),imagesc(slow(:,:,p1));axis image;title(['slow scan- highest= ',num2str(p1*voxelz)])
figure(img),subplot(233),imagesc(fast(:,:,1));axis image;title(['fast scan- r= ',num2str(v1)])
figure(img),subplot(234),imshowpair(slow(:,:,75),fast(:,:,floor(f/2)));
figure(img),subplot(235),imagesc(slow(:,:,p2));axis image;title(['slow scan- lowest= ',num2str(p2*voxelz)])
figure(img),subplot(236),imagesc(fast(:,:,f));axis image;title(['fast scan- r= ',num2str(v2)])

function mag = interpvalue(slow_top,slow_bottom,large,totalslow)
    known=linspace(0,large,slow_top-slow_bottom);
    unknown=linspace(large,large+1,totalslow-slow_top+1);
    mag=zeros(1,totalslow);
    mag(slow_bottom+1:slow_top)=known;
    mag(slow_top:totalslow)=unknown;
end
