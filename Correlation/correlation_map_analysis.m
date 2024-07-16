slow=tiffreadVolume("E:\20240529\25xNA1.05_mouse_hwp308_PMT0.8_dwt0.005_z0-4-20.tif");
slow=double(slow(:,:,2:end,1));voxel=4;
fast=timeproj(10:115,17:116,:);
%resizes=imresize(slow(30:end-40,20:end-20,10),[size(fast,1),size(fast,2)]);
%0529mouse40%
start=10;final=40;
lowset=[30,40,20,20];
upset=[65,70,85,70];
%slow(30:end-40,20:end-20,10)
%slow(65:end-70,85:end-70,40)

% %0529FLB40%
% start=5;final=35;
% lowset=[50,0,0,0];
% upset=[90,30,100,80];


start=start-1;
y1=round(linspace(lowset(1),upset(1),final-start));
y2=round(linspace(lowset(2),upset(2),final-start));
x1=round(linspace(lowset(3),upset(3),final-start));
x2=round(linspace(lowset(4),upset(4),final-start));

y1list=padarray(y1,[0,start],min(y1));
y1list(final:size(slow,3))=max(y1);
y2list=padarray(y2,[0,start],min(y2));
y2list(final:size(slow,3))=max(y2);
x1list=padarray(x1,[0,start],min(x1));
x1list(final:size(slow,3))=max(x1);
x2list=padarray(x2,[0,start],min(x2));
x2list(final:size(slow,3))=max(x2);
box=[];
for s=1:size(slow,3)
    temps=slow(y1list(s):end-y2list(s),1+x1list(s):end-x2list(s),s);
    resizes=imresize(temps,[size(fast,1),size(fast,2)]);
    for f=1:size(fast,3)
        tempf=fast(:,:,f);
        r=corrcoef(resizes,tempf);
        box(s,f)=r(2);
    end
end
[v1,p1]=max(box(:,1));
[v2,p2]=max(box(:,end));
figure(223),imagesc(box);title(['DOF=',num2str(voxel*(p2-p1)),'um']);
%%
j=4;
figure(j),subplot(231),imagesc(box);title(['DOF=',num2str(voxel*(p2-p1)),'um']);
s1=imresize(slow(y1list(p1):end-y2list(p1),1+x1list(p1):end-x2list(p1),p1),[size(fast,1),size(fast,2)]);
figure(j),subplot(232),imagesc(s1);axis image;title(['slow scan, depth = ',num2str(p1*voxel),'\mum'])
figure(j),subplot(233),imagesc(fast(:,:,1));axis image;title('fast scan, layer = 1')
mid=round(abs(p2-p1)/2+p1);mids=slow(y1list(mid):end-y2list(mid),1+x1list(mid):end-x2list(mid),mid);[v3,p3]=max(box(mid,:));
resizes=imresize(mids,[size(fast,1),size(fast,2)]);
figure(j),subplot(234),imshowpair(resizes,fast(:,:,p3));title(['r = ',num2str(v3)])
s2=imresize(slow(y1list(p2):end-y2list(p2),1+x1list(p2):end-x2list(p2),p2),[size(fast,1),size(fast,2)]);
figure(j),subplot(235),imagesc(s2);axis image;title(['slow scan, depth = ',num2str(p2*voxel),'\mum'])
figure(j),subplot(236),imagesc(fast(:,:,265));axis image;title('fast scan, layer = 265')