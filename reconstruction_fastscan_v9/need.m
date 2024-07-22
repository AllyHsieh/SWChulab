%clc; clear; close all;
%img = tiffreadVolume('F:\20231217\TAG188k25%_5s\ch1_out_xyt\z_100.tiff');
img=C;%squeeze(xyzt_raw_data(:,:,100,:));
save_fname = 'C:\Users\wunci\Desktop\231020\231020\f.tiff';
output = readtable("average.csv");
output = table2array(output);
% output = output.Var1;

%%
FOV = "500*500";
switch FOV
    case "new"
        coefficient = [0, 0, 0, 0, 0, 0];
    case "200*200"
        coefficient = [-1.8, -0.3, 3,  6, -75, 0.32];
    case "200*400"
        coefficient = [ 1.5, -0.4, 5,  6, -75, 0.36]; 
    case "100*200"
        coefficient = [ 1.8, -0.4, 5,  6, -76, 0.37]; 
    case "300*300"
        coefficient = [-0.6, -0.2, 7, 10, -75, 0.32];
    case "400*400"
        coefficient = [ 1.7, -0.3, 7,  9, -76, 0.38];
    case "500*500"
        coefficient = [ 1.2, 0.5,  3, 10, -77, 0.45];
    case "250*250"
        coefficient = [  -2, 0.1,  3,  3, -74, 0.36];
    case "test"
        coefficient = [0, 0, 0, 0, 1, 0];
end
offset = coefficient(1);
shift = coefficient(2);
edge1 = coefficient(3);
edge2 = coefficient(4);
start = coefficient(5);
gap = coefficient(6);

%%
output_y = (rescale(-output)-0.5)*2*63.5;

% figure
% plot(output_y)
% title("output")
%%
figure
imagesc(mean(img,3))
set(gca,"xtick",[],"xticklabel",[])
set(gca,"ytick",[],"yticklabel",[])
axis square
title("raw")

y_sample = [];
for y = 1:size(img,2)
    if mod(y,2)
        for x = 1:size(img,1)
            y_sample = [y_sample (x-64.5)];
        end
    else
        for x = 1:size(img,1)
            x_rev = size(img,1)-x+1;
            y_sample = [y_sample (x_rev-64.5)];
        end
    end
end

%%
f=1/256;
t=0:length(y_sample);
y_sin=sin(2*pi*f*t-pi/2);
y_sin=63.5*y_sin;

y_sin4(1:64)=(sin(2*pi*f*t(1:64)-pi/2).^4)*edge1;
y_sin4(65:128)=(sin(2*pi*f*t(65:128)-pi/2).^4)*edge2; 
shift = shift .* y_sin4(1:128)' + offset;

y_p = shift' +output_y(1:128)';
y_m = -shift' +output_y(1:128)';

% figure
% plot(shift)
% title("shift")
% 
% shift_output = [y_p flip(y_m)];
% figure
% hold on
% plot(y_sample(1:256),"-o","MarkerSize",3);
% plot(shift_output,"-s","MarkerSize",3)
% set(gca,"xtick",[],"xticklabel",[])
% set(gca,"ytick",[],"yticklabel",[])
% legend("expect","reality")
% legend("Location","northeast","FontSize",12)
% xlabel("time (msec)")
% ylabel("position of y (um)")
% title("Focus Position, FOV=200*200(um)")
% set(gca,"FontSize",12)

% title("real output")

img_resample = zeros(size(img));
for z = 1:size(img,3)
    for y = 1:size(img,2)
        if mod(y,2)
            img_resample(:,y,z) = interp1(y_m,double(img(:,y,z)),y_sample(1:128));
        else
            img_resample(:,y,z) = interp1(y_p,double(img(:,y,z)),y_sample(1:128));
        end
    end
end

% figure
% imagesc(img_resample)
% set(gca,"xtick",[],"xticklabel",[])
% set(gca,"ytick",[],"yticklabel",[])
% axis square
% title(str);

new = zeros(size(img));
newline = [start];
interval = 1;
for y = 1:127
    interval = interval + gap/127;
    newline = [newline newline(end)+interval];
end 

for z = 1:size(img,3)
    for y = 1:size(img,2)
        if mod(y,2)
            new(:,y,z) = interp1(y_sample(1:128),double(img_resample(:,y,z)),newline);
        else
            new(:,y,z) = interp1(y_sample(1:128),double(img_resample(:,y,z)),newline);
        end
    end
end
reconstructed_data = new;

% figure
% hold on
% plot(y_sample(1:128))
% plot(newline)
% legend("original","new")
% legend("Location","southeast")

figure()
imagesc(mean(new,3))
set(gca,"xtick",[],"xticklabel",[])
set(gca,"ytick",[],"yticklabel",[])
% set(gcf,'InvertHardCopy','off')
daspect([1 1 1])
title("result");


%% save the fastscan
%{
for i = 1:size(new,3)
     if i == 1
        imwrite(uint16(new(:,:,i)),save_fname)
    else
        imwrite(uint16(new(:,:,i)),save_fname,'WriteMode','append');
    end
end
%}
