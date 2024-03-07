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
for y = 1:size(up,2)
    img(:,2*y) = up(:,y);
    img(:,2*y-1) = down(:,y);
end

output = readtable("average.csv");
output = output.Var1;

switch FOV
    case "100*200"
        coefficient = [1.8, -0.4, 5,  6, -76, 0.37];
    case "200*200"
        coefficient = [-1.8, -0.3, 3,  6, -75, 0.32];
    case "250*250"
        coefficient = [-1.1, -0.3, 3,  10, -77, 0.36];
    case "200*400"
        coefficient = [3.8, -0.3, 10,  10, -74, 0.28];
    case "300*300"
        coefficient = [-0.6, -0.2, 7, 10, -69,   0.16];
    case "400*400"
        coefficient = [ 1.7, -0.3, 7,  9, -76,   0.38 ];
    case "500*500"
        coefficient = [ 1.2, 0.5, 3,  10, -77,   0.45 ];
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

%%
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
        img_resample(:,y) = interp1(y_m,double(img(:,y)),y_sample(1:128));
    else
        img_resample(:,y) = interp1(y_p,double(img(:,y)),y_sample(1:128));
    end
end

% figure
% imagesc(img_resample)
% title(str);

%new = zeros(128);
new=zeros(size(img));
newline = [start];
interval = 1;
for y = 1:127
    interval = interval + gap/127;
    newline = [newline newline(end)+interval];
end 

for y = 1:size(img,2)
    if mod(y,2)
        new(:,y) = interp1(y_sample(1:128),double(img_resample(:,y)),newline);
    else
        new(:,y) = interp1(y_sample(1:128),double(img_resample(:,y)),newline);
    end
end
reconstructed_data = new;

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
