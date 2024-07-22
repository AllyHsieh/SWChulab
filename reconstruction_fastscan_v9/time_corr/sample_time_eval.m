function sample_time=sample_time_eval(pixel_num, line_num, dwell_time, one_line_time, method)

sample_time=zeros(pixel_num,line_num);
acc_time=0;
switch method
    case "oneway"
        for i=1:line_num
            for j=1:pixel_num
                acc_time=acc_time+dwell_time;
                sample_time(j,i)=acc_time;
            end
        %     acc_time=acc_time+one_line_time;
        end
    case "twoway"
        for i=1:line_num
            if mod(i,2)
                for j=1:pixel_num
                    acc_time=acc_time+dwell_time;
                    sample_time(j,i)=acc_time;
                end
            %     acc_time=acc_time+one_line_time;
            else
                for j=pixel_num:-1:1
                    acc_time=acc_time+dwell_time;
                    sample_time(j,i)=acc_time;
                end
            %     acc_time=acc_time+one_line_time;
            end
        end
end
end