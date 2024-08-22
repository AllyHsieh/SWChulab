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
fixedVolume = tiffreadVolume(fullfile(path, "VOL_2"+suffix+".tif")); %讀入黨案
```

```matlab
movingVolume = tiffreadVolume(fullfile(path, "VOL_"+num2str(i)+suffix+".tif")); %讀入黨案
```

```matlab
tform = imregtform(movingVolume,fixedVolume,"translation",optimizer,metric);

centerOutput = affineOutputView(size(fixedVolume),tform,'BoundsStyle','centerOutput');

movingRegisteredVolume = imwarp(movingVolume,tform,"bicubic",'OutputView',centerOutput);

[temp_x,temp_y,temp_z] = transformPointsForward(tform, 0,0,0);
```
