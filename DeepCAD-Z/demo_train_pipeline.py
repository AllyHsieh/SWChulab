"""
This file will demonstrate pipeline for training microscopy data using the DeepCAD-Z algorithm.
The demo shows how to construct the params and call the relevant functions for training DeepCAD-Z network.
See inside for details.

This repository is derived from DeepCAD-RT(https://github.com/cabooster/DeepCAD-RT)
DeepCAD-Z ver1. 2023  Kai-Chun Jhan
"""
from deepcad.train_collection import training_class
from deepcad.utils import get_first_filename

# %% Select file(s) to be processed

datasets_path = f'datasets/gcamp8_5-z2'  # folder containing tif files for training

# %% First setup some parameters for training
n_epochs = 10               # the number of training epochs
GPU = '0'                   # the index of GPU used for computation (e.g. '0', '0,1', '0,1,2')
pth_dir = './pth'           # pth file and visualization result file path
num_workers = 0             # if you use Windows system, set this to 0.
show_loss_record = True

# %% Setup some parameters for result visualization during training period (optional)

train_dict = {
    # dataset dependent parameters
    'scale_factor': 1,                  # the factor for image intensity scaling
    'select_img_num': 100000,           # select the number of images used for training (use all frames by default)
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
    'show_loss_record': show_loss_record
}
# %%% Training preparation
# first we create a training class object with the specified parameters
tc = training_class(train_dict)
# start the training process
tc.run()
