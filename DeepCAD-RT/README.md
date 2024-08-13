

**Error Debug**
If your error shows related to "division by zero", which results from your computer is NOT able to handle the big data. Please try to smaller your patch size setting.
For example,
Your input data, each volume: 512*512*1500 (pixel)
original:  (patch_x, patch_y, patch_t) = (512, 512, 100)
try:  (patch_x, patch_y, patch_t) = (128, 128, 100)
