## Reconstruction of high-speed scanning volumetric images

Following is the steps of reconstruction:

0. Before starting, please check the parameters for calibration of y-axis:

1. Sorting 3D image from 2D tiff

2. Calibration of the edges result from galvo accelration

3. Time correction for voxel dependent

4. Reslice in z direction into layer/micrometer unit

**previousreconstruct_checkyaxisrescale.m**

Section1: 排列10個時間點的體積影像,並且做time projection,以提升影像品質,方便進行對照

Section2: Adjust parameters

先確定有將路徑加入\correct_yaxis\的資料夾

```matlab
addpath('C:\Users\714\Yintzu\tdms_to_tiff_v9 -bk\correct_yaxis\')
```

因為不同實驗與FOV對於參數有所影響,所以可以自行建立Library

```matlab
FOV = "test";
switch FOV
    case "test"
        coefficient = [ 3.8, -0.5,  1, 1, -67, 0.1];
end
```

coefficient陣列中分別對應到:

```matlab
offset = coefficient(1); 
shift = coefficient(2);
edge1 = coefficient(3); %上方黑邊的大小
edge2 = coefficient(4); %下方黑邊的大小
start = coefficient(5); %調整整個畫面的上下位置
gap = coefficient(6); %調整黑色間隔的大小
```
請注意: 這份檔案是對於y軸固定為128 pixel的影像設計

**correct_yaxis/reconstruct_one_frame.m**

確定好coefficient六項參數後,請將Library的設定新增至reconstruct_one_frame.m

```matlab
% fix error from Galvo!
switch FOV
        case "test"
        coefficient = [ 3.8, -0.5,  1, 1, -67, 0.1];
end
```

# 進入重建三維體積影像的階段

**main.m**

一樣要將路徑加入,才可以呼叫資料夾中的function

```matlab
addpath('.\correct_yaxis\');
addpath('.\time_corr\'); 
addpath('.\reslice\');
```

**Sorting 3D image from 2D tiff & Calibration of the edges result from galvo accelration**

你需要輸入以下的參數來決定存放的資料夾,與實驗設定:

```matlab
inputtiffdir='H:\Leo\240708\fast\'; %你的快掃體積資料夾存放的位置
outputmatdir='H:\Leo\240708\fast\'; %輸出檔案將存放的位置
folder = 'trial5'; %在這個資料夾內,會存放你的快掃tiff檔案
FOV =  "test"; %FOV填入你的Library的指定名稱,如上述的case
x_pixel = 128; %重新組圖後的影像尺寸X
y_pixel = 128; %重新組圖後的影像尺寸Y
z_pixel = 265; %重新組圖後的影像尺寸Z
```

**Time correction for voxel dependent**

完成Sorting 與 y-axis calibration 後,會進行voxel-dependent time correction
```matlab
%% time correction
tic
%xyzt_raw_data_timecorr = TAG_preprocessing(xyzt_raw_data); %如果要進行time correction可以利用TAG_preprocessing這個function
%disp('timecorr')
xyzt_raw_data_timecorr = xyzt_raw_data; %如果不需要,可以直接更新名稱進到下一步
disp('no timecorr')
toc
```

**Reslice in z direction into layer/micrometer unit**

在reslice的部分,是針對z方向的排序有所調整,可以依照layer(TAG lens訊號)或是z(實際的物理單位:micrometer)

使用方法是利用"內插法",如果方法選擇

layer: 代表"N_layer"張的影像,會被疊在一起

z: 代表先算出間隔N_z的大小,每個間隔內的影像張數因為TAG lens是以sine wave排列,所以有所不同,再利用內插法求出該間隔中的中間值,作為該位置的影像

```matlab
save_type = "interpolate";
method = "z";
z_physical_distance = 94; % DOF單位是micrometers
% z-axis resample
if method == "z"
    N_z = 2; % N_z = z resolution; 組出來的間隔會是N_z micrometers
    z_axis_resample(method,N_z,z_physical_distance);
    interval=N_z;
elseif method == "layer"
    N_layer = 1; % "N_layer" layers turn into 1 stack; 如果原始檔案z有265張, layer=1即,每1張疊成1個,所以輸出有265/1 張
    z_axis_resample(method,N_layer,z_physical_distance); %用不到z_physical_distance
    interval=N_layer;
end
```

當你需要重新排列z方向的定義,請直接跑reslice section

load in "已經完成sorting與time correciton的矩陣": xyzt_raw_data_timecorr.mat

與設定 "輸出的資料夾名稱": outputmatdir 以及 folder

輸出的檔案會存在新增的資料夾,該資料夾的命名方式為: "method_interval_reslice",當你設定不同儲存方式時,會直接新增資料夾而不會覆蓋檔案

method = z or layer

interval = N_z or N_layer

```matlab
output_reslice_filename = convertStringsToChars(strcat(method,'_',num2str(interval),'_reslice'));
```

確定要輸出tiff時,可以設定此4D矩陣以 xyt-z 或是 xyz-t的形式儲存

存出檔案會很耗時,可以只輸出你要的格式

```matlab
%% extract data from raw stack
% xyt: output x-y-t stack in ./ch1_out_xyt dir, using 1(save), 0(don't save)
% xyz: output x-y-z stack in ./ch1_out_xyz dir, using 1(save), 0(don't save)
xyt = 0;
xyz = 1;
% run
tic
extract_data_from_raw_stack(xyzt_reslice_timecorr,xyt,xyz,newfolder);
toc
disp("all done")
```
