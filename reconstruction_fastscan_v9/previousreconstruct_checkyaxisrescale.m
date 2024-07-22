%% reconstruct 10VOL projection
clear
inputtiffdir='E:\Alice\mouse slide\20240424\fast\fast\TAGonold25xNA1.05_mouse5_HWP308_PMT0.80_dt0.004_mag1_z-101_40%\4_4_64_128\layer_1_reslice\';
folder='ch1_out_xyz\';

x_pixel = 128;
y_pixel = 128;
z_pixel = 265;

% ch1 folder start/final image name
%
folder_path = fullfile(inputtiffdir, folder);
T = struct2table(dir(fullfile(folder_path, '*.tiff')));
S=string(table2cell(T(:,1)));
dataname=zeros(length(S)-2,1);
halfx=x_pixel/2;

for f=1:size(S,1)
    % Remove the file extension
    [~, name, ~] = fileparts(S{f});
    % Use sscanf to extract integer from string and store in dataname
    dataname(f) = sscanf(name, '%d');
end
first=min(dataname);
ALL_first = ceil(first/64).*64;
lastone = max(dataname);
last = floor((ALL_first+x_pixel/2*10)/64)*64; %10個體積
s1 = [inputtiffdir,folder,'\'];  %input
k=1;
for i = ALL_first:last
    % Create a tiff filename, and load it into a structure called tiffData.
    tiffFileName = sprintf('%d.tiff', i);
    if exist(strcat(s1,tiffFileName), 'file')
        image= double(imread(strcat(s1,tiffFileName)));
        if mod(i,halfx)==1
            k=k+1;
        end
        z=mod(i,halfx);
        if z==0
            z=halfx;
        end
        box(:,:,z,k)=image;
    else
        fprintf('File %s does not exist.\n', tiffFileName);
    end
end
Box=permute(box,[2,3,1,4]);
[y,x,z,t]=size(Box);
upbox=Box(1:y_pixel,:,:,:);
downbox=flipud(Box(y_pixel+1:end,:,:,:));
newbox=zeros(y_pixel,x_pixel,z,t);
newbox(:,1:2:end,:,:)=upbox;
newbox(:,2:2:end,:,:)=downbox;
img=squeeze(sum(newbox,4));
figure,imagesc(sum(img,3));axis image
%% adjust parameters
addpath('C:\Users\714\Yintzu\tdms_to_tiff_v9 -bk\correct_yaxis\')
img=sum(img,3);
output = readtable("average.csv");
output = table2array(output);

FOV = "700*700";
switch FOV
    case "test"
        coefficient = [ 3.8, -0.5,  1, 1, -67, 0.1];
    case "700*700"
        coefficient = [ 3.8, -0.5,  1, 1, -67, 0.1];
    case "354*354mouse_22hz"
        coefficient = [ 0, -0.2, 10, 10, -63, 0];
    case "354*354mouse"
        coefficient = [ 0, -0.2, 7, 10, -75, 0.32];
    case "400*400mouse052925%"
         coefficient = [ 3, -0.2, 8, 8, -67, 0.1];
    case "400*400mouse052915%"
         coefficient = [ 3.6, -0.1, 8, 8, -66, 0.1];   
    case "test2"
        coefficient = [ 4, -1,  2.1, 2, -73, 0.32]; 
    case "250*500FLB"
        coefficient = [ 3.2, -0.16,  12, 15, -69, 0.3];
    case "250*250FLB"
        coefficient = [ 0.4, -0.6,  2.3,  3, -105, 2.2];
    case "500*500FLB"
        coefficient = [ 3, -0.2,  4, 3, -69, 0.2];
    case "500*500FLB(240422)"
        coefficient = [ 3, -0.31,  8, 5, -69, 0.2];
    case "500*500GRIN"
        coefficient = [  3, -0.1,  3,3, -68, 0.15];
    case "250*250GRIN(040724GRIN)"
        coefficient = [ 0.1, -0.1,  10,  10, -75, 0.1];
    case "250*250GRIN"
        coefficient = [  -0, 0,  1,  1, -70, 0.16];
    case "200*200"
        coefficient = [-1.8, -0.3, 3,  6, -75, 0.32];
    case "200*400"
        coefficient = [ 1.5, -0.4, 5,  6, -75, 0.36]; 
    case "100*200"
        coefficient = [ 1.8, -0.4, 5,  6, -76, 0.37]; 
    case "300*300"
        coefficient = [-0.6, -0.2, 7, 10, -75, 0.32];
    case "400*400"
        coefficient = [ 1.7, -0.3, 7,  9, -76, 0.38];
    case "500*500"
        coefficient = [ 1.2, 0.5,  3, 10, -77, 0.45];
    case "250*250"
        coefficient = [  -2, 0.1,  3,  3, -74, 0.36];
end
offset = coefficient(1);
shift = coefficient(2);
edge1 = coefficient(3);
edge2 = coefficient(4);
start = coefficient(5);
gap = coefficient(6);

%
output_y = (rescale(-output)-0.5)*2*63.5;

% figure
% plot(output_y)
% title("output")
%
% figure
% imagesc(img)
% title("raw")

y_sample = [];
for y = 1:size(img,2)
    if mod(y,2)
        for x = 1:size(img,1)
            y_sample = [y_sample (x-64.5)];
        end
    else
        for x = 1:size(img,1)
            x_rev = size(img,1)-x+1;
            y_sample = [y_sample (x_rev-64.5)];
        end
    end
end

%
f=1/256;
t=0:length(y_sample);
y_sin=sin(2*pi*f*t-pi/2);
y_sin=63.5*y_sin;

y_sin4(1:64)=(sin(2*pi*f*t(1:64)-pi/2).^4)*edge1;
y_sin4(65:128)=(sin(2*pi*f*t(65:128)-pi/2).^4)*edge2; 
shift = shift * y_sin4(1:128)' + offset;

y_p = shift' +output_y(1:128)';
y_m = -shift' +output_y(1:128)';

% figure
% plot(shift)
% title("shift")

shift_output = [y_p flip(y_m)];
% figure
% plot(shift_output)
% title("real output")

for y = 1:size(img,2)
    if mod(y,2)
        reconstructed_data(:,y) = interp1(y_m,double(img(:,y)),y_sample(1:128));
    else
        reconstructed_data(:,y) = interp1(y_p,double(img(:,y)),y_sample(1:128));
    end
end

% figure
% imagesc(img_resample)
% title(str);

if FOV ~= "new"
    new = zeros(size(img));
    newline = [start];
    interval = 1;
    for y = 1:127
        interval = interval + gap/127;
        newline = [newline newline(end)+interval];
    end 
    
    for y = 1:size(img,2)
        if mod(y,2)
            new(:,y) = interp1(y_sample(1:128),double(reconstructed_data(:,y)),newline);
        else
            new(:,y) = interp1(y_sample(1:128),double(reconstructed_data(:,y)),newline);
        end
    end
    
    reconstructed_data = new;
end
figure,imagesc(imresize(sum(reconstructed_data,3),[128 128]));axis image
%figure,imagesc(sum(reconstructed_data,3));axis image
%%
% 讀取第一張圖片
% reconstructed_data = reconstructed_data; % 假設你已經定義了reconstructed_data
img1 = sum(reconstructed_data, 3); % 求和並生成灰度圖像

% 調整大小為 [128, 128]
img1_resized = imresize(img1, [128, 128]);

% 創建新的 figure
%figure;

% 在第一個 subplot 中顯示圖像
subplot(1, 2, 1);
imagesc(img1_resized);
axis image;
title('Sum of reconstructed data');

% 加上 colorbar
colorbar;

% 讀取第二張圖片
slow = double(tiffreadVolume('E:\Alice\040724_GRIN 1um\slowgood\FLB1um_20X0.5NA_HWP304_AVG1_MAG2_-120_0_0.5.tif'));
% Resize slow to 128x128
slow_resized = imresize(slow, [128, 128]);
% 在第二個 subplot 中顯示圖像
subplot(1, 2, 2);
imagesc(slow_resized);
axis image;
title('Slow image');

% 加上 colorbar
colorbar;
%%
slow=double(tiffreadVolume('E:\Alice\040724_GRIN 1um\slowgood\FLB1um_20X0.5NA_HWP304_AVG1_MAG2_-120_0_0.5.tif'));
slow=slow(:,:,:,1);
fast=mean(zstack(:,:,:,2:33),4);
%fast=double(tiffreadVolume('C:\Users\714\DeepCAD-Z\results\DataFolderIs_mitutoyoTAG_202312132110_ModelFolderIs_mitutoyoTAG_202312132102\E_03_Iter_0154\VOL_13_denoised.tiff'));
fast=imresize(fast(6:end,1:end,:,:),[126,126]);
%fast=fast(3:end,:,:,:);
slow=imresize(slow(:,:,:),[126,126]);
slow=slow(:,2:end,:);
for s=1:size(slow,3)
    ref=slow(17:114,:,s);
   % ref=circshift(ref,[0,-4]);
    for f=1:size(fast,3)
        r=corrcoef(ref,fast(17:114,2:end,f));
        record(s,f)=r(2);
    end
end
figure(21),imagesc(record);ylabel('slow scan(um)');xlabel('fast scan(layer)');
yticks([0:3.75:44]);yticklabels({'120','105','90','75','60','45','30','15','0','-15','-30','-45'})
figure(11),imshowpair(slow(:,:,32),fast(:,:,100))