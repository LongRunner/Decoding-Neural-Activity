function out = get_std_error_at_each_ori(data,ori,ori_tot)
for i = 1:length(ori_tot)
    out(:,i)=std(data(:,find(ori==ori_tot(i))),0,2);
end
end