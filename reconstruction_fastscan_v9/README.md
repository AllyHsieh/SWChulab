# Reconstruction of high-speed scanning volumetric images

Following is the steps of reconstruction:

1. Sorting 3D image from 2D tiff

2. Calibration of the edges result from galvo accelration

3. Time correction for voxel dependent

4. Reslice in z direction into layer/micrometer unit

Before starting, please check the parameters for calibration of y-axis:

**previousreconstruct_checkyaxisrescale.m**

Section1: 排列10個時間點的體積影像,並且做time projection,以提升影像品質,方便進行對照

Section2: Adjust parameters

先確定有加入\correct_yaxis\的資料夾

```matlab
addpath('C:\Users\714\Yintzu\tdms_to_tiff_v9 -bk\correct_yaxis\')
```


