## Pearson Correlation Coefficient (PCC)

The PCC is used to assess the linear relationship between two variables. It is denoted by the symbol r and ranges from 1 to 1, which provides valuable insights into the degree of association between two sets of data.

The formula to calculate the PCC (r) between two variables of X and Y with n data points,

$$r=\frac{\Sigma^n_i(X_i-\bar{X})(Y_i-\bar{XY})} {\sqrt{\Sigma^n_i(X-\bar{X})^2} \sqrt{\Sigma^n_i(Y-\bar{Y})^2)}}$$

$$\bar{X}$$ and $$\bar{Y}$$ are the average of variables respectively.

As r = 1 indicates a perfect positive linear relationship, meaning that as one variable increases, the other variable increases proportionally. 

As r = 1 indicates a perfect negative linear relationship, meaning that as one variable increases, the other variable decreases proportionally. 

As r = 0 indicates no linear relationship b etween the variables.

<img src="img/PCC.jpg" alt="PCC" width="500" >

We utilize the PCC for various image comparison tasks, for example, determining the DOF of the TAG lens by analyzing the correlation contour maps of low and high speed scanning images to find the best corresponding layer.

<img src="img/mouseslice_corr.jpg" alt="correlation analysis" width="400" >

Or in image registration, PCC is used as a similarity metric to measure the alignment accuracy between two images. (As [3d motion correction](3d_motioncorrection)) 

**code**

When you analyze the correlation map, you should notice:

1. To increase fast scan image quality by doing time average, which increase the PCC value while comparing with slow scan image.

```matlab
fast=timeproj(10:115,17:116,:); % 10s or 10 volumes projection
```

2. There is concentric circle effect at different depth of slow scan image, which result in the FOV between fast and slow scan image is a bit different. Different FOV is difficult to find the best corresponding layer, and the PCC value would be low. (r>0.7 is better)

```matlab
start=10;final=40;
lowset=[30,40,20,20];
upset=[65,70,85,70];
```

We need to crop the slow scan image to fit the fast scan. Find the first and last layer (or 1/2, 1/3, at least two layer) corresponding to each scanning mode, then do the interpolation for interval layers.

*note:*

*It is better to crop slow scan and do the resize to fit fast scan, because the digital resolution of slow scan image is better than fast scan image.*

3. Find the maximun value at the first and layer layer of fast scan, and you can correspond them to slow scan with physical distance, i.e. DOF.

**Conclusion**

After at least 5 times test, we find that the practical DOF value is quite similar to theoritical value (error < 10%).  
