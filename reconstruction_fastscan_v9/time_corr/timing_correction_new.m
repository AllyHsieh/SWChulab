% timing correction

function out = timing_correction_new(input_v,input_sample_time,to_be_interp_time,method)
out = 0;
% TR_period_pts --> unit = sample _points
% delta_t: the time interval for each sample point

%input_vect = [time vect, value vect];
switch(method)
%     case 'linear',
%         out = input_vect(1,2)+(to_be_interp_time-input_vect(1,1))*(input_vect(2,2)-input_vect(1,2))/(input_vect(2,1)-input_vect(1,1));
    case 'spline',
        out = spline(input_sample_time,input_v,to_be_interp_time);
    case 'interp1',
        out = interp1(input_sample_time,double(input_v),to_be_interp_time);
%     case 'sinc', % not implemented yet
%         out = 0;
%         L = 10;% 10 sample points
%         xx = input_vect(:,2);
%         n = input_vect(:,1);
%         out = sum(xx.*sinc((to_be_interp_time-n)/TR_period_pts).*(1+cos(pi*delta_t*(to_be_interp_time-n)/L))/2);
end

end