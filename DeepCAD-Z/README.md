# TAG-SPARK
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
   $ conda create -n tagspark python=3.6
   $ conda activate tagspark
   $ pip install torch==1.8.0+cu111 torchvision==0.9.0+cu111 torchaudio==0.8.0 -f https://download.pytorch.org/whl/torch_stable.html

   ```
      *Note:  after activate tagspark, please input all cmd in env_create.txt*
   
      *Note:  `pip install` command is required for Pytorch installation.*
  
### Demos

To try out the Python code, please activate the `tagspark` environment first:

```
$ source activate tagspark
```

**Example training**

To train a TAG-SPARK model, we recommend starting with the demo script `demo_train_pipeline.py`. One demo dataset had been exisdted in the `datasets` folder. Use your own data by changing the training parameter `datasets_path`. 

```
python demo_train_pipeline.py
```

**Example testing**

To test the denoising performance with pre-trained models, you can run the demo script `demo_test_pipeline.py` .  You can change the dataset and the model by changing the parameters `datasets_path` and `denoise_model`.

```
python demo_test_pipeline.py
```

**Param explanation**

Need to notice these block!!!

Parameters you should set:

For training: input datapath and number of epochs

For test: input datapath and model path

###### demo_train_pipeline.py

```python=18
# %% Select file(s) to be processed

datasets_path = f'datasets/29_4_2_4'  # folder containing tif files for training

# %% First setup some parameters for training
n_epochs = 5               # the number of training epochs
GPU = '0'                   # the index of GPU used for computation (e.g. '0', '0,1', '0,1,2')
pth_dir = './pth'           # pth file and visualization result file path
num_workers = 0             # if you use Windows system, set this to 0.
show_loss_record = True     # if you want to chck whether it convergent/divergent. results of MSE,MAE,Loss will be saved at pth folder, as .png
```
note : [Example for recording the loss function](DeepCAD-Z/pth)



###### demo_test_pipeline.py

```python=16
# %% Select file(s) to be processed (download if not present)

datasets_path = f'datasets/29_4_2_4'  # folder containing tif files for testing
denoise_model = f'29_4_2_4_202310260949'  # A folder containing pth models to be tested

# %% First setup some parameters for testing
GPU = '0'
num_workers = 0                       # if you use Windows system, set this to 0.   
```


(reference https://github.com/cabooster/DeepCAD-RT/blob/main/README.md)
