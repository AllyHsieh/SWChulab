load('C:\b07 YinTzu\碩士論文\figures\ch3\DOF\dof40.mat')
voxelz=8;
x=1:1:size(dof,1);
intx=1:0.01:size(dof,1);
for i=1:size(dof,2)
    l=dof(:,i);
    intl=interp1(x,l,intx,'linear');
    intlbox(i,:)=intl;
    [pks,locs] = findpeaks(intl);
  h= sort(pks,'descend');
rightmax = find(intl==h(1));
leftmax = find(intl==h(2));
half_max=(intl(rightmax)-min(intl))/2;
[~,maxnum]=min(sqrt(intl(rightmax:end).^2-half_max^2));
maxnum=maxnum+rightmax;
[~,minnum]=min(sqrt(intl(1:leftmax).^2-half_max^2));
FWHM=abs(maxnum-minnum);
record(i)=FWHM;
poslist(i,:)=[maxnum,minnum];

end
err=median(record);
remove1=find((record>err+90*voxelz));
remove2=find((record<err-90*voxelz));
record([remove1,remove2])=[];
orirecord=record./100.*voxelz;
poslist([remove1,remove2],:)=[];
intlbox([remove1,remove2],:)=[];
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
error=std(normempty(:,1:100:end));
avgnorm=mean(normempty,1);
figure(12),subplot(222),errorbar([1:100:size(normempty,2)],avgnorm(1:100:end),error);xlabel('distance(\mum)');axis tight;ticklabel(8/100)
figure(12),subplot(221),plot(normempty');ticklabel(8/100);xlabel('distance(\mum)');axis tight;title(['DOF=',num2str(mean(orirecord)),'\mum'])
avg=mean(normempty);
upper=avg+std(normempty);
lower=avg-std(normempty);
fillplot(upper,lower,avg);axis tight;ticklabel(8/100);xlabel('distance(\mum)');title(['DOF=',num2str(mean(orirecord)),'\mum;std=',num2str(std(orirecord))])
figure(12),subplot(223),plot(orirecord);axis tight;xlabel('roi');title(['DOF=',num2str(mean(orirecord)),'\mum;std=',num2str(std(orirecord))])

function normA=normalize(A)
%A_min = min(A, [], 2);
%A_max = max(A, [], 2); 
%normA = (A - A_min) ./ (A_max - A_min);
normA=A./mean(A, 2);
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
function ticklabel(voxel)
originalTicks = xticks;
newLabels = originalTicks*voxel;
xticklabels(string(newLabels));
end