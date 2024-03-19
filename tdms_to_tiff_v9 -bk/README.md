# **READ ME**
## 資料夾安排
* correct_yaxis資料夾
    * Calibration of xy plane 
    * 2*matlab script
    * 1*csv
* reslice資料夾
    * Definetion of  physical z dimension
    * 2*matlab script
* time_corr資料夾
    * Time correction of single volume
    * 4*matlab script
    * 1*tif

## 執行說明
1. 首先確認資料夾安排正確
2. 執行main
    * 這個步驟會完成sorting3D、time correction、reslice，請依照需求自行調整
    * 如果生物實驗的反應時間>volume rate可以將time correction 忽視, eg: SCN experiment

## Main程式碼說明
* 修改第8、9行，輸入第一張和最後一張tiff檔的編號
* 目前為自動化挑選首/末張，定義只有*64倍數的編號可以被讀取，避免data aquisition的錯誤
```
ALL_first = 3328;
last = 12479;
```
* 修改第11行，輸入FOV大小
* FOV設定將影響 reconstrcut_one_frame.m 的 dictionary挑選
* 建議先跑 previous.m 找出最佳校正參數
```
FOV = "400*400";
```
* 修改第16、17行，輸入重建影像的方法
* 影響xy平面的排列方式
```
shift_pixel = 0;
updown_or_downup = "downup";
```
* 修改第19、20行，輸入及輸出的檔案名稱
```
s1 = 'C:\Users\NTHU_dail\108011217\chung20220722\FLB3 4 4 128 128 10s\export\'; 
s4 = 'C:\Users\NTHU_dail\108011217\chung20220722\FLB3 4 4 128 128 10s\ch1_out\';
```
* 修改第22、23行，輸入是否儲存4D stack及儲存的檔名
* 輸出為 export_out.mat
```
save_rawmat = 1;
output_rawdata_filename = "C:\Users\NTHU_dail\108011217\chung20220722\FLB3 4 4 128 128 10s\export_out.mat";
```
* 修改第34行，輸入slice裡的data處理方式
```
save_type = "interpolate";
```
* 修改第35行及第38/41行，輸入reslice的方法
* method 可以挑選z/layer
* z代表層跟層之間的間距為N_z um, depth of field 將於 z_axis_resample.m 中設定
* layer代表N_layer 張疊加在一起輸出
```
method = "z";
N_z = 5;
```
* 修改第47行，輸入儲存data(已完成time correction、reslice)的位置
```
output_path = "C:\Users\NTHU_dail\108011217\chung20220722\FLB3 4 4 128 128 10s\";
```

## 輸出資料夾說明
* ch1_out為輸出z project image之資料夾
* ch1_out_xyt為輸出x-y-t影像之資料夾
   每層z層皆會輸出一個檔案，檔案數量與z resolution相同
* ch1_out_xyz為輸出x-y-z影像之資料夾
   每個volume皆會輸出一個檔案，檔案數量與time resolution相同

## Sorting3D補充說明
* 第16行shift_pixel會影響ch1_out裡的z project image
    * shift_pixel = 0, 則會輸出最原始的影像
    * shift_pixel = 1, 表示整張圖shift 1 pixel 
* 儲存的4D stack(.mat檔)已經做完所有校正，可以和慢掃對齊
