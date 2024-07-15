after training, the models will be saved in this folder.

if your select 'show_loss_record = True' in 'demo_train_pipeline.py', there will be three images to show the curve of loss function, MAE, MS.

For example,

Loss function:

![Example Loss function](https://github.com/AllyHsieh/SWChulab/edit/main/DeepCAD-Z/pth/example_img/loss.png)

MAE curve:

![Example MAE curve](https://github.com/AllyHsieh/SWChulab/edit/main/DeepCAD-Z/pth/example_img/mae.png)

MSE curve:

![Example MSE curve](https://github.com/AllyHsieh/SWChulab/edit/main/DeepCAD-Z/pth/example_img/mse.png)

From the figures, we know that after 5 epoches, the model hasn't converge yet. You should increase the iterations (epoches) or volumetric images.
