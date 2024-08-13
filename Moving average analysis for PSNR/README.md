# Evaluation of image quality

SNR and PSNR are two metrics commonly used to assess the quality of images. SNR focuses on the ratio of signal to noise, while PSNR focuses on the amount of distortion in the image. They are often expre ssed in decibels (dB), which facilitates easy comparison across different imaging systems. Although both metrics evaluate the relationship between the signal and noise, they differ in their calculations and applications.

**SNR**

SNR measures the ratio of the measured signal strength to the overall measured noise intensity at each pixel. It provides a ge neral indication of how much the signal stands out from the noise, reflecting the clarity of the signal relative to the background noise level.

$$SNR=10log_10(\frac{I-bg}{\sqrt(I-bg+\sigma^2)})$$

where I is the average intensity of the signal in the image, bg represents the average intensity of the region without signal, i.e. background region. $$\sigma$$ is the standard deviation of background intensity. dB scale uses a logarithmic representation.

Notably, we select different ROI to define signal and background region and do the average calcualtion:

<img src="img/SNR.png" alt="PCC" width="500" >

*reference:*

Y. Zhao, M. Zhang, W. Zhang, Y. Zhou, L. Chen, Q. Liu, P. Wang, R. Chen, X. Duan, F. Chen, H. Deng, Y. Wei, P. Fei, Y. H. Zhang, Nat Methods 2022, 19(3), 359-369, https://doi.org/10.1038/s41592-022-01395-5.

Peak Signal to Noise Ratio (PSNR)
10
On the other hand, PSNR is specifically used to
e valuate how much the quality of
the signal is affected by distortion . It calculates t he ratio between the maximum intensity
of the image and the power of the noise affecting the image. Therefore, it needs a
noise free image as ground truth (or to calculate the MSE , which quantifies the
average squared difference between two imag es. Smaller MSE suggests less disparity
between the images, indicating lower noise. Higher PSNR values correspond to lower
levels of noise or distortion in the image, indicating higher image quality or fidelity.
where MAX

**PSNR**
  

