**DOF analysis**(dof_axial_intensity.m)

You can load in example data for test.

Example data include 30 ROIs for calculation.

```matlab
load('dof40.mat')
```

We assume the result of profile with 2 peaks at the edge, so we try to find the peaks first.

```matlab
intx=1:0.01:size(dof,1);
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

```
err=median(record);
remove1=find((record>err+90*voxelz));
remove2=find((record<err-90*voxelz));
record([remove1,remove2])=[];
orirecord=record./100.*voxelz;
poslist([remove1,remove2],:)=[];
intlbox([remove1,remove2],:)=[];
```

```
avgFWHM=ceil(mean(record));
empty=zeros(size(record,2),2*avgFWHM+1);
for i=1:size(record,2)
    expandl=[zeros(1,avgFWHM),intlbox(i,:),zeros(1,avgFWHM)];
    midd=ceil(length(expandl)+1/2);
    midpoint=poslist(i,2)+(poslist(i,1)-poslist(i,2))/2;
    s=midpoint-ceil(avgFWHM/2);
    f=midpoint+ceil(avgFWHM*2);
    empty(i,midd-(f-s)/2:midd+(f-s)/2)=expandl(s:f);
    figure(1),plot(expandl(s:f));hold on
end
%
normempty=normalize(empty(:,midd-(f-s)/2:midd+(f-s)/2));
```

以下我們以統計方式算出平均值與標準差

```
error=std(normempty(:,1:100:end));
avgnorm=mean(normempty,1);
```

由以上的結果我們可以畫出以下的圖:

```
figure(12),subplot(222),errorbar([1:100:size(normempty,2)],avgnorm(1:100:end),error);xlabel('distance(\mum)');axis tight;ticklabel(8/100)
figure(12),subplot(221),plot(normempty');ticklabel(8/100);xlabel('distance(\mum)');axis tight;title(['DOF=',num2str(mean(orirecord)),'\mum'])
```

我們可以將平均值與標準差畫成以下的圖,底色的上下邊界是由平均值與標準差決定;中間的實線即平均值的結果:

```
avg=mean(normempty);
upper=avg+std(normempty);
lower=avg-std(normempty);
```
