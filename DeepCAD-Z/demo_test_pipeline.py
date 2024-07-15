"""
This file will help to demonstrate pipeline for testing microscopy data using the DeepCAD-Z algorithm.
The demo shows how to construct the params and call the relevant functions for testing DeepCAD-Z network.
See inside for details.

This repository is derived from DeepCAD-RT(https://github.com/cabooster/DeepCAD-RT)
DeepCAD-Z ver1. 2023  Kai-Chun Jhan
"""
from deepcad.test_collection import testing_class
from deepcad.utils import get_first_filename

# %% Select file(s) to be processed (download if not present)

datasets_path = f'datasets/29-4-2-4move2'  # folder containing tif files for testing
denoise_model = f'29-4-2-4move2_202406221747'  # A folder containing pth models to be tested

# %% First setup some parameters for testing
GPU = '0'
num_workers = 0                       # if you use Windows system, set this to 0.

# %% Setup some parameters for result visualization during testing period (optional)


test_dict = {
    # dataset dependent parameters
    'scale_factor': 1,                   # the factor for image intensity scaling
    'datasets_path': datasets_path,
    'pth_dir': './pth',                 # pth file root path
    'denoise_model' : denoise_model,
    'output_dir' : './results',         # result file root path
    # network related parameters
    'fmap': 16,                          # the number of feature maps
    'GPU': GPU,
    'num_workers': num_workers,

}
# %%% Testing preparation
# first we create a testing class object with the specified parameters
tc = testing_class(test_dict)
# start the testing process
tc.run()
