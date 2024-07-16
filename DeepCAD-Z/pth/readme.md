after training, the models will be saved in this folder.

if your select 'show_loss_record = True' in 'demo_train_pipeline.py', there will be three images to show the curve of loss function, MAE, MS.

For example,

Loss function:

![Example Loss function](https://github.com/AllyHsieh/SWChulab/edit/main/DeepCAD-Z/pth/example/loss.png)

MAE curve:

![Example MAE curve](https://github.com/AllyHsieh/SWChulab/edit/main/DeepCAD-Z/pth/example/mae.png)

MSE curve:

![Example MSE curve](https://github.com/AllyHsieh/SWChulab/edit/main/DeepCAD-Z/pth/example/mse.png)

From these figures, we know that after 20 epoches, the model has converge, and from MSE curve, which it has already overfitting.

You should decrease the iterations (epoches) of training.
