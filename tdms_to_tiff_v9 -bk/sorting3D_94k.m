
disp('Sortin3D is running');
pixel = x_pixel/repeat; % Remember to change pixel (below also needs to change) (xpixel)
total = last-ALL_first+1;
total_vol = floor(total/pixel); % Remember to change pixel (below also needs to change)

%% All in 1(do not change)
xyzt_raw_data = zeros(y_pixel,x_pixel,z_pixel,total_vol); %adjust zigzag image
%{
for VOL = 1:total_vol

    %%%%%%%%%%%%%%%%%%%%%%% 

    %Remeber to change folder
    %destinationFolder = 'G:\202012 Bacteria obj. test\20X NA 0.5\TAG 310k 5%\FLB\TIFF\VOL1';
    %if ~exist(destinationFolder, 'dir')
    %  mkdir(destinationFolder);
    %end

    %%%%%%%%%%%%%%%%%%%%%%%
    % Read img & Save Folder
    % VOL = 2 % Volume num.
    first = ALL_first + (VOL-1)*pixel; % first img num. % Remember to change pixel

    %Remeber to change folder
    s2 = '/';
    s3 = sprintf('VOL%d', VOL);
    destinationFolder = strcat(s4,s2,s3);
    if ~exist(destinationFolder, 'dir')
       mkdir(destinationFolder);
    end
    tiffFileName = sprintf('%d.tiff', first);
    Getprofole=imread(strcat(s1,tiffFileName));
    Zpix=size(Getprofole,1);
    Ypix=size(Getprofole,2);
    last=first+pixel-1; % last img num.
    total=last-first+1; % Xpix
    %imageData=uint16(zeros(160,512,128));
    imageData=uint16(zeros(Zpix,Ypix,total));

    for k = first:last
        % Create a tiff filename, and load it into a structure called tiffData.
        tiffFileName = sprintf('%d.tiff', k);
        if exist(strcat(s1,tiffFileName), 'file')
            imageData(:,:,k-first+1) = imread(strcat(s1,tiffFileName));
        else
            fprintf('File %s does not exist.\n', tiffFileName);
        end
    end
%     
    % XY projection preview after
    for i = 1:53:265
%     i = 1
    XY = squeeze(sum(imageData(i:i+52,:,:),1)); % or imageRe
    XY = circshift(XY,[-2 0]); %%
    Max_XY = max(max(XY));
    XY = XY/53;
    
%     disp('Saving');
    up = XY(1:y_pixel*2/2,:,:);
    down = XY(y_pixel*2/2+1:y_pixel*2,:,:);
    down = flipud(down);
    switch updown_or_downup
        case "updown"
            reconstructed_data = reconstruct_one_frame_shiftpixel(up,down,shift_pixel);%call function:reconstruct_one_frame edit by Kai-Chun
        case "downup"
            reconstructed_data = reconstruct_one_frame_shiftpixel(down,up,shift_pixel);
    end
    tiffSaveName = sprintf('VOL_%dproj_%d.tiff',VOL,i);
    fullFileName = fullfile(destinationFolder, tiffSaveName); 
    imwrite(uint16(reconstructed_data),fullFileName);
    end
end
%}
%%

%edit by Kai-Chun
if save_rawmat
    str = sprintf("total VOL = %d",total_vol);
%     disp(str);
    for VOL = 1:total_vol

        %%%%%%%%%%%%%%%%%%%%%%% 
    
        %Remeber to change folder
        %destinationFolder = 'G:\202012 Bacteria obj. test\20X NA 0.5\TAG 310k 5%\FLB\TIFF\VOL1';
        %if ~exist(destinationFolder, 'dir')
        %  mkdir(destinationFolder);
        %end
    
        %%%%%%%%%%%%%%%%%%%%%%%
        % Read img & Save Folder
        % VOL = 2 % Volume num.
        first = ALL_first + (VOL-1)*pixel; % first img num. % Remember to change pixel
    
        %Remeber to change folder
        s2 = '/';
        s3 = sprintf('VOL%d', VOL);
        destinationFolder = strcat(s4,s2,s3);
        if ~exist(destinationFolder, 'dir')
           mkdir(destinationFolder);
        end
        tiffFileName = sprintf('%d.tiff', first);
        Getprofole=imread(strcat(s1,tiffFileName));
        Zpix=size(Getprofole,1);
        Ypix=size(Getprofole,2);
        last=first+pixel-1; % last img num.
        total=last-first+1; % Xpix
        %imageData=uint16(zeros(160,512,128));
        imageData=uint16(zeros(Zpix,Ypix,total));
    
        for k = first:last
            % Create a tiff filename, and load it into a structure called tiffData.
            tiffFileName = sprintf('%d.tiff', k);
            if exist(strcat(s1,tiffFileName), 'file')
                imageData(:,:,k-first+1) = imread(strcat(s1,tiffFileName));
            else
                fprintf('File %s does not exist.\n', tiffFileName);
            end
        end
        for i = 1:z_pixel
            XY = squeeze(imageData(i,:,:)); % or imageRe
            XY = circshift(XY,[-2 0]); %% 
            up = XY(1:y_pixel*2/repeat,:);
            down = XY(y_pixel*2/repeat+1:y_pixel*2,:,:);
            down = flipud(down);
            if updown_or_downup == "updown"
               reconstructed_data = reconstruct_one_frame(up,down,FOV);
            else
               reconstructed_data = reconstruct_one_frame(down,up,FOV);
            end  
            xyzt_raw_data(:,:,i,VOL) = imresize(reconstructed_data,2);
        end
%         disp(s3+" is done");
    end
    save(output_rawdata_filename,"xyzt_raw_data","-v7.3")
end
disp('Sorting3D is done');
