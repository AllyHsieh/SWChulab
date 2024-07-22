**XYZ resolution analysis with FLB** ()

```matlab
flb=double(tiffreadVolume('25xNA1.05_200nm_HWP308_PMT0.79_dt0.004_z0-0.5-10_2.tif'));
```

```matlab
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
```


```matlab
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
```

```matlab
[delete,outxy,outz]=remove(xyfwhmbox,zfwhmbox,voxelxy,voxelz,error);
```

```matlab
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
```

```matlab
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
```

```matlab
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
```


**DOF analysis**  (dof_axial_intensity.m)

You can load in example data for test.

Example data include 30 ROIs for calculation.

```matlab
load('dof40.mat')
```

We assume the result of profile with 2 peaks at the edge, so we try to find the peaks first.

```matlab
for i=1:size(dof,2)
    l=dof(:,i);
    intl=interp1(x,l,intx,'linear');  %We use interpolation to find the position corresponding to specific value
    intlbox(i,:)=intl;
    [pks,locs] = findpeaks(intl);  %We find the peak and position in z, we expect to find 2 peaks, if it can find only one or more than 2, it will show you error.
    h= sort(pks,'descend'); %Sorting the peaks follow depths
    rightmax = find(intl==h(1));
    leftmax = find(intl==h(2));
    half_max=(intl(rightmax)-min(intl))/2;  %find the FWHM value
    [~,maxnum]=min(sqrt(intl(rightmax:end).^2-half_max^2)); %在右側的最高點向右找,找到最接近FWHM的位置,也就是與FWHM相對距離最短的
    maxnum=maxnum+rightmax;  %找到的位置要再加上(向右)原本最高點的起始值
    [~,minnum]=min(sqrt(intl(1:leftmax).^2-half_max^2)); %在左側的最高點向左找,找到最接近FWHM的位置,也就是與FWHM相對距離最短的
    FWHM=abs(maxnum-minnum); %找到的位置要再減掉(向左)原本最高點的起始值
    record(i)=FWHM;
    poslist(i,:)=[maxnum,minnum];
end
```

為了避免過大誤差值,直接設定某閾值作為篩選

```matlab
err=median(record);
remove1=find((record>err+90*voxelz));
remove2=find((record<err-90*voxelz));
record([remove1,remove2])=[];
orirecord=record./100.*voxelz;
poslist([remove1,remove2],:)=[];
intlbox([remove1,remove2],:)=[];
```

以下我們以統計方式算出平均值與標準差

```matlab
error=std(normempty(:,1:100:end));
avgnorm=mean(normempty,1);
```

由以上的結果我們可以畫出以下的圖:

<img src="DOF_4panels_fig.jpg" alt="practical DOF analysis" width="300" >

圖1: 畫出所有還在閾值內的line profile

圖2: 以平均值為主畫出各深度的error bar

圖3: 將各ROI平均值標出

圖4: 底色的上下邊界是由平均值與標準差決定;中間的實線即平均值的結果

