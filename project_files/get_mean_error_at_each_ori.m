function out = get_mean_error_at_each_ori(data,ori,ori_tot)
for i = 1:length(ori_tot)
    out(:,i)=mean(data(:,find(ori==ori_tot(i))),2);
end
end