**note**
data size is the t dimension of the stack(xyt).

**Error Debug**

If your error shows related to "division by zero", which results from your computer is NOT able to handle the big data. Please try to smaller your patch size setting, and you can try to increase the "overlap factor", to increase the patch number (訓練時是依照patch數量丟進去model裡面,愈多patch就會train愈多次).

For example,

Your input data, each volume: 512x512x1500 (pixel)

original:  (patch_x, patch_y, patch_t) = (512, 512, 100)

try:  (patch_x, patch_y, patch_t) = (128, 128, 100)
