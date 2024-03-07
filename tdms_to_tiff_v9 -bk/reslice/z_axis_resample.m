function z_axis_resample(method,N)
% Resample z axis feature

%-------------------------------------------------------------------------
%Kai-Chun Jhan - ver 1 2022-03-21
%Data Analysis and Interpretation Laboratory,NTHU
%Prof, Shun-Chi Wu
%-------------------------------------------------------------------------

%-------------------------------------------------------------------------
%Wun-Ci Chen - ver 2 2022-06-21
%Data Analysis and Interpretation Laboratory,NTHU
%Prof, Shun-Chi Wu
%-------------------------------------------------------------------------
%%
z_physical_distance = 62; % um
sample_each_voxel_fs = 265*2;
dt = 1/sample_each_voxel_fs;
time = 0:dt:1-dt;
FC = 1;
y = sin(2*pi*FC*time);
y = y*z_physical_distance/2+z_physical_distance/2;

lowerB = round(sample_each_voxel_fs/4);
upperB = lowerB + sample_each_voxel_fs/2 - 1;
half_y = y(lowerB:upperB);
half_time = time(lowerB:upperB);
half_y_diff = diff(half_y(end:-1:1));

if method == "z"
    stack =  N; % 每z高度疊成1個slice
    Slice = 0:stack:z_physical_distance-stack;
    Slice = Slice+1;

%     figure
%     scatter(time,y)
%     hold on
%     for index = 1:length(Slice)
%         yline(Slice(index),"--")
%     end
%     xlabel("one cycle of z-axis sample ")
%     ylabel('field of view(um)')
    %%
    temp = [];
    slice_mean_resolution = [];
    slice_image_count = [];
    pre = z_physical_distance + 0.01;
    post = Slice(end-1);
    for iter = 1:length(Slice)
        post = Slice(end-iter+1)-1;
        temp = half_y_diff(half_y(2:end)<pre & half_y(2:end)>=post);
        temp_mean_resolution = mean(temp);
        slice_mean_resolution = [slice_mean_resolution temp_mean_resolution];
        slice_image_count = [slice_image_count sum(half_y(1:end)<pre & half_y(1:end)>=post)];
        pre = post;
    end
    slice_reverse = Slice(end:-1:1);
%     figure
%     scatter(half_time,half_y)
%     hold on
%     text(0.4,slice_reverse(1)+1,"mean resolution = "+ ...
%             num2str(round(slice_mean_resolution(1),2))+"    image count = "+num2str(slice_image_count(1)))
%     for index = 1:length(Slice)
%         yline(slice_reverse(index),"--")
%         if ~mod(index,5)
%             text(0.4,slice_reverse(index)+1,"mean resolution = "+ ...
%             num2str(round(slice_mean_resolution(index),2))+"    image count = "+num2str(slice_image_count(index)))
%     
%         end
%     end
%     xlabel("half cycle of z-axis sample ")
%     ylabel('field of view(um)')
    %%
%     figure
%     dy = downsample(half_y,5);
%     for index = 1:size(dy,2)
%         scatter(0.5,dy(index),"red")
%         hold on
%     end
%     yline(slice_reverse)
elseif method == "layer"
    N = N;  %每N個layer疊成一個slice
    Slice = 0:N:length(half_y);
    Slice = Slice+1;
    if mod(length(half_y),N) == 0
        Slice(end) = [];
    end
%     figure
%     scatter(time,y)
%     hold on
%     for iter = 1:length(Slice)-1
%         index =  Slice(iter);
%         yline(half_y(index),"--")
%     end
%     xlabel("one cycle of z-axis sample ")
%     ylabel('field of view(um)')
    %%
    temp = [];
    slice_mean_resolution = [];
    slice_image_count = [];
    pre = 1;
    post = 0;
    for iter = 1:length(Slice)
        post = pre+N-1;
        if post>length(half_y_diff)
            temp = half_y_diff(pre:end);
            half_y_diff(pre:end);
        else
            temp = half_y_diff(pre:post);
            half_y_diff(pre:post);
        end
        temp_mean_resolution = mean(temp);
        slice_mean_resolution = [slice_mean_resolution temp_mean_resolution];
        if iter == length(Slice)
            slice_image_count = [slice_image_count size(half_y,2)-pre+1];
        else
            slice_image_count = [slice_image_count N];
            pre = post+1;
        end
    end
    slice_reverse = Slice(end:-1:1);
%     figure
%     scatter(half_time,half_y);
%     hold on
%     text(0.4,half_y(1)+1,"mean resolution = "+ ...
%             num2str(round(slice_mean_resolution(1),2))+"    image count = "+num2str(slice_image_count(1)))
%     for iter = 1:length(Slice)
%         index = Slice(iter)
%         yline(half_y(index),"--")
%         if ~mod(iter,5)
%             text(0.4,half_y(index)+1,"mean resolution = "+ ...
%             num2str(round(slice_mean_resolution(iter),2))+"    image count = "+num2str(slice_image_count(iter)))
%     
%         end
%     end
%     xlabel("half cycle of z-axis sample ")
%     ylabel('field of view(um)')
    %%
%     figure
%     dy = downsample(half_y,5);
%     for index = 1:size(dy,2)
%         scatter(0.5,dy(index),"red")
%         hold on
%     end
%     for iter = 1:length(Slice)
%         index = Slice(iter);
%         yline(half_y(index))
%     end
end
save(".\reslice\"+"reslice_feature.mat","half_y","Slice","slice_image_count")
end
