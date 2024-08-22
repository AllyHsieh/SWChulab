# regist_3D.m 
Step 1: 輸入影像檔案

設定影像儲存之路徑，以及影像名稱

Example: VOL_1.tiff, VOL_2.tiff, ...

固定的名稱以及依序改變的數字可以利用

```matlab
sprintf('VOL_%d.tiff,i)
```

利用變動參數i, 依序讀入檔案

並且可以利用```suffix```參數設定, 改變名稱的最後稱謂

Example: VOL_1_denoised.tiff, or  VOL_1_regist.tiff

讀入檔案後, 我們需要定義一個參考體積(reference), 讓後續的影像對齊該體積, i.e. fixedVolume & movingVolume

```matlab
fixedVolume = tiffreadVolume(fullfile(path, "VOL_2"+suffix+".tif")); %讀入VOL_2檔案,設定為參考體積
```

```matlab
movingVolume = tiffreadVolume(fullfile(path, "VOL_"+num2str(i)+suffix+".tif")); %讀入檔案
```
Step 2: 移動可變影像,

利用```tform = imregtform(moving,fixed,tformType,optimizer,metric)```MATLAB內建function

設定方法為 translation, 只會進行平移, 不會有扭曲與變形, 因為我們假設老鼠的晃動是不會改變影像的形貌

```matlab
tform = imregtform(movingVolume,fixedVolume,"translation",optimizer,metric); %使用 translation transform
```

將記錄下的轉移矩陣參數, 套回影像中```Rout = affineOutputView(sizeA,tform)```並會回傳定應用仿射變換後的輸出圖像的範圍和解析度 (並不是一個新的影像)
再利用```B = imwarp(A,tform)```將定義的改變量套回影像中, 並輸出

```matlab
centerOutput = affineOutputView(size(fixedVolume),tform,'BoundsStyle','centerOutput');

movingRegisteredVolume = imwarp(movingVolume,tform,"bicubic",'OutputView',centerOutput);
```

Step 3: 記錄改變後的距離

```[x_out, y_out] = transformPointsForward(tform, x_in, y_in);```

x_in 和 y_in: 這裡定義原本的輸入點座標

transformPointsForward: 這個函數將這些輸入點按照仿射變換 tform 進行變換，返回變換後的點坐標

原始點座標都設定在(0,0,0), 所以存下的新座標也就是移動的距離

```matlab
[temp_x,temp_y,temp_z] = transformPointsForward(tform, 0,0,0); 
```
這裡的距離量是可以為小數點的, 單位是 pixel, 可以再依照voxel size轉換回實際的物理距離量

*note:*

出圖時可以利用```medfilt1(x_loc,windowsize)```濾波器的方式, 設定windowsize的大小, 將曲線平均變得平滑, 看出整體的差異

# apply_raw.m

存下的```trace.mat```可以套用到不同的影像上, 利用重新製作轉換矩陣的方式, 套在不同的影像中

```matlab
T = [1,0,0,0;0,1,0,0;0,0,1,0;x_loc(f),y_loc(f),z_loc(f),1];

tform = affine3d(T);
```
