function reconstructed_data = reconstruct_one_frame_shiftpixel(up,down,shiftpixel)
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
%Wun-Ci Chen - ver 4 2022-09-02
%Data Analysis and Interpretation Laboratory,NTHU
%Prof, Shun-Chi Wu
%-
%-------------------------------------------------------------------------

%%
%up: even, down: odd
img = zeros(size(up,1),size(up,2)*2);
for y = 1:size(up,2)
    img(:,2*y) = up(:,y);
    img(:,2*y-1) = down(:,y);
end

output = readtable("average.csv");
output = output.Var1;

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

y_p = shiftpixel +output_y(1:128)';
y_m = -shiftpixel +output_y(1:128)';

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
reconstructed_data = img_resample;

% figure
% imagesc(img_resample)
% title(str);

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
