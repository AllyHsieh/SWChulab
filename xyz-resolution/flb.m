flb=double(tiffreadVolume('25xNA1.05_200nm_HWP308_PMT0.79_dt0.004_z0-0.5-10_2.tif'));
flb=flb(:,:,:,1); %R channel
pick=329;error=0.195; %error range(px)
voxelz=0.5; %um
voxelxy=400/512/4; %um
bwflb=mean(flb,3);
bwflb(bwflb>20)=1;
bwflb(bwflb~=1)=0;
BW2 = bwareaopen(bwflb, 10);
mask=bwlabeln(BW2);
%mask=AW;
%mask=repmat(m, [1 1 size(flb,3)]); 
newmask=zeros(size(mask));k=1;
xyrecord=zeros(max(max(mask)),100);
record=zeros(max(max(mask)),size(flb,3));
for i=1:max(max(mask))
    empty=mask;
    empty(empty~=i)=0;
    empty(empty>0)=1;
    se = strel('disk', 3);
    dimask = imdilate(empty, se);
    roi=dimask.*flb;
    xy=squeeze(sum(roi(:,:,8),1))';
    f=find(xy>0);
    temp=[0;xy(f(1):f(end));0];
    xyrecord(i,1:length(temp))=temp;
    
    try
        xyfwhmbox(i)=gfit(temp);
    catch exception
        xyfwhmbox(i)=0;
        roi1(k)=i;k=k+1;
    end
    record(i,:)=squeeze(sum(roi,[1,2]));
    try
        zfwhmbox(i)=gfit(squeeze(sum(roi,[1,2])));
    catch exception
        zfwhmbox(i)=0;
        roi11(k)=i;k=k+1;
    end
    newmask=newmask+dimask.*i;
    newmask(newmask>i)=0;
end

[delete,outxy,outz]=remove(xyfwhmbox,zfwhmbox,voxelxy,voxelz,error);

figure(1),subplot(212),plot(outz);title(['meanFWHM_z=',num2str(mean(outz)*voxelz),' um;std=',num2str(std(outz))]);axis tight;labeling(voxelz)
figure(1),subplot(211),plot(outxy);title(['meanFWHM_x_y=',num2str(mean(outxy)*voxelxy),' um;std=',num2str(std(outxy))]);axis tight;labeling(voxelxy)
figure(2),subplot(121),imagesc(flb(:,:,12));axis image;
figure(2),subplot(122),imagesc(newmask);axis image;
tempz=record(pick,:)';
show(voxelz,tempz)
tempxy=xyrecord(pick,1:15)';
show(voxelxy,tempxy)
record(delete,:)=[];
n=record./mean(record,2);
figure(3),plot(n');
%
%y=squeeze(sum(flb(231:249,231:249,:),[1,2])); %singleFLB
%figure(9),imagesc(y);axis image;

singleFLB(flb,334,359,398,414)
avgr=mean(xyrecord./mean(xyrecord,2),1);
stdr=std(xyrecord./mean(xyrecord,2),1);
upper=avgr+stdr;lower=avgr-stdr;
fillplot(upper(1:15),lower(1:15),avgr(1:15));axis tight;hold on
y=avgr(1:15)';
x=1:length(y);
y=y';
gaussianModel = fittype('a*exp(-((x-b)/c)^2)', 'independent', 'x', 'dependent', 'y');
initialGuess = [max(y), x(find(y == max(y))), 10]; % 初始化參數為 [振幅, 平均值, 標準差]
fittmodel = fit(x', y', gaussianModel, 'StartPoint', initialGuess);
plot(fittmodel)


function fwhm=gfit(y)
x=1:length(y);
y=y';
gaussianModel = fittype('a*exp(-((x-b)/c)^2)', 'independent', 'x', 'dependent', 'y');
initialGuess = [max(y), x(find(y == max(y))), 10]; % 初始化參數為 [振幅, 平均值, 標準差]
fittmodel = fit(x', y', gaussianModel, 'StartPoint', initialGuess);
coefficients = coeffvalues(fittmodel);
mu = coefficients(2); % 高斯分布的均值
sigma = coefficients(3); % 高斯分布的標準差
amplitude = coefficients(1); % 高斯分布的幅度
fwhm = 2 * sqrt(2 * log(2)) * sigma/sqrt(2);
end

function [delete,outxy,outz]=remove(xy,z,voxelxy,voxelz,error)
avgxy=median(xy);errx=error/voxelxy; %px/um
avgz=mean(z);
outxy=xy;outz=z;
a=find(xy<avgxy-errx);b=find(xy>avgxy+errx);
c=find(z<avgz-voxelz);d=find(z>avgz+voxelz);
delete=[a,b,c,d];
outxy(delete)=[];
outz(delete)=[];
end

function show(voxel,y)
x=1:length(y);
y=y';
gaussianModel = fittype('a*exp(-((x-b)/c)^2)', 'independent', 'x', 'dependent', 'Intensity');
initialGuess = [max(y), x(find(y == max(y))), 10]; % 初始化參數為 [振幅, 平均值, 標準差]
fittmodel = fit(x', y', gaussianModel, 'StartPoint', initialGuess);
coefficients = coeffvalues(fittmodel);
mu = coefficients(2); % 高斯分布的均值
sigma = coefficients(3); % 高斯分布的標準差
amplitude = coefficients(1); % 高斯分布的幅度
fwhm = 2 * sqrt(2 * log(2)) * sigma/sqrt(2);
figure,scatter(x,y);hold on;plot(fittmodel);axis tight;title(['FWHM = ',num2str(fwhm*voxel),' voxel=',num2str(voxel)])
end

function labeling(voxel)
originalTicks = yticks;
newLabels = voxel * originalTicks;
yticklabels(string(newLabels));
end

function singleFLB(img,x1,x2,y1,y2)
figure(1000),subplot(221),imagesc(sum(img(y1:y2,x1:x2,:),3));axis image;title('xy')
figure(1000),subplot(222),imagesc(squeeze(sum(img(y1:y2,x1:x2,:),2)));title('xz')
figure(1000),subplot(223),imagesc(squeeze(sum(img(y1:y2,x1:x2,:),1))');title('yz')
end

function fillplot(upper,lower,avg)
x=1:length(avg);
hold on;
x2 = [x, fliplr(x)];
inBetween = [upper, fliplr(lower)];
figure(99),fill(x2, inBetween, 'b', 'FaceAlpha', 0.1); 
hold on
plot(avg,'k-')
hold off;
end
