%addpath('.\ReadImageJROI.m');
%addpath('.\ellipse2mask.m');
%addpath('.\ROIs2Regions.m');
clear
folderPath = 'D:\z=2_slice=31\18_2_4_v22_move_4\30rois\';
fileInfo = dir(fullfile(folderPath, '*.zip'));
zipname='RoiSet-z%d-27rois.zip';
d=5;
for name=1:numel(fileInfo)-1
    disp(['name=',num2str(name)])
    sROI = ReadImageJROI([folderPath,sprintf(zipname,d)]);
    se = strel('line',4,90);
    se2 = strel('line',10,180);
    se3 = strel('line',2,180);
    roicollect = zeros(94,64,27); %53:427
    for k=1:length(sROI)
        m=0;
        plate=zeros(512,256);
        plate2=zeros(512,256);
        for i=2:3:length(sROI{1,k}.vfShapes)
            if i+m+1<length(sROI{1,k}.vfShapes)
                if sROI{1,k}.vfShapes(i+m)<=4
                    m=m+1;
                end
                if sROI{1,k}.vfShapes(i+m)>256
                    plate(sROI{1,k}.vfShapes(i+1+m),256)=1;
                else
                    plate(sROI{1,k}.vfShapes(i+1+m),sROI{1,k}.vfShapes(i+m))=1;
                end
            bw = imdilate(plate,se);
            bw2 = imdilate(bw,se2);
            plate2 = imfill(bw2,'holes');
            end
        end
        bigsizemask(:,:,k,name)=plate2;
        plate2 = plate2(53:427,:,:);
        mask=imresize(plate2,1/4,"nearest");
        mask(mask<0.5)=0;
        mask(mask~=0)=1;
        mask = imfill(mask,'holes');
        %figure(9),imagesc(mask);axis image;title(num2str(k))
        eromask = imerode(mask,se3);
        roicollect(:,:,k)=eromask;
        mask=zeros(size(plate2,1),size(plate2,2));
    end
    recordlist(name)=d-2;
    roibox(:,:,:,name)=roicollect;
    d=d+2;
end
%
check=squeeze(sum(roibox,3));
for i=1:14
figure(99),imagesc(check(:,:,i));axis image;title(['z=',num2str(i)]);pause(0.5)
end
%
save([folderPath,'mask_27rois.mat'],'roibox','recordlist','bigsizemask')

%%
m=roibox(:,:,:,14);
p=zeros(size(m,1),size(m,2));
for i=1:27
    p(m(:,:,i)==1)=idx(i);
end