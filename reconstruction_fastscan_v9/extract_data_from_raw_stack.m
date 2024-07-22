function extract_data_from_raw_stack(filename,xyt,xyz,output_path)
% extract data from raw 4D stack

%-------------------------------------------------------------------------
%Kai-Chun Jhan - ver 1.0 2022-03-21
%Data Analysis and Interpretation Laboratory,NTHU
%Prof, Shun-Chi Wu
%-------------------------------------------------------------------------

%-------------------------------------------------------------------------
%Wun-Ci Chen - ver 1.1 2022-06-21
%Data Analysis and Interpretation Laboratory,NTHU
%Prof, Shun-Chi Wu
%-------------------------------------------------------------------------
%%
%---------------------------------------------------------------------
%param
%filename:the 4D stack of the raw data(generated from Sorting_3D_20200817_test.m), 
%           please input the file name as string.
%xyt:output x-y-t stack in ./ch1_out_xyt dir, using 1(save), 0(don't save)
%xyz:output x-y-z stack in ./ch1_out_xyz dir, using 1(save), 0(don't save)
%---------------------------------------------------------------------
%     xyt = 1;
%     xyz = 1;
%     filename = "0329_reslice.mat";
disp("extract_data_from_raw_stack is running");
    data = filename; %from "reslice"
    xyzt_raw_data = data;
    if xyt
        xyt_output_folder = output_path+"/ch1_out_xyt/";
        if ~exist(xyt_output_folder, 'dir')
           mkdir(xyt_output_folder);
        end
        for z = 1:size(xyzt_raw_data,3)
            temp_img = uint16(squeeze(xyzt_raw_data(:,:,z,1)));
            imwrite(temp_img,xyt_output_folder+"z_"+num2str(z)+".tiff")
            for t = 2:size(xyzt_raw_data,4)
                temp_img = uint16(squeeze(xyzt_raw_data(:,:,z,t)));
                imwrite(temp_img,xyt_output_folder+"z_"+num2str(z)+".tiff","WriteMode","append")
            end
        end
    end

    if xyz
        xyz_output_folder = output_path+"/ch1_out_xyz/";
        if ~exist(xyz_output_folder, 'dir')
           mkdir(xyz_output_folder);
        end
        for t = 1:size(xyzt_raw_data,4)
            temp_img = uint16(squeeze(xyzt_raw_data(:,:,1,t)));
            imwrite(temp_img,xyz_output_folder+"VOL_"+num2str(t)+".tiff")
            for z = 2:size(xyzt_raw_data,3)
                temp_img = uint16(squeeze(xyzt_raw_data(:,:,z,t)));
                imwrite(temp_img,xyz_output_folder+"VOL_"+num2str(t)+".tiff","WriteMode","append")
            end
        end
    end
disp("extract_data_from_raw_stack is done");
end
