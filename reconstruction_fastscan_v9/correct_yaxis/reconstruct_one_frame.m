function reconstructed_data = reconstruct_one_frame(up,down,FOV)
% Reconstruction of TAG lens data

%-------------------------------------------------------------------------
%Ting-Yi Kuo - ver 1.0 2022-01-24
%Data Analysis and Interpretation Laboratory,NTHU
%Prof, Shun-Chi Wu
%-------------------------------------------------------------------------

%-------------------------------------------------------------------------
%Kai-Chun Jhan - ver 1.1 2022-02-10
%Data Analysis and Interpretation Laboratory,NTHU
%Prof, Shun-Chi Wu
%-change as function script
%-------------------------------------------------------------------------

%-------------------------------------------------------------------------
%Kai-Chun Jhan - ver 2 2022-02-17
%Data Analysis and Interpretation Laboratory,NTHU
%Prof, Shun-Chi Wu
%-change as function script, using for only one frame reconstruction
%-------------------------------------------------------------------------

%-------------------------------------------------------------------------
%Kai-Chun Jhan - ver 2 2022-03-10
%Data Analysis and Interpretation Laboratory,NTHU
%Prof, Shun-Chi Wu
%-add parameter about shift image
%-------------------------------------------------------------------------

%-------------------------------------------------------------------------
%Wun-Ci Chen - ver 3 2022-04-19
%Data Analysis and Interpretation Laboratory,NTHU
%Prof, Shun-Chi Wu
%-use interpolation to shift image
%-------------------------------------------------------------------------

%-------------------------------------------------------------------------
%Wun-Ci Chen - ver 4 2022-09-01
%Data Analysis and Interpretation Laboratory,NTHU
%Prof, Shun-Chi Wu
%-delete correlation
%-------------------------------------------------------------------------
%%
img = zeros(size(up,1),size(up,2)*2);
%for y = 1:size(up,2)
%    img(:,2*y) = up(:,y);
%    img(:,2*y-1) = down(:,y);
%end
img(:,1:2:end)=up;
img(:,2:2:end)=down;

%img=imresize(img,2);
output = readtable("average.csv");
output = output.Var1;

% fix error from Galvo!
switch FOV
    case "700*700_15%_mouse_0708"
        coefficient = [ 0.1, -0.1,  10,  10, -75, 0.1];
    case "250*250GRIN(040724GRIN)"
        coefficient = [  0, 0,  1,  1, -68, 0.32];
    case "354*354mouse_22hz"
        coefficient = [ 0, -0.2, 10, 10, -63, 0];
    case "354*354mouse"
        coefficient = [ 0, -0.2, 7, 10, -75, 0.32];
    case "400*400FLB(0529)"
        coefficient =[ 3.3, -1.4,  2, 2, -70, 0.2];
    case "400*400mouse(052925%)"
        coefficient = [ 3, -0.2, 8, 8, -67, 0.1];
    case "400*400mouse(052915%)"
         coefficient = [ 3.6, -0.1, 8, 8, -66, 0.1];   
    case "400*400mouse(0529)"
        coefficient =[ 3.6, -1.4,  2, 2, -70, 0.2];
    case "500*500GRIN(240502)"
        coefficient = [ 3.5, -1.5,  2, 2, -70, 0.2]; 
    case "500*500GRIN2(240502)"
        coefficient = [ 3.4, -0.8, 5, 3, -69, 0.2];
    case "500*500GRIN2(240626)"
        coefficient = [ 3.4, -3.8, 1, 1, -69, 0.2];
    case "250*500FLB"
        coefficient = [ 3.2, -0.16,  12, 15, -69, 0.3];
    case "250*250FLB"
        coefficient = [ 0.4, -0.6,  2.3,  3, -105, 2.2];
    case "500*500FLB(240422)"
        coefficient = [ 3, -0.31,  8, 5, -69, 0.2];
    case "500*500FLB(240501)"
        coefficient = [ 3.2, -0.43, 7, 6.7, -69, 0.2];
    case "400*400mousebrain"
        coefficient = [ 4.6, -2,  2, 1.8, -69, 0.2];
    case "240424 400*400mousebrain"
        coefficient = [ 3.4, -0.8, 5, 3, -69, 0.2];
    case "400*400FLB"
        coefficient = [ 3.2, -1.1,  2.2, 1.6, -69, 0.2];
    case "500*500mousebrain"
        coefficient = [ 3, -1,  2, 2, -69, 0.2];
    case "500*500FLB"
        coefficient = [ 3, -0.5,  2, 2, -69, 0.2];
    case "500*500GRIN"
        coefficient = [  3, -0.1,  3,3, -68, 0.15];
     case "250*250GRIN"
        coefficient = [  -0, 0,  1,  1, -70, 0.16];
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
end
offset = coefficient(1); %最有效
shift = coefficient(2); %最有效
edge1 = coefficient(3);
edge2 = coefficient(4);
start = coefficient(5);
gap = coefficient(6);

%
output_y = (rescale(-output)-0.5)*2*63.5;

% figure
% plot(output_y)
% title("output")
%
% figure
% imagesc(img)
% title("raw")

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

%
f=1/256;
t=0:length(y_sample);
y_sin=sin(2*pi*f*t-pi/2);
y_sin=63.5*y_sin;

y_sin4(1:64)=(sin(2*pi*f*t(1:64)-pi/2).^4)*edge1;
y_sin4(65:128)=(sin(2*pi*f*t(65:128)-pi/2).^4)*edge2; 
shift = shift * y_sin4(1:128)' + offset;

y_p = shift' +output_y(1:128)';
y_m = -shift' +output_y(1:128)';

% figure
% plot(shift)
% title("shift")

shift_output = [y_p flip(y_m)];
% figure
% plot(shift_output)
% title("real output")

for y = 1:size(img,2)
    if mod(y,2)
        reconstructed_data(:,y) = interp1(y_m,double(img(:,y)),y_sample(1:128));
    else
        reconstructed_data(:,y) = interp1(y_p,double(img(:,y)),y_sample(1:128));
    end
end

% figure
% imagesc(img_resample)
% title(str);

if FOV ~= "new"
    new = zeros(size(img));
    newline = [start];
    interval = 1;
    for y = 1:127
        interval = interval + gap/127;
        newline = [newline newline(end)+interval];
    end 
    
    for y = 1:size(img,2)
        if mod(y,2)
            new(:,y) = interp1(y_sample(1:128),double(reconstructed_data(:,y)),newline);
        else
            new(:,y) = interp1(y_sample(1:128),double(reconstructed_data(:,y)),newline);
        end
    end
    
    reconstructed_data = new;
end
% figure
% hold on
% plot(y_sample(1:128))
% plot(newline)
% legend("original","new")
% legend("Location","southeast")

% figure
% imagesc(new)
% title("final");
end
