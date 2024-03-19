%% save tiff
path='E:\20240120\38D\';
fname = [path+"timeproj.tiff"];
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
