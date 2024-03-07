function xyzt_reslice_timecorr = reslice(xyzt_raw_data_timecorr,save_type)
% Reslice z axis feature

%-------------------------------------------------------------------------
%Kai-Chun Jhan - ver 1 2022-03-21
%Data Analysis and Interpretation Laboratory,NTHU
%Prof, Shun-Chi Wu
%-------------------------------------------------------------------------

%-------------------------------------------------------------------------
%Wun_Ci Chen - ver 2 2022-06-21
%Data Analysis and Interpretation Laboratory,NTHU
%Prof, Shun-Chi Wu
%-------------------------------------------------------------------------
%%
disp("reslice is running");
load("reslice_feature.mat");
%%
xyzt_reslice_timecorr = zeros(size(xyzt_raw_data_timecorr,1),size(xyzt_raw_data_timecorr,2),size(Slice,2),size(xyzt_raw_data_timecorr,4));

if save_type=="interpolate"
    pre = 0;
    for z_index = 1:size(xyzt_reslice_timecorr,3)
        [pre+1 pre+slice_image_count(z_index)];
        temp_interpolate = 1-abs(half_y(pre+1:pre+slice_image_count(z_index))-Slice(z_index));
        temp_z = zeros(size(xyzt_raw_data_timecorr,1),size(xyzt_raw_data_timecorr,2),1,size(xyzt_raw_data_timecorr,4));
        for interpolate_z = 1:length(temp_interpolate)
            temp_z = temp_z+temp_interpolate(interpolate_z)*xyzt_raw_data_timecorr(:,:,pre+interpolate_z,:);
        end
        xyzt_reslice_timecorr(:,:,z_index,:) = temp_z/sum(temp_interpolate);
        pre = pre+slice_image_count(z_index);
    end
elseif save_type=="mean"
    pre = 0;
    for z_index = 1:size(xyzt_reslice_timecorr,3)
        [pre+1 pre+slice_image_count(z_index)];
        xyzt_reslice_timecorr(:,:,z_index,:) = mean(xyzt_raw_data_timecorr(:,:,pre+1:pre+slice_image_count(z_index),:),3);
        pre = pre+slice_image_count(z_index);
    end
end
disp("reslice is done");
% % figure
% % plot(squeeze(mean(xyzt_reslice_timecorr,[1 2 3])))
% % hold on
% % plot(squeeze(mean(xyzt_raw_timecorr,[1 2 3])))
% disp("saving....")
% save(save_filename,"xyzt_reslice_timecorr","-v7.3")
end
