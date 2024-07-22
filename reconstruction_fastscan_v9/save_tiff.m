%% save tiff
path='E:\Alice\mouse slide\20240424\fast\fast\TAGonold25xNA1.05_mouse5_HWP308_PMT0.80_dt0.004_mag1_z-101_15%\4_4_64_128';
image = timeproj;
fname = [path+"mouseslide_20240424_timeproj15%.tiff"];
% save tiff
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