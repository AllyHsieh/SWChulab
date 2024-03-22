"""
This file will help to demonstrate pipeline for testing microscopy data using the DeepCAD-RT algorithm.
The demo shows how to construct the params and call the relevant functions for testing DeepCAD-RT network.
The demo will automatically download tif file and corresponding model file for demo testing.
See inside for details.

* This demo is also available as a jupyter notebook (see demo_test_pipeline.ipynb) and Colab notebook (see
DeepCAD_RT_demo_colab.ipynb)

More information can be found in the companion paper.
"""
from deepcad.test_collection import testing_class
from deepcad.utils import get_first_filename


# %% Select file(s) to be processed (download if not present)

datasets_path = f'datasets/29_4_2_4'  # folder containing tif files for testing
denoise_model = f'29_4_2_4_202310260959'  # A folder containing pth models to be tested

# %% First setup some parameters for testing
test_datasize = 31  # dataset size for training (the number of patches)
GPU = '0'
patch_x =  64            # the width and height of 3D patches
patch_y =  128
patch_t = 30 
                       # the time dimension of 3D patches
overlap_factor = 0                  # the overlap factor between two adjacent patches
num_workers = 0                       # if you use Windows system, set this to 0.

# %% Setup some parameters for result visualization during testing period (optional)


test_dict = {
    # dataset dependent parameters
    'patch_x': patch_x,
    'patch_y': patch_y,
    'patch_t': patch_t,
    'overlap_factor':overlap_factor,
    'scale_factor': 1,                   # the factor for image intensity scaling
    'test_datasize': test_datasize,
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
