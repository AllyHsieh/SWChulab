% Specify the full path to your TDMS file
tdmsFileName = 'H:\Yintzu\20220524\pcp2-GCamP6f HWP306 PMT0.8V dt0.005 avg3 0-100um_StackImage.tdms';

% Read data from TDMS file
data = tdmsread(tdmsFileName);
img=table2array(data{1,1});
img=reshape(img,[512,512,102]);
image=(rot90(img, 1));

%% save tiff
path="H:\Yintzu\20220524\";
fname = [path+"20220524_pcp2_GCaMP6f_mouse_avg3.tiff"];
I0L = uint16(image);
iwrite = true;
for n = 1:size(I0L,3)
    % Make an RGB image:
    i_img = I0L(:,:,n);
    
    % Generate your tiff stack:
    if n == 1
        % First slice:
        imwrite(i_img,fname)
    else
        % Subsequent slices:
        imwrite(i_img,fname,'WriteMode','append');
    end
end
