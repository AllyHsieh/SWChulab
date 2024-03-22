# DeepCAD-Z 
-NTHU DAIL version

## Pytorch code

### Our environment 

* Windows 
* Python 3.6
* Pytorch 1.8.0
* NVIDIA GPU (GeForce RTX 3060) + CUDA (11.1)

How to install CUDA/Cudnn
https://medium.com/geekculture/install-cuda-and-cudnn-on-windows-linux-52d1501a8805

### Environment configuration

1. Create a virtual environment and install PyTorch. In the 3rd step, please select the correct Pytorch version that matches your CUDA version from [https://pytorch.org/get-started/previous-versions/](https://pytorch.org/get-started/previous-versions/). 

   ```
   $ conda create -n deepcadz python=3.6
   $ conda activate deepcadz
   $ pip install torch==1.8.0+cu111 torchvision==0.9.0+cu111 torchaudio==0.8.0 -f https://download.pytorch.org/whl/torch_stable.html
   ```
      
      *Note:  `pip install` command is required for Pytorch installation.*
  
### Demos

To try out the Python code, please activate the `deepcadz` environment first:

```
$ source activate deepcadz
```

**Example training**

To train a DeepCAD-Z model, we recommend starting with the demo script `demo_train_pipeline.py`. One demo dataset had been exisdted in the `datasets` folder. Use your own data by changing the training parameter `datasets_path`. 

```
python demo_train_pipeline.py
```

**Example testing**

To test the denoising performance with pre-trained models, you can run the demo script `demo_test_pipeline.py` .  You can change the dataset and the model by changing the parameters `datasets_path` and `denoise_model`.

```
python demo_test_pipeline.py
```

**Param explanation**

Neet to notice these block!!!

###### demo_train_pipeline.py

```python=18
# %% Select file(s) to be processed

datasets_path = f'datasets/29_4_2_4'  # folder containing tif files for training

# %% First setup some parameters for training
n_epochs = 5               # the number of training epochs
GPU = '0'                   # the index of GPU used for computation (e.g. '0', '0,1', '0,1,2')
train_datasets_size = 31  # dataset size for training (the number of patches)
patch_x =  64         # the width and height of 3D patches
patch_y =  128
patch_t = 30               # the time dimension of 3D patches
overlap_factor = 0       # the overlap factor between two adjacent patches
pth_dir = './pth'           # pth file and visualization result file path
num_workers = 0             # if you use Windows system, set this to 0.
```
note : `train_datasets_size` must > 2*`patch_t`, `patch_xy` neet to smaller than data width/height


###### demo_test_pipeline.py

```python=16
# %% Select file(s) to be processed (download if not present)

datasets_path = f'datasets/29_4_2_4'  # folder containing tif files for testing
denoise_model = f'29_4_2_4_202310260949'  # A folder containing pth models to be tested

# %% First setup some parameters for testing
test_datasize = 31  # dataset size for training (the number of patches)
GPU = '0'
patch_x =  64            # the width and height of 3D patches
patch_y =  128
patch_t = 30 
                       # the time dimension of 3D patches
overlap_factor = 0                  # the overlap factor between two adjacent patches
num_workers = 0                       # if you use Windows system, set this to 0.   
```
note : `train_datasets_size` must > 2*`patch_t`, `patch_xy` neet to smaller than data width/height


(reference https://github.com/cabooster/DeepCAD-RT/blob/main/README.md)