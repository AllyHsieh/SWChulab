"""
This file will demonstrate pipeline for training microscopy data using the DeepCAD-RT algorithm.
The demo shows how to construct the params and call the relevant functions for training DeepCAD-RT network.
The demo will automatically download tif file for demo training.
See inside for details.

* This demo is also available as a jupyter notebook (see demo_train_pipeline.ipynb) and Colab notebook (see
DeepCAD_RT_demo_colab.ipynb)

More information can be found in the companion paper.
"""

from deepcad.train_collection import training_class
from deepcad.utils import get_first_filename



# %% Select file(s) to be processed

datasets_path = f'datasets/29_4_2_4'  # folder containing tif files for training

# %% First setup some parameters for training
n_epochs = 10               # the number of training epochs
GPU = '0'                   # the index of GPU used for computation (e.g. '0', '0,1', '0,1,2')
train_datasets_size = 31  # dataset size for training (the number of patches)
patch_x =  64         # the width and height of 3D patches
patch_y =  128
patch_t = 30               # the time dimension of 3D patches
overlap_factor = 0       # the overlap factor between two adjacent patches
pth_dir = './pth'           # pth file and visualization result file path
num_workers = 0             # if you use Windows system, set this to 0.

# %% Setup some parameters for result visualization during training period (optional)


train_dict = {
    # dataset dependent parameters
    'patch_x': patch_x,
    'patch_y': patch_y,
    'patch_t': patch_t,
    'overlap_factor':overlap_factor,
    'scale_factor': 1,                  # the factor for image intensity scaling
    'select_img_num': 100000,           # select the number of images used for training (use all frames by default)
    'train_datasets_size': train_datasets_size,
    'datasets_path': datasets_path,
    'pth_dir': pth_dir,
    # network related parameters
    'n_epochs': n_epochs,
    'lr': 0.00005,                       # initial learning rate
    'b1': 0.5,                           # Adam: bata1
    'b2': 0.999,                         # Adam: bata2
    'fmap': 16,                          # the number of feature maps
    'GPU': GPU,
    'num_workers': num_workers,
}
# %%% Training preparation
# first we create a training class object with the specified parameters
tc = training_class(train_dict)
# start the training process
tc.run()
