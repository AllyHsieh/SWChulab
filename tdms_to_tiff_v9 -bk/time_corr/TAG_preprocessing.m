function xyzt_raw_data_timecorr = TAG_preprocessing(xyzt_raw_data)
% process TAG
%-------------------------------------------------------------------------
%Kai-Chun Jhan - ver 1 2022
%Data Analysis and Interpretation Laboratory,NTHU
%Prof, Shun-Chi Wu
%-output raw mat file instead of porject images
%-------------------------------------------------------------------------
%%
disp("time correction is running");
method = "twoway";
%%
TR_time=87.1; %in msec
dwel_time=1/(188*10^3)*10^(3); %in msec (TAG signal = 188K Hz)
one_line_time=0.6805;%in msec
ztag_dim=62;%in um
x_resolution = size(xyzt_raw_data,1);
y_resolution = size(xyzt_raw_data,2);
z_resolution = size(xyzt_raw_data,3);

TR_num=size(xyzt_raw_data,4);
xyzt_raw_data;

%%  time correction
% 2-1 calculate sample time
sample_time_1st_tr=sample_time_eval(x_resolution, y_resolution, dwel_time, one_line_time, method);%300=256+44
to_be_interp_time=(0:TR_time:TR_time*(TR_num-1));
%%
% 2-2 timing correction
tic
xyzt_raw_data_timecorr=zeros(size(xyzt_raw_data));
for i=1:x_resolution
    for j=1:y_resolution
        [i j];
        sample_time_cur=sample_time_1st_tr(i,j);
        sample_time_cur_all=to_be_interp_time+sample_time_cur;
        for k=1:z_resolution        
                cur_trace= xyzt_raw_data(i,j,k,:);
                cur_trace(isnan(cur_trace)) = 0;
                out_trace = timing_correction_new(squeeze(cur_trace),sample_time_cur_all,to_be_interp_time,'interp1');
                xyzt_raw_data_timecorr(i,j,k,:)=out_trace;
        end
    end
end
%%
clear xyzt_raw_data
disp("time correction is done");
% save(save_name,"xyzt_raw_data_timecorr","-v7.3");

% figure
% plot(squeeze(cur_trace))
% hold on
% plot(squeeze(out_trace))
% title("x = 64, y = 64")
end
