function [training_ori,training_spk_count,testing_ori,testing_spk_count] = ...
    split_data(spk_count,proportion,ori,ori_tot)

training_ori=[];
training_spk_count=[];
testing_ori=[];
testing_spk_count=[];
for i = 1:length(ori_tot)
    found=find(ori==ori_tot(i));
    spk_count_temp=spk_count(:,found);
    
    split_at_indx=ceil(proportion*size(spk_count_temp,2));
    rand_perm=randperm(size(spk_count_temp,2));
    
    ori_temp=ori(found);
    training_ori=cat(2,ori_temp(:,1:split_at_indx),training_ori);
    testing_ori=cat(2,ori_temp(:,split_at_indx:end),testing_ori);
    training_spk_count=cat(2,spk_count_temp(:,rand_perm(:,1:split_at_indx)),training_spk_count);
    testing_spk_count=cat(2,spk_count_temp(:,rand_perm(:,split_at_indx:end)),testing_spk_count);
end

end